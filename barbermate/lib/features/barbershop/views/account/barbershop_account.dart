import 'package:barbermate/common/controller/shocase_controller.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/controllers/verification_controller/verification_controller.dart';
import 'package:barbermate/features/barbershop/views/account/edit_barbershop_name.dart';
import 'package:barbermate/features/barbershop/views/account/edit_email.dart';
import 'package:barbermate/features/barbershop/views/account/edit_floors.dart';
import 'package:barbermate/features/barbershop/views/account/edit_landmark.dart';
import 'package:barbermate/features/barbershop/views/account/edit_name.dart';
import 'package:barbermate/features/barbershop/views/account/edit_number.dart';
import 'package:barbermate/features/barbershop/views/account/edit_password.dart';
import 'package:barbermate/features/barbershop/views/widgets/verify_barbershop.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:showcaseview/showcaseview.dart';

class BarbershopAccount extends StatelessWidget {
  const BarbershopAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final BarbershopController barbershopController = Get.find();
    final BFormatter format = Get.put(BFormatter());
    final VerificationController vcontroller = Get.find();
    final NotificationsRepo _repo = Get.find();
    final ShowcaseController showcaseController = Get.put(ShowcaseController());
    final deviceStorage = GetStorage();
    final ScrollController scrollController = ScrollController();

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        barbershopController.clear();
      },
      child: ShowCaseWidget(
        builder: (context) {
          if (deviceStorage.read("drawer") == false) {
            Future.delayed(Duration(milliseconds: 500), () async {
              // Smooth scroll animation
              await scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 800), // Adjust speed
                curve: Curves.easeInOut, // Smooth animation curve
              );

              showcaseController.startShowcase(context,
                  [showcaseController.key10, showcaseController.key11]);
              deviceStorage.write("drawer", true);
            });
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Account'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Obx(() {
                // Show loading indicator when data is being fetched
                if (barbershopController.profileLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Access customer data
                final barbershop = barbershopController.barbershop;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image with if statement
                      Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Image.network(
                              barbershop.value.profileImage,
                              fit: BoxFit.cover,
                            )),
                      ),

                      TextButton(
                          onPressed: () =>
                              barbershopController.uploadImage('Profile'),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              iconoir.MediaImagePlus(),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Upload Photo'),
                            ],
                          )),
                      Text(
                        'Credentials',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Divider(),
                      // Full Name
                      CanBeEdited(
                        text:
                            '${barbershop.value.firstName} ${barbershop.value.lastName}',
                        widget: const iconoir.User(),
                        onPressed: () {
                          Get.to(() => const EditNameBarbershop());
                        },
                      ),

                      // Email
                      CanBeEdited(
                        text: barbershop.value.email,
                        widget: const iconoir.Mail(),
                        onPressed: () =>
                            Get.to(() => const BarbershopEditEmail()),
                      ),

                      // Phone Number
                      CanBeEdited(
                        text: barbershop.value.phoneNo,
                        widget: const iconoir.Phone(),
                        onPressed: () =>
                            Get.to(() => const BarbershopEditNumber()),
                      ),

                      CanBeEdited(
                        text: 'Change Password',
                        widget: const iconoir.Lock(),
                        onPressed: () {
                          Get.to(() => const BarbershopEditPassword());
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Barbershop Information',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      const Divider(),
                      Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Obx(
                          () => ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: barbershop
                                    .value.barbershopBannerImage.isEmpty
                                ? const Center(child: Text('Upload Profile'))
                                : Image.network(
                                    barbershop.value.barbershopBannerImage,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () =>
                              barbershopController.uploadImage('Banner'),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              iconoir.MediaImagePlus(),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Upload Banner'),
                            ],
                          )),
                      const Divider(),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Obx(
                          () => ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child:
                                barbershop.value.barbershopProfileImage.isEmpty
                                    ? const Center(child: Text('Upload Logo'))
                                    : Image.network(
                                        barbershop.value.barbershopProfileImage,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () =>
                              barbershopController.uploadImage('Logo'),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              iconoir.MediaImagePlus(),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Upload Logo'),
                            ],
                          )),
                      const Divider(),
                      const SizedBox(height: 10),
                      CanBeEdited(
                        text: barbershop.value.barbershopName,
                        widget: const iconoir.Shop(),
                        onPressed: () =>
                            Get.to(() => const BarbershopEditBarbershopName()),
                      ),

                      CanBeEdited(
                        text: barbershop.value.landMark.isEmpty
                            ? 'None'
                            : barbershop.value.landMark,
                        widget: const iconoir.Neighbourhood(),
                        onPressed: () =>
                            Get.to(() => const BarbershopEditLandMark()),
                      ),

                      CanBeEdited(
                        text: barbershop.value.floorNumber.isEmpty
                            ? 'None'
                            : barbershop.value.floorNumber,
                        widget: const iconoir.Elevator(),
                        onPressed: () =>
                            Get.to(() => const BarbershopEditFloors()),
                      ),

                      const Divider(),
                      CannotBeEdited(
                        text:
                            'Created at ${format.formatDate(barbershop.value.createdAt)}',
                        widget: const iconoir.Calendar(),
                      ),
                      const SizedBox(height: 10),
                      CannotBeEdited(
                        text: barbershop.value.streetAddress,
                        widget: const iconoir.MapPin(),
                      ),
                      const SizedBox(height: 10),
                      CannotBeEdited(
                        text: "Account status ${barbershop.value.status}",
                        widget: const iconoir.UserBadgeCheck(),
                      ),
                      const SizedBox(height: 10),
                      Showcase(
                        key: showcaseController.key10,
                        title: 'Business Documents',
                        description:
                            'Upload the required documents to verify your barbershop',
                        child: Row(
                          children: [
                            barbershop.value.status == 'new' ||
                                    barbershop.value.status == 'pending' ||
                                    barbershop.value.status == 'hold' ||
                                    barbershop.value.status == 'rejected'
                                ? Expanded(
                                    child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        iconoir.BadgeCheck(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        SizedBox(width: 10),
                                        Text('Submit Documents'),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await vcontroller.loadDocuments();
                                      Get.to(() => const VerifyBarbershop());
                                    },
                                  ))
                                : Expanded(
                                    child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.grey)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        iconoir.BadgeCheck(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        SizedBox(width: 10),
                                        Text('Documents Verified'),
                                      ],
                                    ),
                                    onPressed: () async {},
                                  ))
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Showcase(
                        key: showcaseController.key11,
                        title: 'Verify',
                        description:
                            'If all information and documents are completed you can ask for verification to start recieving appointments',
                        child: Row(
                          children: [
                            barbershop.value.status == 'new' ||
                                    barbershop.value.status == 'pending' ||
                                    barbershop.value.status == 'hold' ||
                                    barbershop.value.status == 'rejected'
                                ? Expanded(
                                    child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        iconoir.BadgeCheck(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        SizedBox(width: 10),
                                        Text('Request for Verification'),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await barbershopController
                                          .updateSingleFieldBarbershop(
                                              {'status': 'pending'});
                                      await _repo.sendNotifWhenStatusUpdated(
                                          'from-barbershop',
                                          AuthenticationRepository
                                              .instance.authUser!.uid,
                                          'Approval Request',
                                          '${barbershop.value.barbershopName} is requesting for approval',
                                          null,
                                          'notRead');
                                      Get.back();
                                    },
                                  ))
                                : Expanded(
                                    child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.grey)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        iconoir.BadgeCheck(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        SizedBox(width: 10),
                                        Text('Account Verified'),
                                      ],
                                    ),
                                    onPressed: () async {},
                                  ))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

class CannotBeEdited extends StatelessWidget {
  const CannotBeEdited({
    super.key,
    required this.text,
    required this.widget,
  });

  final String text;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget,
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class CanBeEdited extends StatelessWidget {
  const CanBeEdited({
    super.key,
    required this.text,
    required this.onPressed,
    required this.widget,
  });

  final String text;
  final Widget widget;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget,
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const iconoir.ArrowRight(),
        ),
      ],
    );
  }
}
