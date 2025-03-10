import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/user_authenthication_model/customer_model.dart';
import '../auth_repo/auth_repo.dart';

class CustomerRepository extends GetxController {
  static CustomerRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
}
