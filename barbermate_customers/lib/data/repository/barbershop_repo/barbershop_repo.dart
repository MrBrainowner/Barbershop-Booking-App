import 'package:barbermate_customers/data/models/haircut_model/haircut_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../models/user_authenthication_model/barbershop_model.dart';

class BarbershopRepository extends GetxController {
  static BarbershopRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger logger = Logger();

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

  //================================== stream of barbershops with all status
  Stream<List<BarbershopModel>> fetchAllBarbershopsFromAdmin() {
    try {
      return _db
          .collection("Barbershops")
          .where("status", isEqualTo: "approved")
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
}
