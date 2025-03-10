import 'package:barbermate_customers/data/repository/auth_repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../models/timeslot_model/timeslot_model.dart';

class TimeslotRepository extends GetxController {
  static TimeslotRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final barbershopId = AuthenticationRepository.instance.authUser?.uid;

  Stream<List<TimeSlotModel>> fetchBarbershopTimeSlotsStream(
      String barbershopId) {
    try {
      return _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Timeslots')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return TimeSlotModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
