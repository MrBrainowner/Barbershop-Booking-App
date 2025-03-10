import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class ToastNotif extends GetxController {
  static ToastNotif get intance => Get.find();

  final String message;
  final String title;

  ToastNotif({
    required this.message,
    required this.title,
  });

  void showSuccessNotif(context) {
    toastification.show(
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        description: Text(message),
        autoCloseDuration: const Duration(seconds: 5),
        style: ToastificationStyle.flatColored,
        type: ToastificationType.success);
  }

  void showWarningNotif(context) {
    toastification.show(
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        description: Text(message),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.bottomCenter,
        style: ToastificationStyle.flatColored,
        type: ToastificationType.warning);
  }

  void showErrorNotif(context) {
    toastification.show(
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        description: Text(message),
        autoCloseDuration: const Duration(seconds: 5),
        style: ToastificationStyle.flatColored,
        type: ToastificationType.error);
  }

  void showNormalNotif(context) {
    toastification.show(
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        description: Text(message),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.bottomCenter,
        style: ToastificationStyle.flatColored,
        type: ToastificationType.info);
  }
}
