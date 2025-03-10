import 'package:barbermate_admin/data/models/user_authenthication_model/barbershop_model.dart';
import 'package:barbermate_admin/features/admin/controllers/barbershop_controller.dart';
import 'package:barbermate_admin/features/admin/controllers/haircut_controller.dart';
import 'package:barbermate_admin/features/admin/controllers/review_controller.dart';
import 'package:barbermate_admin/features/admin/views/profiles/barbershop.dart';
import 'package:barbermate_admin/features/admin/views/widgets/barbershop_hold.dart';
import 'package:barbermate_admin/utils/constants/format_date.dart';
import 'package:barbermate_admin/utils/popups/confirm_cancel_pop_up.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class BarbershopAccounts extends StatelessWidget {
  const BarbershopAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text('Barbershops'),
      ),
      body: DefaultTabController(
        length: 5, // Number of tabs
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: 'New'),
                Tab(text: 'Pending'),
                Tab(text: 'Approved'),
                Tab(text: 'Rejected'),
                Tab(text: 'Hold'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildBarbershopList('new'),
                  _buildBarbershopList('pending'),
                  _buildBarbershopList('approved'),
                  _buildBarbershopList('rejected'),
                  _buildBarbershopList('hold'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarbershopList(String status) {
    final BarbershopController controller = Get.find();
    final HaircutController hController = Get.find();
    final ReviewController reviewController = Get.find();
    final formatterController = Get.put(BFormatter());

    return Obx(() {
      final filteredBarbershops = controller.barbershops
          .where((barbershop) => barbershop.status == status)
          .toList();

      if (filteredBarbershops.isEmpty) {
        return const Center(child: Text('No barbershops found.'));
      }

      return ListView.builder(
        itemCount: filteredBarbershops.length,
        itemBuilder: (context, index) {
          final barbershop = filteredBarbershops[index];

          return GestureDetector(
            onTap: () async {
              await controller.loadDocuments(barbershop.id);
              await hController.fetchHaircutsOnce(barbershop.id);
              await reviewController.fetchReviews(barbershop.id);
              reviewController.averageRating.value =
                  reviewController.averageRatings[barbershop.id] ?? 0.0;

              Get.to(() => BarbershopProfile(barbershop: barbershop));
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  barbershop.barbershopProfileImage,
                ),
                child: Text(formatterController.formatInitial(
                    barbershop.barbershopProfileImage,
                    barbershop.barbershopName)),
              ),
              title: Text(barbershop.barbershopName),
              subtitle: Text(barbershop.status.capitalizeFirst ?? ''),
              trailing: _buildPopupMenu(status, barbershop, controller),
            ),
          );
        },
      );
    });
  }

  Widget _buildPopupMenu(
    String status,
    BarbershopModel barbershop,
    BarbershopController controller,
  ) {
    return PopupMenuButton<String>(
      icon: status == 'new' || status == 'rejected'
          ? iconoir.ArrowRight(color: Colors.grey)
          : iconoir.ArrowRight(),
      onSelected: (String result) async {
        switch (result) {
          case 'Approve':
            _showConfirmDialog(
              'Approve Barbershop',
              'Are you sure you want to approve this barbershop?',
              () async {
                await controller.updateSingleFieldBarbershop(barbershop.id,
                    null, null, barbershop.fcmToken.toString(), 'approved');
                Get.back();
              },
            );
            break;
          case 'Reject':
            _showConfirmDialog(
              'Reject Barbershop',
              'Are you sure you want to reject this barbershop?',
              () async {
                UpdateBarbershopStatusToHoldWidget.showBottomSheet(
                  barbershopFCM: barbershop.fcmToken.toString(),
                  context: Get.context!,
                  title: 'Reject Barbershop',
                  description:
                      'Please select the reason(s) and add any additional notes.',
                  textConfirm: 'Confirm',
                  textCancel: 'Cancel',
                  barbershopId: barbershop.id,
                  onConfirm: () async {
                    Get.back();
                  },
                  stat: 'rejected',
                );
              },
            );
            break;
          case 'Hold':
            _showConfirmDialog(
              'Hold Barbershop',
              'Are you sure you want to put this barbershop on hold?',
              () async {
                UpdateBarbershopStatusToHoldWidget.showBottomSheet(
                  context: Get.context!,
                  title: 'Hold Barbershop',
                  description:
                      'Please select the reason(s) and add any additional notes.',
                  textConfirm: 'Confirm',
                  textCancel: 'Cancel',
                  barbershopId: barbershop.id,
                  onConfirm: () async {
                    Get.back();
                  },
                  stat: 'hold',
                  barbershopFCM: barbershop.fcmToken.toString(),
                );
              },
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return _getPopupMenuItems(status);
      },
    );
  }

  void _showConfirmDialog(
      String title, String description, Function()? onConfirm) {
    ConfirmCancelPopUp.showDialog(
      context: Get.context!,
      title: title,
      description: description,
      textConfirm: 'Confirm',
      textCancel: 'Cancel',
      onConfirm: onConfirm,
    );
  }

  List<PopupMenuItem<String>> _getPopupMenuItems(String status) {
    switch (status) {
      case 'pending':
        return [
          _buildPopupMenuItem('Approve', Icons.check, Colors.green),
          _buildPopupMenuItem('Reject', Icons.cancel, Colors.red),
        ];
      case 'approved':
        return [
          _buildPopupMenuItem('Hold', Icons.pause, Colors.orange),
        ];
      case 'rejected':
        return [];
      case 'hold':
        return [
          _buildPopupMenuItem('Approve', Icons.check, Colors.green),
        ];
      default:
        return [];
    }
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String value,
    IconData icon,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
