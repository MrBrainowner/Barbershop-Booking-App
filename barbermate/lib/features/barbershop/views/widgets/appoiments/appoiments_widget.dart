import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:barbermate/utils/popups/confirm_cancel_pop_up.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentCard extends StatelessWidget {
  final BookingModel booking;

  const AppointmentCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final BarbershopBookingController controller = Get.find();
    final formatterController = Get.put(BFormatter());

    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.all(10.0),
      title: Text(
        booking.customerName,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: _getStatusColor(booking.status)),
      ),
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          booking.customerProfileImageUrl,
        ),
        child: Text(formatterController.formatInitial(
            booking.customerProfileImageUrl, booking.customerName)),
      ),
      subtitle: Text("From: ${booking.customerName}",
          style: Theme.of(context).textTheme.labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      children: [
        Text('Name: ${booking.customerName}'),
        Text('Phone: ${booking.customerPhoneNo}'),
        const Divider(),
        Text('Hairstyle: ${booking.haircutName}'),
        Text('Price: ${booking.haircutPrice}'),
        Text('Time Slot: ${booking.timeSlot}'),
        Text('Schedule Date: ${booking.date}'),
        const Divider(),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ConfirmCancelPopUp.showDialog(
                      context: context,
                      title: 'Confirm Booking',
                      description: 'Do you want to confirm this request?',
                      textConfirm: 'Confirm',
                      textCancel: 'Cancel',
                      onConfirm: () async {
                        controller.acceptBooking(booking);
                        Get.back();
                      },
                    );
                  },
                  child: const Text('Confirm'),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ConfirmCancelPopUp.showDialog(
                      context: context,
                      title: 'Decline Booking',
                      description: 'Do you want to decline this request?',
                      textConfirm: 'Confirm',
                      textCancel: 'Cancel',
                      onConfirm: () async {
                        controller.rejectBooking(booking);
                        Get.back();
                      },
                    );
                  },
                  child: const Text('Decline'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppointmentConfirmedCard extends StatelessWidget {
  final BookingModel booking;

  const AppointmentConfirmedCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final BarbershopBookingController controller = Get.find();
    final formatterController = Get.put(BFormatter());

    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.all(10.0),
      title: Row(
        children: [
          Text(
            _getTitle(booking.status),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: _getStatusColor(booking.status)),
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          booking.customerProfileImageUrl,
        ),
        child: Text(formatterController.formatInitial(
            booking.customerProfileImageUrl, booking.customerName)),
      ),
      subtitle: Text("Schedule: ${booking.date}",
          style: Theme.of(context).textTheme.labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      children: [
        Text('Name: ${booking.customerName}'),
        Text('Phone: ${booking.customerPhoneNo}'),
        const Divider(),
        Text('Hairstyle: ${booking.haircutName}'),
        Text('Price: ${booking.haircutPrice}'),
        Text('Time Slot: ${booking.timeSlot}'),
        Text('Schedule Date: ${booking.date}'),
        const Divider(),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ConfirmCancelPopUp.showDialog(
                      context: context,
                      title: 'Appointment Complete',
                      description:
                          'Do you want to manually complete this appointment?',
                      textConfirm: 'Confirm',
                      textCancel: 'Cancel',
                      onConfirm: () async {
                        controller.markAsDone(booking);
                        Get.back();
                      },
                    );
                  },
                  child: const Text('Complete'),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ConfirmCancelPopUp.showDialog(
                      context: context,
                      title: 'Cancel Appointment',
                      description: 'Do you want to cancel this appointment?',
                      textConfirm: 'Confirm',
                      textCancel: 'Cancel',
                      onConfirm: () async {
                        controller.cancelBookingForBarbershop(
                            booking, booking.customerId);
                        Get.back();
                      },
                    );
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppointmentDoneCard extends StatelessWidget {
  final BookingModel booking;

  const AppointmentDoneCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final formatterController = Get.put(BFormatter());
    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.all(10.0),
      title: Row(
        children: [
          Text(
            _getTitle(booking.status),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: _getStatusColor(booking.status)),
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          booking.customerProfileImageUrl,
        ),
        child: Text(formatterController.formatInitial(
            booking.customerProfileImageUrl, booking.customerName)),
      ),
      subtitle: Text("From: ${booking.customerName}",
          style: Theme.of(context).textTheme.labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      children: [
        Text('Name: ${booking.customerName}'),
        Text('Phone: ${booking.customerPhoneNo}'),
        const Divider(),
        Text('Hairstyle: ${booking.haircutName}'),
        Text('Price: ${booking.haircutPrice}'),
        Text('Time Slot: ${booking.timeSlot}'),
        Text('Schedule Date: ${booking.date}'),
        const Divider(),
        ListTile(
          title: Text(
            'Status: ${booking.status}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _getStatusColor(booking.status),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}

// Helper to map status to colors
Color _getStatusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'confirmed':
      return Colors.blue;
    case 'done':
      return Colors.green;
    case 'canceled':
      return Colors.red;
    case 'declined':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String _getTitle(String title) {
  switch (title.toLowerCase()) {
    case 'done':
      return 'Appointment Completed';
    case 'declined':
      return 'Appointment Declined';
    case 'pending':
      return 'Appointment Pending';
    case 'confirmed':
      return 'Upcoming Appointment';
    case 'canceled':
      return 'Appointment Canceled';
    default:
      return 'Appointment Unknown';
  }
}
