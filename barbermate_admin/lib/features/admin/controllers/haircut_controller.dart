import 'dart:async';
import 'package:barbermate_admin/features/admin/controllers/barbershop_controller.dart';
import 'package:get/get.dart';
import '../../../../data/models/haircut_model/haircut_model.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/haircut_repository.dart';

class HaircutController extends GetxController {
  static HaircutController get instance => Get.find();
  final BarbershopController barbershopController = Get.find();
  final HaircutRepository _haircutRepository = Get.find();

  RxList<HaircutModel> haircuts = <HaircutModel>[].obs;

  var isLoading = true.obs;

  Future<void> fetchHaircutsOnce(String barbershopId) async {
    try {
      isLoading(true); // Show loading indicator

      // Fetch the haircuts once from the repository
      final haircutsList =
          await _haircutRepository.fetchHaircutsOnce(barbershopId);

      // Update the list of haircuts
      haircuts.assignAll(haircutsList);
    } catch (error) {
      // Handle error if any occurs during the fetch
      ToastNotif(message: 'Error fetching haircuts: $error', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading(false); // Stop loading regardless of success or error
    }
  }
}
