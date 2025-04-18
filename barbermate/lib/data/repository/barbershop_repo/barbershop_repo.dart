import 'dart:io';
import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_authenthication_model/barbershop_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../auth_repo/auth_repo.dart';

class BarbershopRepository extends GetxController {
  static BarbershopRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final Logger logger = Logger();

  //======================================= Save the barbershop data to firestore
  Future<void> saveBarbershopData(BarbershopModel barbershop) async {
    try {
      await _db
          .collection("Barbershops")
          .doc(barbershop.id)
          .set(barbershop.toJson());
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

  //======================================= Fetch barbershop details based on user ID (when the current user is barbershop)
  Stream<BarbershopModel> barbershopDetailsStream() {
    try {
      return _db
          .collection("Barbershops")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .snapshots()
          .map((documentSnapshot) {
        if (documentSnapshot.exists) {
          return BarbershopModel.fromSnapshot(documentSnapshot);
        } else {
          return BarbershopModel.empty();
        }
      });
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

  //======================================= Update customer data in Firestore (also sync it to Users collection)
  Future<void> updateBarbershopData(BarbershopModel updateBarbershop) async {
    try {
      await _db
          .collection("Barbershops")
          .doc(updateBarbershop.id)
          .update(updateBarbershop.toJson());
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

  //======================================= Update any field in specific customer collection (also sync it to Users collection)
  Future<void> updateBarbershopSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Barbershops")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
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

  //======================================= Remove customer data from Firestore
  Future<void> removeBarbershopRecord(String userId) async {
    try {
      await _db.collection("Barbershops").doc(userId).delete();
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

  //================================== stream of barbershops
  Stream<List<BarbershopModel>> fetchAllBarbershops() {
    try {
      return _db
          .collection("Barbershops")
          .where('status', isEqualTo: 'approved')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return BarbershopModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
    } catch (e) {
      throw 'Error fetching barbershops: $e';
    }
  }

  //================================== stream of barbershop haircuts
  Stream<List<HaircutModel>> fetchBarbershopHaircuts(String barbershopId) {
    try {
      return _db
          .collection("Barbershops")
          .doc(barbershopId)
          .collection('Haircuts')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return HaircutModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
    } catch (e) {
      throw 'Error fetching barbershop haircuts: $e';
    }
  }

  //================================== upload image to storage

  Future<String?> uploadImageToStorage(XFile file, String type) async {
    try {
      // Generate a unique file name using UUID
      const uuid = Uuid();
      final uniqueFileName =
          '${uuid.v4()}_${file.name}'; // Unique name + original file name

      final ref = _storage.ref().child(
          'Barbershops/${AuthenticationRepository.instance.authUser?.uid}/Information_images/$type/$uniqueFileName');

      // Upload the file to Firebase Storage
      await ref.putFile(File(file.path));

      // Get the download URL
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  //================================== udate image in firestore
  Future<void> updateProfileImageInFirestore(
      String imageUrl, String type) async {
    try {
      switch (type) {
        case 'Profile':
          await _db
              .collection('Barbershops')
              .doc(AuthenticationRepository.instance.authUser?.uid)
              .update({
            'profile_image': imageUrl,
          });
          break;
        case 'Banner':
          await _db
              .collection('Barbershops')
              .doc(AuthenticationRepository.instance.authUser?.uid)
              .update({
            'barbershop_banner_image': imageUrl,
          });
          break;
        case 'Logo':
          await _db
              .collection('Barbershops')
              .doc(AuthenticationRepository.instance.authUser?.uid)
              .update({
            'barbershop_profile_image': imageUrl,
          });
      }
    } catch (e) {
      throw Exception('Failed to update profile image in Firestore');
    }
  }

  //================================== make barbershop exist for profile setup to happen once
  Future<void> makeBarbershopExist() async {
    try {
      await _db
          .collection('Barbershops')
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update({'existing': true});
    } catch (e) {
      throw Exception('Failed to update barbershop Firestore: $e');
    }
  }
}
