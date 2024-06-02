import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/location/location_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/home/view.dart';
import 'package:silah/shared/messages/view.dart';
import 'package:silah/shared/nav_bar/cubit/states.dart';
import 'package:silah/shared/select_location/view.dart';
import 'package:silah/shared/setting/view.dart';
import 'package:silah/store/change_map_activity/view.dart';
import 'package:silah/user/advertisers_on_map/view.dart';
import 'package:silah/widgets/login_to_continue_widget.dart';

class NavBarCubit extends Cubit<NavBarStates> {
  NavBarCubit({required this.currentIndex}) : super(NavBarInitState());

  static NavBarCubit get(context) => BlocProvider.of(context);

  int currentIndex;
  bool isGrid = true;

  static BuildContext? currentContext;

  final pages = [
    HomeView(),
    if (AppStorage.getUserModel()?.customerGroup == 2) SChangeMapActivityView(),
    if (AppStorage.getUserModel()?.customerGroup == 1) UAdvertiserOnMapView(),
    if (!AppStorage.isLogged) LoginToContinueWidget(),
    MessagesView(),
    SettingView()
  ];

  final titles = [
    'الرئيسية',
    'حدد موقعك',
    'الرسائل',
    'المزيد',
  ];

  void init() async {
    emit(NavBarLoadingState());
    checkUserIfBanned();
    checkPermissions();
    checkIfHasUnreadMessages();
    checkIfHasNotifications();
    toggleOnlineStatus(true);
    LocationManager.setLocation();
    final isAssigned = await LocationManager.isLocationAssigned();
    if (!isAssigned) {
      RouteManager.navigateAndPopAll(SelectLocationView());
    }
    emit(NavBarInitState());
  }

  void toggleTab(int value) {
    currentIndex = value;
    emit(NavBarInitState());
    checkIfHasUnreadMessages();
    checkIfHasNotifications();
  }

  bool hasUnreadMessages = false;
  bool hasNotifications = false;

  Future<void> checkIfHasUnreadMessages() async {
    if (!AppStorage.isLogged) {
      return;
    }
    try {
      final response = await DioHelper.post('messages/unread_message_check',
          data: {'customer_id': AppStorage.customerID});
      print('checkIfHasUnreadMessages${response.data['message_status']}');
      hasUnreadMessages = response.data['message_status'];
    } catch (e) {}
    emit(NavBarInitState());
  }

  Future<void> checkIfHasNotifications() async {
    if (!AppStorage.isLogged) {
      return;
    }
    try {
      final response = await DioHelper.post(
        'account/check_notifications',
        data: {
          'customer_id': AppStorage.customerID,
          'logged': 'true',
        },
      );
      hasNotifications = response.data['if_there'] != false;
    } catch (e) {}
    emit(NavBarInitState());
  }

  void toggleOnlineStatus(bool online) {
    if (!AppStorage.isLogged) {
      return;
    }
    final ref = FirebaseDatabase.instance.ref('users/${AppStorage.customerID}');
    ref.update({
      'online': online,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void checkPermissions() async {
    // var status = await Permission.storage.status;

    if (Platform.isIOS) {
      bool storage = await Permission.storage.status.isGranted;
      if (storage) {
        // Awesome
      } else {
        // Crap
      }
    } else {
      bool storage = true;
      bool videos = true;
      bool photos = true;

      // Only check for storage < Android 13
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        videos = await Permission.videos.status.isGranted;
        photos = await Permission.photos.status.isGranted;
      } else {
        storage = await Permission.storage.status.isGranted;
      }

      if (storage && videos && photos) {
        // Awesome
      } else {
        // Crap
      }
    }
    // if (!status.isGranted) {
    //   // await Permission.manageExternalStorage.request();
    //   await Permission.storage.request();
    //   await Permission.photos.request();
    //   await Permission.videos.request();
    // }
  }

  void toggleViewMode() {
    isGrid = !isGrid;
    emit(NavBarInitState());
  }

  Widget get getCurrentView => pages[currentIndex];

  String get getCurrentTitle => titles[currentIndex];

  bool get isGridMode => isGrid;
}
