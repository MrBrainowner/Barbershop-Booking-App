import 'package:barbermate/data/models/barbershops_verfication_model/document_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/verification_controller/verification_controller.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:path/path.dart'; // Import path package to use basename

class VerifyBarbershop extends StatelessWidget {
  const VerifyBarbershop({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text('Verify Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload your business documents:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            // Individual tiles for each document type
            Expanded(
                child: ListView(
              children: [
                Obx(() {
                  final file =
                      controller.selectedFiles['business_registration'];
                  final fileName = file != null ? basename(file.path) : 'None';
                  final status = controller.documents
                      .firstWhere(
                          (doc) => doc.documentType == 'business_registration',
                          orElse: () => BarbershopDocumentModel(
                              documentType: '', documentURL: ''))
                      .status;

                  return ListTile(
                      title: Text('Business Registration'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              file == null ? 'No Document' : 'File: $fileName'),
                          Text('Status: ${file == null ? 'None' : status}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(file != null
                                ? _getColors(status)
                                : Colors.grey)),
                        onPressed: () {
                          if (file == null) {
                            controller.pickFile('business_registration');
                          }
                        },
                        child: file == null ? Text('upload') : _getText(status),
                      ));
                }),
                Obx(() {
                  final file = controller.selectedFiles['barangay_clearance'];
                  final fileName = file != null ? basename(file.path) : 'None';
                  final status = controller.documents
                      .firstWhere(
                          (doc) => doc.documentType == 'barangay_clearance',
                          orElse: () => BarbershopDocumentModel(
                              documentType: '', documentURL: ''))
                      .status;

                  return ListTile(
                      title: Text('Barangay Clearance'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              file == null ? 'No Document' : 'File: $fileName'),
                          Text('Status: ${file == null ? 'None' : status}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(file != null
                                ? _getColors(status)
                                : Colors.grey)),
                        onPressed: () {
                          if (file == null) {
                            controller.pickFile('barangay_clearance');
                          }
                        },
                        child: file == null ? Text('upload') : _getText(status),
                      ));
                }),
                Obx(() {
                  final file = controller.selectedFiles['mayors_permit'];
                  final fileName = file != null ? basename(file.path) : 'None';
                  final status = controller.documents
                      .firstWhere((doc) => doc.documentType == 'mayors_permit',
                          orElse: () => BarbershopDocumentModel(
                              documentType: '', documentURL: ''))
                      .status;

                  return ListTile(
                      title: Text('Mayors Permit'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              file == null ? 'No Document' : 'File: $fileName'),
                          Text('Status: ${file == null ? 'None' : status}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(file != null
                                ? _getColors(status)
                                : Colors.grey)),
                        onPressed: () {
                          if (file == null) {
                            controller.pickFile('mayors_permit');
                          }
                        },
                        child: file == null ? Text('upload') : _getText(status),
                      ));
                }),
              ],
            )),
            const SizedBox(height: 24),
            // Submit button visible if not all documents are approved
            Obx(() {
              // Check if all required document types have files selected
              final allFilled = controller.requiredDocumentTypes
                  .every((type) => controller.selectedFiles[type] != null);

              // Check if all documents are approved
              final allApproved = controller.documents.isNotEmpty &&
                  controller.documents.every((doc) => doc.status == 'approved');

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: allFilled
                      ? controller.submitFiles
                      : null, // Disable if not all files are selected
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allFilled
                        ? null
                        : Colors
                            .grey, // Optional: Greyed out for disabled state
                  ),
                  child: const Text('Submit All Documents'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Helper function to return the appropriate icon based on the document status
  Text _getText(String? status) {
    switch (status) {
      case 'approved':
        return Text('Approved');
      case 'pending':
        return Text('Pending');
      default:
        return Text('None');
    }
  }

  Color _getColors(String? status) {
    if (status == 'approved') {
      return Colors.green;
    } else if (status == 'pending') {
      return Colors.black;
    } else {
      return Colors.grey;
    }
  }
}
