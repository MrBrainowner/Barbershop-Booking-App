import 'dart:convert';
import 'package:barbermate_admin/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate_admin/features/admin/views/notifications/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationServiceRepository.instance.setUpFlutterNotifications();
  await NotificationServiceRepository.instance.showNotification(message);
  print("Background notification received: ${message.messageId}");
}

class NotificationServiceRepository {
  NotificationServiceRepository._();
  static final NotificationServiceRepository instance =
      NotificationServiceRepository._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final _localNofitications = FlutterLocalNotificationsPlugin();
  bool isFlutterLocalNotificationsInialized = false;

  Future<void> initializedNotification() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await requestNotificationPermissions();
    await _setMessageHandlers();
  }

  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> setUpFlutterNotifications() async {
    if (isFlutterLocalNotificationsInialized) {
      return;
    }

    //android
    const channel = AndroidNotificationChannel(
        'high_importance_channel', 'High Importance Notifications',
        description: 'This channel is used for important notifications',
        importance: Importance.high);

    await _localNofitications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const initializeAndroidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializations = InitializationSettings(
      android: initializeAndroidSettings,
    );

    await _localNofitications.initialize(initializations,
        onDidReceiveNotificationResponse: (details) {});

    isFlutterLocalNotificationsInialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNofitications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        )),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setMessageHandlers() async {
    //foreground
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
      print('Foreground notification: ${message.notification?.title}');
    });

    //background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    //opened app
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (AuthenticationRepository.instance.authUser != null) {
      Get.to(()=> AdminNotificationsPage());
    }
  }

  // Fetch and listen for token updates
  Future<void> fetchAndSaveFCMTokenAdmin(String userId) async {
    try {
      // Get the current token
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await saveFCMTokenAdmin(userId, token);
      }
      print(token);
      // Listen for token refresh events
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await saveFCMTokenAdmin(userId, newToken);
      });
    } catch (e) {
      print('Error fetching and saving FCM token: $e');
      rethrow;
    }
  }

  // Add or update FCM token in the database
  Future<void> saveFCMTokenAdmin(String userId, String token) async {
    try {
      await _firestore.collection('Admins').doc(userId).update({
        'adminToken': token,
      });
      print('FCM token saved to database');
    } catch (e) {
      print('Error saving FCM token: $e');
      rethrow;
    }
  }

  // Get the FCM token of a specific customer
  Future<String?> getCustomerFCMToken(String customerId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Customers').doc(customerId).get();
      return userDoc['fcmToken'];
    } catch (e) {
      print('Error fetching FCM token: $e');
      return null;
    }
  }

  // Get the FCM token of a specific barbershop
  Future<String?> getBarbershopFCMToken(String barbershopId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Barbershops').doc(barbershopId).get();
      return userDoc['fcmToken'];
    } catch (e) {
      print('Error fetching FCM token: $e');
      return null;
    }
  }

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      //Your serviceAccoucnt Json Data
      "type": "service_account",
      "project_id": "barbershop-booking-syste-cbffd",
      "private_key_id": "a229a13326ca410af897d0fa49fcd6b0d5884119",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCnc3aLnjKuq6wT\nY+Bj37Ceb1dJiH4IZjW5NA2jyiujofgmmON/b7Xl8AiZCZ8O9mX9z9Gff+yCwn8S\nd29uYnDYFynOju6ctx2kvbgg0Z28cBhFF4Pm/mE5fUdjx14tbniKqPPs3XCJGMXI\nuZbNbJmh5M1d9PfhaIDhXXjOEBy/Tlis8roGC/DNYKaATXyLU7IXkLM8j0wolFPI\nyXwnTM/IYDDhZDTgx7icI4+FHNViJN4V1WaG4b/7DR3lA30gP39wuGQpx59Y0bxG\nBRatoOS4Xu74yEtwrozSOvhs9mj5fesE0t+scXoPZCrgSdobDAfw7s5rVWN4+BzR\n3l0IuiR9AgMBAAECggEAJtfjZ2bGpfsfuw2/lxtkKpR0YJPffI5NJw2anmR+9AHW\nAQoVN9IPlWu1at6u/XcN2K81FrVDhV+dv4hiGm6Oc6oH4ikI0+SsZTM3O7G0T+qG\nzrwyNkrK/d2ASnaMc6h9INkpYEhL2xmag8H9Z+Cp0MK1GvcA61JlFyIqLE7ThFLF\nsLDoz6Jmm5eE9+PJqA1/+cs3n4vNbdz2tSlkoTS1Sw5Mkk14An0mQQNS3RFzeIce\neNTFwmSbgAAlXkH3b+LBdMHCjirgjcKsBLrHMv5nFkTt30xeyis43uzwZNFJEdwe\npAs4Z2sPQbGBUng5ZnvorN+EfBXwKMVP+TpDPGqwoQKBgQDSQ2kKXehYTCIWQc/B\nqXyaHsP4O4/J8xKmQdZrTlfuqaBqhaGnZHAURpm9j35K7vIGIgkyLD3kUdfqUh8o\ncJ6BHmW0ZsOltw5iRtb03PuaZ3NdWwI//KQcueCCu7YAOYTPNrgDZ8DX5uegnLmr\nRlxCPPy8GytPj6U+JIOIt8nTjQKBgQDL4AjZLo4zlBO5Iay6Uh0lEWPsgdH74Pu6\naDlzBw6VqsIa3WwT0n1dypqnNMlpwbxahFeobuiQeLVETigSeezMYmJTNsl/Lq3k\nvwRwaHV/uBpawiJSpBMkpN0tmU+8IJ6Hog45L3kYJ9Eh2h94lWYwq4f1+q5HfsX2\na4JPTsJgsQKBgC9sDrvM1ENd4G4+p5nZHQYxnCdXX6W/kdw3iyGmiMSGM2zy+LOl\nPnYEOlZ7j5Nc8u8ZLBPJ0Ke3Ichyfx6Cz+z1KyEV8FhmwfK+YWrWkFSRsn5CsW43\nD9h+v7kclv7T+jU19SindOH87Q7XajTL6LDzyliulAUcs7shRx1FvlpdAoGBAMOT\nTkmxrH50PZtqX315ijXmAdp/CwY65KEEnJ/pFCelYIFPCf/V+6e+1S8zp0fJrzuS\nG1kb1APLl/BHnY9j4TKL6tDzDMbx66U1TTfcLWNxI+8OrshiV27erMKygNfy3sE0\nR7q5/MucXrW/vlL51sc3tbzVVtyFE7j5l08nObZxAoGAS8HMj2EtictZy/uTnkPC\n27qvbXk2YEVV9Fv+So715d3EoNvHJesA/wJyAhj+oDX4SjKKsouurgRTWd259b7M\nZPMLu0s4DkO369IEkTgIHIC7jro8LjsgFwVr+1KzcdUFNYoo4dXUqtlJD14RECoR\nsn7GnzwBMrutSpUqskbADnc=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "barbermate-push-notification@barbershop-booking-syste-cbffd.iam.gserviceaccount.com",
      "client_id": "111717536647880597897",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/barbermate-push-notification%40barbershop-booking-syste-cbffd.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;
  }

  // Send a notification to a specific user
  Future<void> sendFCMNotificationToUser({
    required String token,
    required String title,
    required String body,
  }) async {
    final String serverKey = await getAccessToken();
    String fcmEndpoint =
        'https://fcm.googleapis.com/v1/projects/barbershop-booking-syste-cbffd/messages:send';

    try {
      final Map<String, dynamic> message = {
        'message': {
          'token': token,
          'notification': {'body': body, 'title': title},
          'data': {
            'customKey': 'admin',
          },
        }
      };
      final response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('Notification sent to user successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
