import 'package:barbermate_admin/common/widgets/toast.dart';
import 'package:barbermate_admin/data/models/user_authenthication_model/customer_model.dart';
import 'package:barbermate_admin/data/repository/customer_repo/customer_repo.dart';
import 'package:barbermate_admin/data/repository/notifications_repo/notifications_repo.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class CustomerController extends GetxController {
  static CustomerController get instance => Get.find();
  final CustomerRepository repository = Get.find();
  final NotificationsRepo _repo = Get.find();

  // Observable list of customers
  final customers = <CustomerModel>[].obs;
  final Logger logger = Logger();

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  void fetchCustomers() {
    // Assuming you have a repository instance available

    repository.fetchCustomerDetails().listen((customerList) {
      customers.assignAll(
          customerList); // Update observable list with fetched customers
    }, onError: (error) {
      // Handle any errors during data fetching
      logger.e("Error fetching barbershop by ID: $error");
    });
  }

  Future<void> updateCustomerField(String customerId, String status,
      String? notes, List<String>? reasons, String customerToken) async {
    try {
      await repository.updateCustomerSingleField(customerId, status);
      await _repo.sendNotifWhenStatusUpdatedCustomer(
          'customer-status',
          customerId,
          'Account Status',
          'Your account is ${status == 'banned' ? status : 'lifted'}',
          notes,
          reasons,
          'notRead',
          customerToken);
      ToastNotif(
        message: 'Status updated successfully.',
        title: 'Success',
      ).showSuccessNotif(Get.context!);
      Get.back();
    } catch (error) {
      ToastNotif(
        message: error.toString(),
        title: 'Error',
      ).showErrorNotif(Get.context!);
      logger.e("Error fetching barbershop by ID: $error");
    }
  }
}
