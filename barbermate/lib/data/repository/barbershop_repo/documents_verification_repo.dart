import 'dart:io';
import 'dart:async';
import 'package:barbermate/data/models/barbershops_verfication_model/document_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/utils/exceptions/firebase_exceptions.dart';
import 'package:barbermate/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class VerificationRepo extends GetxController {
  static VerificationRepo get instance => Get.find();

  final Logger logger = Logger();
  final _firestore = FirebaseFirestore.instance;

  /// Uploads a file to Firebase Storage and adds the document details to Firestore
  Future<void> uploadFile(File file, String documentType) async {
    try {
      final fileName = basename(file.path);
      final barbershopId =
          AuthenticationRepository.instance.authUser?.uid ?? '';

      if (barbershopId.isEmpty) {
        throw Exception('No authenticated user found.');
      }

      // Upload the file to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref('Barbershops/$barbershopId/documents/$documentType/$fileName');
      final uploadTask = storageRef.putFile(file);

      // Set a timeout for the file upload
      final timeoutDuration =
          Duration(seconds: 60); // Set timeout duration here
      final uploadWithTimeout = uploadTask
          .whenComplete(() => null)
          .timeout(timeoutDuration, onTimeout: () {
        uploadTask.cancel(); // Cancel the task if timeout occurs
        throw TimeoutException(
            'File upload took too long and was cancelled due to slow internet.');
      });

      await uploadWithTimeout;

      final downloadUrl = await storageRef.getDownloadURL();

      // Add the document to Firestore under the barbershop documents collection
      final documentData = BarbershopDocumentModel(
        documentType: documentType,
        documentURL: downloadUrl,
      ).toJson();

      // Store each document as an individual document
      final documentRef = _firestore
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Documents')
          .doc(); // Using auto-generated document ID

      await documentRef.set(documentData);

      logger.i('Document $documentType uploaded and saved successfully.');
    } catch (e) {
      logger.e('Error uploading file: $e');
      if (e is TimeoutException) {
        // Handle the timeout error gracefully
        throw Exception('File upload timed out due to slow internet.');
      }
    }
  }

  /// Fetches the list of documents for the current barbershop
  Future<List<BarbershopDocumentModel>> fetchDocuments() async {
    try {
      final documentsSnapshot = await _firestore
          .collection('Barbershops')
          .doc(AuthenticationRepository.instance.authUser!.uid)
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
}
