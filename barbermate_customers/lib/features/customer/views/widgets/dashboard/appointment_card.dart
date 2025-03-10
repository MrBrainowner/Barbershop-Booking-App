import 'package:barbermate_customers/common/widgets/toast.dart';
import 'package:barbermate_customers/data/models/booking_model/booking_model.dart';
import 'package:barbermate_customers/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/review_controller/review_controller.dart';
import 'package:barbermate_customers/utils/constants/format_date.dart';
import 'package:barbermate_customers/utils/popups/confirm_cancel_pop_up.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class AppointmentCardCustomers extends StatelessWidget {
  final BookingModel booking;
  const AppointmentCardCustomers({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find();
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
          booking.barbershopProfileImageUrl,
        ),
        child: Text(formatterController.formatInitial(
            booking.customerProfileImageUrl, booking.barbershopName)),
      ),
      subtitle: Text("Schedule: ${booking.date}",
          style: Theme.of(context).textTheme.labelSmall),
      children: [
        Text('Barbershop: ${booking.barbershopName}'),
        const Divider(),
        Text('Hairstyle: ${booking.haircutName}'),
        Text('Price: ${booking.haircutPrice}'),
        Text('Time Slot: ${booking.timeSlot}'),
        Text('Schedule Date: ${booking.date}'),
        const Divider(),
        Text('Status: ${booking.status}'),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                        controller.cancelBooking(booking);
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

class AppointmentConfirmedCardCustomers extends StatelessWidget {
  final BookingModel booking;

  const AppointmentConfirmedCardCustomers({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find();
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
          booking.barbershopProfileImageUrl,
        ),
        child: Text(formatterController.formatInitial(
            booking.customerProfileImageUrl, booking.barbershopName)),
      ),
      subtitle: Text("Schedule: ${booking.date}",
          style: Theme.of(context).textTheme.labelSmall),
      children: [
        Text('Barbershop: ${booking.barbershopName}'),
        const Divider(),
        Text('Hairstyle: ${booking.haircutName}'),
        Text('Price: ${booking.haircutPrice}'),
        Text('Time Slot: ${booking.timeSlot}'),
        Text('Schedule Date: ${booking.date}'),
        const Divider(),
        Text('Status: ${booking.status}'),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                        controller.cancelBooking(booking);
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

class AppointmentDoneCardCustomers extends StatelessWidget {
  final BookingModel booking;

  const AppointmentDoneCardCustomers({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final formatterController = Get.put(BFormatter());
    final ReviewControllerCustomer controller = Get.find();

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
          booking.barbershopProfileImageUrl,
        ),
        child: Text(formatterController.formatInitial(
            booking.customerProfileImageUrl, booking.barbershopName)),
      ),
      subtitle: Text(booking.barbershopName,
          style: Theme.of(context).textTheme.labelSmall),
      children: [
        Text('Barbershop: ${booking.barbershopName}'),
        const Divider(),
        Text('Hairstyle: ${booking.haircutName}'),
        Text('Price: ${booking.haircutPrice}'),
        Text('Time Slot: ${booking.timeSlot}'),
        Text('Schedule Date: ${booking.date}'),
        const Divider(),
        Text('Status: ${booking.status}'),
        SizedBox(
          width: double.infinity,
          child: booking.status == 'canceled' || booking.status == 'declined'
              ? ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.grey.shade300)),
                  onPressed: () {},
                  child: const Text('Review not available'),
                )
              : booking.isReviewed == false
                  ? ElevatedButton(
                      onPressed: () =>
                          _showWriteReviewDialog(context, controller, booking),
                      child: const Text('Write a Review'),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.grey.shade300)),
                      onPressed: () {},
                      child: const Text('Reviewed'),
                    ),
        ),
      ],
    );
  }
}

void _showWriteReviewDialog(BuildContext context,
    ReviewControllerCustomer controller, BookingModel booking) {
  double userRating = 0.0; // Initialize the rating

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Write a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.reviewText,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                hintText: 'Write your experience here...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            const Text('Rating:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            RatingBar.builder(
              initialRating: userRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                userRating = rating;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.reviewText.text.isNotEmpty && userRating > 0) {
                controller.review.value.rating = userRating;
                controller.addReview(booking.barberShopId, booking.id);

                Get.back();
              } else {
                ToastNotif(
                        message: 'Please provide a valid review and rating.',
                        title: 'Invalid Input')
                    .showErrorNotif(Get.context!);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
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
