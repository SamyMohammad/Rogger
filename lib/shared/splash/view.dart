import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/nav_bar/view.dart';
import 'package:silah/widgets/logo.dart';

import '../../core/dynamic_links_constants.dart';
import '../../core/notifications/firebase.dart';
import '../../store/store_profile/view.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // StreamSubscription<Map>? streamSubscriptionDeepLink;

  // void listenDeepLinkData(BuildContext context) async {
  //   streamSubscriptionDeepLink = FlutterBranchSdk.listSession().listen((data) {
  //     debugPrint('data: $data');
  //     if (data.containsKey(AppConstants.clickedBranchLink) &&
  //         data[AppConstants.clickedBranchLink] == true) {
  //       // Navigate to relative screen
  //       RouteManager.navigateTo(StoreProfileView(
  //         storeId: data[AppConstants.deepLinkTitle],
  //       ));
  //     }
  //   }, onError: (error) {
  //     PlatformException platformException = error as PlatformException;
  //     debugPrint('exception: $platformException');
  //   });
  // }

  @override
  void initState() {
    super.initState();

    FirebaseMessagingHelper.init();
    listenDeepLinkData(context);

    // listenDeepLinkData(context);
  }

  StreamSubscription<Map>? streamSubscriptionDeepLink;

  void listenDeepLinkData(BuildContext context) async {
    streamSubscriptionDeepLink = FlutterBranchSdk.listSession().listen((data) {
      debugPrint('data: $data');
      if (data.containsKey(AppConstants.clickedBranchLink) &&
          data[AppConstants.clickedBranchLink] == true) {
        // Navigate to relative screen
        print("Navigate to relative screen");
        RouteManager.navigateTo(StoreProfileView(
          storeId: data[AppConstants.deepLinkTitle],
        ));
      } else {
        checkNavigation();
      }
    }, onError: (error) {
      debugPrint('exception: $error');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamSubscriptionDeepLink?.cancel();

    super.dispose();
  }

  void checkNavigation() async {
    Timer(
      Duration(seconds: 2),
      () => RouteManager.navigateAndPopAll(NavBarView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF022e47),
      body: Container(
        child: Logo(
          heightFraction: 4,
        ),
      ),
    );
  }
}
