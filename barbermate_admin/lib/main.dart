import 'package:barbermate_admin/data/services/push_notification/push_notification.dart';
import 'package:barbermate_admin/routes/app_pages.dart';
import 'package:barbermate_admin/utils/popups/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toastification/toastification.dart';
import 'bindings/general_bindings.dart';
import 'data/repository/auth_repo/auth_repo.dart';
import 'firebase_options.dart';
import 'utils/themes/barbermate_theme.dart';

void main() async {
  // Ensure widgets binding is initialized before any platform channel usage
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for the main application
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Notification
  await NotificationServiceRepository.instance.initializedNotification();

  // Initialize GetStorage
  await GetStorage.init();

  // Preserve the splash screen
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  // Register Authentication Repository
  Get.put(AuthenticationRepository());

  // Run the app
  runApp(const BetterFeedback(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: BarbermateTheme.lightTheme,
        darkTheme: BarbermateTheme.darktTheme,
        initialBinding: GeneralBindings(),
        smartManagement: SmartManagement.full,
        getPages: RoleBasedPage.getPages(),
        home: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: const Center(
            child: AnimationLoader(
              animation: 'assets/images/animation.json',
              text: 'Loading...',
            ),
          ),
        ),
      ),
    );
  }
}
