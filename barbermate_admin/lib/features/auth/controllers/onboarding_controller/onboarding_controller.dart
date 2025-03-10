import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../views/welcome/welcome_page.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  //variables
  final pageContoller = PageController();
  Rx<int> currentPageIndex = 0.obs;

  // update current index when page scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  // jump to the specific dot selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageContoller.jumpTo(index);
  }

  // updte current index and jump to next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      final storage = GetStorage();
      storage.write('isFirstTime', false);
      Get.offAll(() => const WelcomePage());
    } else {
      int page = currentPageIndex.value + 1;
      pageContoller.jumpToPage(page);
    }
  }

  // upate current indext and jump to last page
  void skipPage() {
    Get.to(() => const WelcomePage());
  }
}
