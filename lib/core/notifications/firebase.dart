import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../../shared/nav_bar/cubit/cubit.dart';
import '../app_storage/app_storage.dart';
import '../dio_manager/dio_manager.dart';

class FirebaseMessagingHelper {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static void init() async {
    onMessage();
    onMessageOpenedApp();
    
    checkIfUserClickedNotificationFromBackground();
  }

  static void onMessage() {
    FirebaseMessaging.onMessage.listen((notification) {
      FlutterRingtonePlayer().play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
        looping: false,
      );
      _handleNotificationReceiver(notification);
    });
  }

  static void onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((notification) {
      _handleNotificationReceiver(notification);
    });
  }

  static void checkIfUserClickedNotificationFromBackground() async {
    final notification = await _firebaseMessaging.getInitialMessage();
    if (notification == null) {
      return;
    }
    _handleNotificationReceiver(notification);
    // RouteManager.navigateAndPopUntilFirstPage(TamidDetailsView(title: notification.notification?.title ?? '', id: notification.data['tamid_id']));
  }

  static Future<void> sendFCMToServer() async {
    if (Platform.isIOS) await _firebaseMessaging.requestPermission();
    String? fcm = await getFCM();
    final body = {
      'token': fcm,
      'customer_id': AppStorage.customerID,
    };
    await DioHelper.post('token', data: body);
  }

  static Future<String?> getFCM() async {
    try {
      final fcm = await _firebaseMessaging.getToken();
      return fcm;
    } catch (_) {
      return '';
    }
  }

  static Future<void> removeTokenFromServer(int userID) async {
    await DioHelper.post('token/reset', data: {'customer_id': userID});
  }

  static Future<void> _handleNotificationReceiver(
      RemoteMessage notification) async {
    NavBarCubit.get(NavBarCubit.currentContext).checkIfHasUnreadMessages();
    // showNotificationDialog(
    //   title: notification.notification?.title ?? '',
    //   body: notification.notification?.body ?? '',
    //   type: notification.data['type'] ?? '',
    // );
  }
}
