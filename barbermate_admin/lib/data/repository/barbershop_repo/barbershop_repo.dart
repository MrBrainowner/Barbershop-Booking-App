import 'package:barbermate_admin/data/models/barbershops_verfication_model/document_model.dart';
import 'package:barbermate_admin/data/models/haircut_model/haircut_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../models/user_authenthication_model/barbershop_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BarbershopRepository extends GetxController {
  static BarbershopRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger logger = Logger();

  //======================================= Update any field in specific barbershop collection
  Future<void> updateBarbershopSingleField(
      String barbershopId, String status) async {
    try {
      // list of Futures

      await _db
          .collection("Barbershops")
          .doc(barbershopId)
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

  //================================== stream of barbershops with all status
  Stream<List<BarbershopModel>> fetchAllBarbershopsFromAdmin() {
    try {
      return _db.collection("Barbershops").snapshots().map((querySnapshot) {
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

  Future<List<BarbershopDocumentModel>> fetchDocuments(
      String barbershopId) async {
    try {
      final documentsSnapshot = await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Documents')
          .where('status', isNotEqualTo: 'rejected')
          .get();

      if (documentsSnapshot.docs.isEmpty) {
        return [];
      }

      // Map through the documents and convert each one into BarbershopDocumentModel
      return documentsSnapshot.docs.map((doc) {
        return BarbershopDocumentModel.fromSnapshot(doc);
      }).toList();
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch haircut: $e';
    }
  }

  Future<void> updateDocumentStatus(BarbershopDocumentModel document,
      String status, String barbershopId) async {
    try {
      // Assuming the documentType is unique, we'll use the document's type to filter the document.
      final querySnapshot = await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Documents')
          .where('document_type',
              isEqualTo: document.documentType) // Use the correct field
          .get(); // Get the document snapshot based on query

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (or you can handle multiple docs if necessary)
        final docId = querySnapshot.docs.first.id; // Get the document ID
        await _db
            .collection('Barbershops')
            .doc(barbershopId)
            .collection('Documents')
            .doc(docId) // Use the document ID to update
            .update({
          'status': status,
        });
      } else {
        throw 'Document not found.';
      }
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.code}';
    } on PlatformException catch (e) {
      throw 'Platform error: ${e.code}';
    } catch (e) {
      throw 'Failed to update document status: $e';
    }
  }
}
