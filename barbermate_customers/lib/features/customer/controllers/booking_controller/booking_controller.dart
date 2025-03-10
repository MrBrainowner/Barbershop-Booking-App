import 'dart:async';
import 'package:barbermate_customers/common/widgets/toast.dart';
import 'package:barbermate_customers/data/models/timeslot_model/timeslot_model.dart';
import 'package:barbermate_customers/data/models/user_authenthication_model/barbershop_model.dart';
import 'package:barbermate_customers/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate_customers/data/repository/booking_repo/booking_repo.dart';
import 'package:barbermate_customers/features/customer/controllers/barbershop_controller/get_barbershops_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate_customers/features/customer/controllers/notification_controller/notification_controller.dart';
import 'package:get/get.dart';
import '../../../../data/models/booking_model/booking_model.dart';
import '../../../../data/models/haircut_model/haircut_model.dart';
import '../../../../utils/popups/full_screen_loader.dart';

class BookingController extends GetxController {
  static BookingController get instance => Get.find();

  final BookingRepo _repo = Get.find();
  final authId = Get.put(AuthenticationRepository.instance.authUser?.uid);

  final GetBarbershopsController controller = Get.find();
  final CustomerNotificationController notificationController = Get.find();
  final CustomerController customer = Get.find();

  var selectedTimeSlot = Rx<TimeSlotModel?>(null);
  Rx<HaircutModel> selectedHaircut = HaircutModel.empty().obs;

  Rx<BarbershopModel> chosenBarbershop = BarbershopModel.empty().obs;
  var selectedDate = Rx<DateTime?>(DateTime.now());

  Rx<HaircutModel?> toggleHaircut = HaircutModel.empty().obs;
  Rx<TimeSlotModel?> toggleTimeSlot = TimeSlotModel.empty().obs;
  RxBool isLoading = false.obs;

  var averageRating = 0.0.obs;

  // Create a reactive RxList for pending bookings
  RxList<BookingModel> pendingAndConfirmedBookings = <BookingModel>[].obs;
  RxList<BookingModel> doneBookings = <BookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    listenToBookingsStream();
  }

  // Method to set the selected time slot
  void selectTimeSlot(TimeSlotModel timeSlot) {
    if (isTimeSlotSelectable(timeSlot)) {
      if (selectedTimeSlot.value == timeSlot) {
        selectedTimeSlot.value = null; // Deselect if already selected
      } else {
        selectedTimeSlot.value = timeSlot; // Select the new time slot
      }
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;

    // Revalidate the currently selected time slot
    if (selectedTimeSlot.value != null &&
        !isTimeSlotSelectable(selectedTimeSlot.value!)) {
      selectedTimeSlot.value = null; // Deselect invalid time slot
    }
  }

  bool isTimeSlotSelectable(TimeSlotModel timeSlot) {
    // Ensure that the selectedDate value is not null
    if (selectedDate.value == null) {
      return false; // Return false if either the selectedDate or timeSlot is null
    }

    DateTime selectedDateTime = selectedDate.value!;
    DateTime timeSlotDateTime = DateTime(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
      timeSlot.startTime.hour,
      timeSlot.startTime.minute,
    );

    // If selected date is today, disable past time slots
    if (DateTime.now().isAfter(timeSlotDateTime)) {
      return false;
    }

    // If selected date is tomorrow or later, all time slots are selectable
    return true;
  }

  Future<void> refreshData() async {
    selectedTimeSlot.value = TimeSlotModel.empty();
  }

  RxList<BookingModel> bookings = <BookingModel>[].obs;

  void clearBookingData() {
    chosenBarbershop.value = BarbershopModel.empty();
    selectedHaircut.value = HaircutModel.empty();
    selectedTimeSlot.value = TimeSlotModel.empty();
  }

  // Add a new booking
  Future<void> addBooking() async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog(
          'Please wait...', 'assets/images/animation.json');

      final booking = BookingModel(
          barbershopToken: chosenBarbershop.value.fcmToken.toString(),
          customerToken: customer.customer.value.fcmToken.toString(),
          haircutName: selectedHaircut.value.name,
          haircutPrice: selectedHaircut.value.price,
          barberShopId: chosenBarbershop.value.id,
          customerId: authId.toString(),
          haircutId: selectedHaircut.value.id ?? 'None',
          date: controller.formatDate(
              selectedDate.value ?? controller.getNextAvailableDate()),
          timeSlotId: selectedTimeSlot.value!.id.toString(),
          status: 'pending',
          createdAt: DateTime.now(),
          id: '',
          barberId: '',
          customerName:
              '${customer.customer.value.firstName} ${customer.customer.value.lastName}',
          barbershopName: chosenBarbershop.value.barbershopName,
          customerPhoneNo: customer.customer.value.phoneNo,
          timeSlot: selectedTimeSlot.value!.schedule,
          barbershopProfileImageUrl:
              chosenBarbershop.value.barbershopProfileImage,
          customerProfileImageUrl: customer.customer.value.profileImage);

      await _repo.addBooking(
          booking, chosenBarbershop.value, customer.customer.value);

      await notificationController.sendNotifWhenBookingUpdatedCustomers(
          booking,
          'booking',
          'New Appointment!',
          'You just got an appointment from ${booking.customerName}. Please confirm it immidiately.',
          'notRead');

      clearBookingData();
      ToastNotif(message: 'Booking successful', title: 'Succesful')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      FullScreenLoader.stopLoading();
      ToastNotif(message: e.toString(), title: 'Booking Failed')
          .showErrorNotif(Get.context!);
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  // Cancel a booking
  Future<void> cancelBooking(BookingModel booking) async {
    try {
      await _repo.cancelBooking(booking);

      await notificationController.sendNotifWhenBookingUpdatedCustomers(
          booking,
          'booking',
          'Appointment Canceled',
          '${booking.customerName} canceled an appointment',
          'notRead');

      ToastNotif(message: 'Appointment canceled', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(message: 'Error canceling appoiment $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  // Listen to the stream for new bookings
  void listenToBookingsStream() {
    isLoading.value = true;
    // Fetch bookings as a stream
    _repo.fetchBookingsCustomer().listen(
      (newBookings) {
        // If there is new data, update the bookings and show toast
        bookings.assignAll(newBookings);
        filterPendingAndConfirmedBookings();
        filterDoneBookings();

        // Once the first data comes in, stop loading
        if (isLoading.value) {
          isLoading(false);
        }
      },
      onError: (error) {
        // Handle error if any occurs in the stream
        ToastNotif(message: 'Error fetching bookings: $error', title: 'Error')
            .showErrorNotif(Get.context!);
      },
      onDone: () {
        isLoading.value = false; // Stop loading when stream is done
      },
    );
  }

  void filterPendingAndConfirmedBookings() {
    pendingAndConfirmedBookings.value = bookings
        .where((booking) =>
            booking.status == 'confirmed' || booking.status == 'pending')
        .toList();
  }

  void filterDoneBookings() {
    doneBookings.value = bookings
        .where((booking) =>
            booking.status == 'done' ||
            booking.status == 'canceled' ||
            booking.status == 'declined')
        .toList();
  }
}
