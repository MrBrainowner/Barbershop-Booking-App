import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/user_authenthication_model/customer_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../auth_repo/auth_repo.dart';

class CustomerRepository extends GetxController {
  static CustomerRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  //======================================= Save the customer data to firestore
  Future<void> saveCustomerData(CustomerModel customer) async {
    try {
      await _db.collection("Customers").doc(customer.id).set(customer.toJson());
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

  //======================================= Fetch customer details based on user ID
  Stream<CustomerModel> fetchCustomerDetails() {
    try {
      // Use snapshots to listen to real-time updates
      return _db
          .collection("Customers")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .snapshots()
          .map((documentSnapshot) {
        if (documentSnapshot.exists) {
          return CustomerModel.fromSnapshot(documentSnapshot);
        } else {
          return CustomerModel.empty();
        }
      });
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Update customer data in Firestore (also sync it to Users collection)
  Future<void> updateCustomerData(CustomerModel updateCustomer) async {
    try {
      await _db
          .collection("Customers")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(updateCustomer.toJson());
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
  Future<void> updateCustomerSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Customers")
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
  Future<void> removeCustomerRecord(String userId) async {
    try {
      _db.collection("Customers").doc(userId).delete();
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

  //======================================= Upload any image

  Future<String?> fetchProfileImage(String customerId) async {
    try {
      final doc = await _db.collection('Customers').doc(customerId).get();
      if (doc.exists) {
        return doc.data()?['profile_image'];
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<String?> uploadImageToStorage(String type, File file) async {
    try {
      final fileName =
          'Customers/${AuthenticationRepository.instance.authUser?.uid}/Information_images/$type/$file';
      final ref = _storage.ref().child(fileName);

      await ref.putFile(file);

      // Get the download URL
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfileImageInFirestore(
      String customerId, String imageUrl) async {
    try {
      await _db.collection('Customers').doc(customerId).update({
        'profile_image': imageUrl,
      });
    } catch (e) {
      throw Exception('Failed to update profile image in Firestore');
    }
  }

  Future<void> makeCustomerExist() async {
    try {
      await _db
          .collection('Customers')
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update({'existing': true});
    } catch (e) {
      throw Exception('Failed to update barbershop Firestore: $e');
    }
  }
}
