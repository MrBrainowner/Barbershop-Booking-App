import 'package:barbermate_admin/data/models/barbershops_verfication_model/document_model.dart';
import 'package:barbermate_admin/data/models/user_authenthication_model/barbershop_model.dart';
import 'package:barbermate_admin/features/admin/controllers/barbershop_controller.dart';
import 'package:barbermate_admin/features/admin/controllers/haircut_controller.dart';
import 'package:barbermate_admin/features/admin/controllers/review_controller.dart';
import 'package:barbermate_admin/features/admin/views/profiles/reviews.dart';
import 'package:barbermate_admin/features/admin/views/widgets/barbershop_profile.dart';
import 'package:barbermate_admin/features/admin/views/widgets/haircutcard2.dart';
import 'package:barbermate_admin/features/admin/views/widgets/update_document_stat.dart';
import 'package:barbermate_admin/utils/constants/format_date.dart';
import 'package:barbermate_admin/utils/popups/confirm_cancel_pop_up.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class BarbershopProfile extends StatelessWidget {
  const BarbershopProfile({super.key, required this.barbershop});

  final BarbershopModel barbershop;

  @override
  Widget build(BuildContext context) {
    const double bannerHeight = 150;
    const double profileHeight = 80;
    const top = bannerHeight - profileHeight / 2;
    const bottom = profileHeight / 2;
    final HaircutController haircutController = Get.find();
    final formatterController = Get.put(BFormatter());
    final ReviewController controller = Get.find();
    final BarbershopController barbershopController = Get.find();

    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              barbershop.barbershopName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: bottom),
                        child: SizedBox(
                          width: double.infinity,
                          height: bannerHeight,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            child: barbershop.barbershopBannerImage.isEmpty
                                ? Image.asset('assets/images/barbershop.jpg',
                                    fit: BoxFit.cover)
                                : CachedNetworkImage(
                                    imageUrl: barbershop.barbershopBannerImage,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: top,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  width: 3,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor)),
                          child: SizedBox(
                            width: 80,
                            height: profileHeight,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2)),
                              child: barbershop.barbershopProfileImage.isEmpty
                                  ? Container(
                                      color: Theme.of(context).primaryColor,
                                      child: Center(
                                        child: Text(
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30),
                                            formatterController.formatInitial(
                                                barbershop
                                                    .barbershopProfileImage,
                                                barbershop.barbershopName)),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl:
                                          barbershop.barbershopProfileImage,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(barbershop.barbershopName,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                    ],
                  ),
                  TabBar(
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      tabs: const [
                        Tab(
                          text: 'About',
                        ),
                        Tab(
                          text: 'Documents',
                        ),
                        Tab(
                          text: 'Haircuts',
                        ),
                      ]),
                  SizedBox(
                    height: 400,
                    child: TabBarView(children: [
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          BarbershopInfos(
                              text: barbershop.streetAddress,
                              widget: const iconoir.MapPin()),
                          const SizedBox(height: 8.0),
                          BarbershopInfos(
                              text: barbershop.phoneNo,
                              widget: const iconoir.Phone()),
                          const SizedBox(height: 8.0),
                          BarbershopInfos(
                              text: barbershop.landMark.isEmpty
                                  ? 'Nearby landmark not specified'
                                  : "Near ${barbershop.landMark}",
                              widget: const iconoir.Neighbourhood()),
                          const SizedBox(height: 8.0),
                          BarbershopInfos(
                              text: barbershop.email,
                              widget: const iconoir.Mail()),
                          const SizedBox(height: 8.0),
                          BarbershopInfos(
                              text: barbershop.floorNumber.isEmpty
                                  ? 'Ground Floor'
                                  : "Floor ${barbershop.floorNumber}",
                              widget: const iconoir.Elevator()),
                          const SizedBox(height: 8.0),
                          BarbershopInfos(
                              text: barbershop.id,
                              widget: const iconoir.UserBadgeCheck()),
                          const SizedBox(height: 8.0),
                          BarbershopInfos(
                              text: barbershop.status,
                              widget: const iconoir.BadgeCheck()),
                          const SizedBox(height: 8.0),
                          OutlinedButton(
                            onPressed: () async {
                              Get.to(() => ReviewsPage(
                                    barberId: barbershop.id,
                                  ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 3),
                                const Text('Reviews'),
                                const SizedBox(width: 3),
                                iconoir.StarSolid(
                                  height: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    // Calculate the average rating
                                    controller.averageRating
                                        .toString(), // Average rating rounded to 1 decimal place
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(width: 3),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5.0),
                        ],
                      ),
                      Obx(() {
                        if (barbershopController.documents.isEmpty) {
                          return Center(child: Text('No documents available'));
                        }
                        return ListView.builder(
                          itemCount:
                              3, // We always display 3 required documents
                          itemBuilder: (context, index) {
                            String documentType = '';
                            String documentStatus =
                                'No Document Found'; // Default message
                            String documentURL = '';

                            // Match index to document type
                            switch (index) {
                              case 0:
                                documentType = 'barangay_clearance';
                                break;
                              case 1:
                                documentType = 'mayors_permit';
                                break;
                              case 2:
                                documentType = 'business_registration';
                                break;
                            }

                            // Search for the document of this type in the uploaded documents
                            final matchingDocument =
                                barbershopController.documents.firstWhere(
                              (doc) =>
                                  doc.documentType == documentType &&
                                  (doc.status == 'pending' ||
                                      doc.status == 'approved'),
                              orElse: () => BarbershopDocumentModel(
                                documentType: documentType,
                                documentURL: '',
                                status: 'No Document Found',
                              ),
                            );

                            documentStatus = matchingDocument.status;
                            documentURL = matchingDocument.documentURL;

                            return ListTile(
                              title: Text(documentType),
                              subtitle: Text('Status: $documentStatus'),
                              trailing: documentStatus == 'approved'
                                  ? Icon(Icons.check,
                                      color: Colors
                                          .green) // Show check icon for approved
                                  : documentStatus == 'pending'
                                      ? PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'approve') {
                                              // Handle approve action
                                              ConfirmCancelPopUp.showDialog(
                                                context: context,
                                                title: 'Approve Document',
                                                description:
                                                    'Are you sure you want to approve this document?',
                                                textConfirm: 'Confirm',
                                                textCancel: 'Cancel',
                                                onConfirm: () async {
                                                  await barbershopController
                                                      .updateDocumentStatus(
                                                          matchingDocument,
                                                          'approved',
                                                          null,
                                                          null,
                                                          barbershop.id,
                                                          barbershop.fcmToken
                                                              .toString());

                                                  await barbershopController
                                                      .loadDocuments(
                                                          barbershop.id);
                                                },
                                              );
                                            } else if (value == 'reject') {
                                              ConfirmCancelPopUp.showDialog(
                                                context: context,
                                                title: 'Reject Document',
                                                description:
                                                    'Are you sure you want to reject this document?',
                                                textConfirm: 'Confirm',
                                                textCancel: 'Cancel',
                                                onConfirm: () async {
                                                  UpdateBarbershopDocumentStatusToHoldWidget
                                                      .showBottomSheet(
                                                          stat: 'rejected',
                                                          matchingDocument:
                                                              matchingDocument,
                                                          context: Get.context!,
                                                          title:
                                                              'Update Document Status',
                                                          description:
                                                              'Please select the reason(s) and add any additional notes.',
                                                          textConfirm:
                                                              'Confirm',
                                                          textCancel: 'Cancel',
                                                          barbershopId:
                                                              barbershop.id,
                                                          barbershopFCM:
                                                              barbershop
                                                                  .fcmToken
                                                                  .toString());
                                                  await barbershopController
                                                      .loadDocuments(
                                                          barbershop.id);
                                                },
                                              );
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem<String>(
                                              value: 'approve',
                                              child: Text('Approve'),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'reject',
                                              child: Text('Reject'),
                                            ),
                                          ],
                                        )
                                      : null, // Do nothing if document is rejected
                              onTap: documentURL.isNotEmpty
                                  ? () => barbershopController.openFile(
                                      Uri.tryParse(
                                          documentURL)) // Open file on tap
                                  : null,
                            );
                          },
                        );
                      }),
                      Obx(() {
                        if (haircutController.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (haircutController.haircuts.isEmpty) {
                          return const Center(
                              child: Text('No haircuts available.'));
                        } else {
                          final haircut = haircutController.haircuts;
                          return GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 columns
                              mainAxisSpacing: 15, // Spacing between rows
                              crossAxisSpacing: 15, // Spacing between columns
                              childAspectRatio: 0.7,
                              mainAxisExtent:
                                  215, // Aspect ratio for vertical cards
                            ),
                            itemCount: haircut.length,
                            itemBuilder: (BuildContext context, int index) {
                              final barbershopHaircut = haircut[index];
                              return HaircutCard2(haircut: barbershopHaircut);
                            },
                          );
                        }
                      }),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
