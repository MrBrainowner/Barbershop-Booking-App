import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseController extends GetxController {
  static ShowcaseController get instance => Get.find();

  final GlobalKey key1 = GlobalKey();
  final GlobalKey key2 = GlobalKey();
  final GlobalKey key3 = GlobalKey();
  final GlobalKey key4 = GlobalKey();
  final GlobalKey key5 = GlobalKey();
  final GlobalKey key6 = GlobalKey();
  final GlobalKey key7 = GlobalKey();
  final deviceStorage = GetStorage();

  var hasTapped = false.obs;

  @override
  void onInit() {
    super.onInit();
    hasTapped.value =
        deviceStorage.read("hasTapped") ?? false; // Load saved state
  }

  void showWelcomeDialog(BuildContext contextt) {
    if (!hasTapped.value) {
      hasTapped.value = true;
      deviceStorage.write("hasTapped", true);
      showDialog(
        context: contextt,
        barrierDismissible: false, // Prevent closing by tapping outside
        builder: (context) => AlertDialog(
          title: Text('Welcome to Barbermate!'),
          content: Text(
              'This is a short introduction to get you started. Press "Next" to continue.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                startShowcase(
                    contextt, [key1, key2, key3, key4, key5, key6, key7]);
              },
              child: Text('Next'),
            ),
          ],
        ),
      );
    }
  }

  // Starts the showcase tutorial
  void startShowcase(BuildContext context, List<GlobalKey> keys) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase(keys));
  }

  // Restarts the showcase tutorial
  void restartShowcase(BuildContext context, List<GlobalKey> keys) {
    startShowcase(context, keys);
  }

  // Skips the showcase
  void skipShowcase(BuildContext context) {
    ShowCaseWidget.of(context).dismiss();
  }
}
