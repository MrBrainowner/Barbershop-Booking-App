import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../models/haircut_model/haircut_model.dart';
import '../auth_repo/auth_repo.dart';

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

  Stream<List<HaircutModel>> fetchHaircutsforCustomers(
    String barberShopId, {
    required bool descending,
  }) {
    try {
      return FirebaseFirestore.instance
          .collection('Barbershops')
          .doc(barberShopId)
          .collection('Haircuts')
          .snapshots() // Use snapshots() for real-time updates
          .map((snapshot) => snapshot.docs
              .map((doc) => HaircutModel.fromSnapshot(doc))
              .toList());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
