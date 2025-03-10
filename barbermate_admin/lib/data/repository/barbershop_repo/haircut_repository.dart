import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../models/haircut_model/haircut_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class HaircutRepository extends GetxController {
  static HaircutRepository get instance => Get.find();

  final haircutsCollection = FirebaseFirestore.instance;

  final storage = FirebaseStorage.instance;

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  Future<List<HaircutModel>> fetchHaircutsOnce(String barbershopId) async {
    try {
      // Get the snapshot of the haircuts collection once
      final querySnapshot = await haircutsCollection
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Haircuts')
          .get();

      // Map the documents to a list of HaircutModel
      return querySnapshot.docs.map((doc) {
        return HaircutModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch haircut: $e';
    }
  }
}
