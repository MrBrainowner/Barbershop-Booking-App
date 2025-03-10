import 'package:get/get.dart';

import '../features/auth/controllers/signup_controller/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}
