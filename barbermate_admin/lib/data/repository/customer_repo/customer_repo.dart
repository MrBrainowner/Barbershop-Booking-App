import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/user_authenthication_model/customer_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class CustomerRepository extends GetxController {
  static CustomerRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //======================================= Fetch customer details based on user ID
  Stream<List<CustomerModel>> fetchCustomerDetails() {
    try {
      // Use snapshots to listen to real-time updates
      return _db.collection("Customers").snapshots().map((querySnapshot) {
        // Map each document in the snapshot to a CustomerModel
        return querySnapshot.docs.map((doc) {
          return CustomerModel.fromSnapshot(doc);
        }).toList(); // Convert Iterable<CustomerModel> to List<CustomerModel>
      });
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Update any field in specific customer collection (also sync it to Users collection)
  Future<void> updateCustomerSingleField(
      String customerId, String status) async {
    try {
      await _db
          .collection("Customers")
          .doc(customerId)
          .update({'status': status});
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
}
