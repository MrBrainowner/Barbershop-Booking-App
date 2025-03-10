import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../models/haircut_model/haircut_model.dart';
import '../auth_repo/auth_repo.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class HaircutRepository extends GetxController {
  static HaircutRepository get instance => Get.find();

  final CollectionReference haircutsCollection = FirebaseFirestore.instance
      .collection('Barbershops')
      .doc(AuthenticationRepository.instance.authUser?.uid)
      .collection('Haircuts');

  final storage = FirebaseStorage.instance;

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  String generateImageHash(File file) {
    final bytes = file.readAsBytesSync();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String> uploadImageToStorage(XFile imageFile, String haircutId) async {
    String imageUrl = '';

    try {
      final file = File(imageFile.path);
      final imageHash = generateImageHash(file);

      final ref = storage.ref().child(
          'Barbershops/${AuthenticationRepository.instance.authUser?.uid}/haircuts/$haircutId/$imageHash');
      await ref.putFile(file);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }

    return imageUrl;
  }

  Future<String> addHaircut(HaircutModel haircut) async {
    try {
      // Generate a new document reference with an auto-generated ID
      final docRef = haircutsCollection.doc();

      // Set the ID in the haircut model to match the document ID
      haircut.id = docRef.id;

      // Add the haircut data using the generated document ID
      await docRef.set(haircut.toJson());

      // Return the document ID
      return docRef.id;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Updated for single image
  Future<void> updateHaircutImage(String haircutId, String imageUrl) async {
    try {
      // Update the specific document with a single image URL
      await haircutsCollection.doc(haircutId).update({'imageUrl': imageUrl});
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Updated for single image
  Future<void> addHaircutImage(String haircutId, String imageUrl) async {
    try {
      // Update the document with a new single image URL
      await haircutsCollection.doc(haircutId).update({
        'imageUrl': imageUrl,
      });
    } on FirebaseException catch (e) {
      logger.e('FirebaseException: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('FormatException occurred');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e('PlatformException: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateHaircut({
    required String haircutId,
    required HaircutModel updatedHaircut,
    XFile? newImageFile, // Optional new image file
  }) async {
    try {
      // Fetch the current haircut details from Firestore
      final haircutDoc = await haircutsCollection.doc(haircutId).get();

      if (haircutDoc.exists) {
        final HaircutModel currentHaircut = HaircutModel.fromSnapshot(
            haircutDoc as DocumentSnapshot<Map<String, dynamic>>);

        // If a new image is provided, handle the image replacement
        if (newImageFile != null) {
          // Delete the old image from Firebase Storage if it exists
          if (currentHaircut.imageUrl.isNotEmpty) {
            await deleteImage(currentHaircut.imageUrl);
          }

          // Upload the new image to Firebase Storage
          final newImageUrl =
              await uploadImageToStorage(newImageFile, haircutId);

          // Update the haircut model with the new image URL
          updatedHaircut.imageUrl = newImageUrl;
        } else {
          // Keep the old image URL if no new image is uploaded
          updatedHaircut.imageUrl = currentHaircut.imageUrl;
        }

        // Update the haircut data in Firestore
        await haircutsCollection.doc(haircutId).update(updatedHaircut.toJson());
      } else {
        logger.d('Haircut not found');
      }
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteHaircut(String haircutId) async {
    try {
      // Fetch the haircut document to get the image URL
      final docSnapshot = await haircutsCollection.doc(haircutId).get();
      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data['imageUrl'] != null) {
        final String imageUrl = data['imageUrl'];

        // Delete the image from Firebase Storage
        await deleteImage(imageUrl);
      }
      // Delete the haircut document from Firestore
      await haircutsCollection.doc(haircutId).delete();
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Stream<List<HaircutModel>> fetchAllHaircuts() {
    try {
      return haircutsCollection
          .snapshots() // Use snapshots() for real-time updates
          .map((snapshot) => snapshot.docs
              .map((doc) => HaircutModel.fromSnapshot(
                  doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Future<List<HaircutModel>> fetchHaircutsOnce() async {
  //   try {
  //     // Get the snapshot of the haircuts collection once
  //     final querySnapshot = await haircutsCollection.get();

  //     // Map the documents to a list of HaircutModel
  //     return querySnapshot.docs.map((doc) {
  //       return HaircutModel.fromSnapshot(
  //           doc as DocumentSnapshot<Map<String, dynamic>>);
  //     }).toList();
  //   } on FirebaseException catch (e) {
  //     throw BFirebaseException(e.code).message;
  //   } on PlatformException catch (e) {
  //     throw BPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Failed to fetch haircut: $e';
  //   }
  // }

  Future<void> deleteImageAndRemoveUrl(
      String haircutId, String imageUrl) async {
    try {
      // Remove the image URL from Firestore
      await removeImageUrlFromFirestore(haircutId, imageUrl);

      // Delete the image from Firebase Storage
      await deleteImage(imageUrl);

      logger.i('Image successfully deleted and URL removed.');
    } catch (e) {
      logger.e('Error in deleting image and removing URL: $e');
      throw 'Error in deleting image and removing URL: $e';
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to delete image: $e';
    }
  }

  Future<void> removeImageUrlFromFirestore(
      String haircutId, String imageUrl) async {
    try {
      // Remove the image URL from the Firestore document
      await haircutsCollection.doc(haircutId).update({
        'imageUrl': imageUrl,
      });
      logger.i('Image URL removed from Firestore: $imageUrl');
    } on FirebaseException catch (e) {
      logger.e('FirebaseException: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      logger.e('PlatformException: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Failed to remove image URL from Firestore: $e');
      throw 'Failed to remove image URL from Firestore: $e';
    }
  }
}
