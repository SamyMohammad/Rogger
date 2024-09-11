import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/nav_bar/view.dart';
import 'package:silah/widgets/logo.dart';

import '../../core/notifications/firebase.dart';

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
    FirebaseMessagingHelper.init();
    checkNavigation();
    // listenDeepLinkData(context);
    super.initState();
  }

  void checkNavigation() async {
    Timer(
      Duration(seconds: 3),
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
