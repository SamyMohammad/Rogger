import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/mintainence/view.dart';
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
  StreamSubscription<Map>? streamSubscriptionDeepLink;
  bool navigationCompleted = false; // Prevent duplicate navigation

  @override
  void initState() {
    super.initState();
    FirebaseMessagingHelper.init();
    initializeSplash();

    // Fallback navigation after 10 seconds to prevent hanging
    Future.delayed(Duration(seconds: 2), () {
      if (!navigationCompleted && mounted) {
        print("Fallback triggered");
        navigationToNavBarView();
      }
    });
  }

  Future<void> initializeSplash() async {
    try {
      print("Starting maintenance API call...");
      final response = await DioHelper.get('maintenance').timeout(
        Duration(seconds: 2),
        onTimeout: () {
          print("API call timeout");
          navigationToNavBarView();
          throw TimeoutException("API call timed out");
        },
      );

      if (response.data != null &&
          response.data["data"] != null &&
          response.data["data"].isNotEmpty) {
        bool isUnderMaintenance =
            response.data["data"][0]['maintenance'] == "1";
        if (isUnderMaintenance) {
          navigationToMaintenance();
        } else {
          listenToDeepLinks();
        }
      } else {
        print("Invalid API response: ${response.data}");
        navigationToNavBarView();
      }
    } catch (e) {
      print("Error during API call: $e");
      navigationToNavBarView();
    }
  }

  void listenToDeepLinks() {
    print("Listening to deep links...");
    streamSubscriptionDeepLink = FlutterBranchSdk.listSession().listen((data) {
      print("Deep link data received: $data");
      if (data.containsKey(AppConstants.clickedBranchLink) &&
          data[AppConstants.clickedBranchLink] == true) {
        completeNavigation(() {
          RouteManager.navigateTo(StoreProfileView(
            storeId: data[AppConstants.deepLinkTitle],
          ));
        });
      } else {
        navigationToNavBarView();
      }
    }, onError: (error) {
      print("Error in Branch SDK: $error");
      navigationToNavBarView(); // Fallback navigation
    });
  }

  void navigationToNavBarView() {
    if (!navigationCompleted) {
      navigationCompleted = true;
      if (mounted) {
        RouteManager.navigateAndPopAll(NavBarView());
      }
      // Future.delayed(
      //   Duration(seconds: 2),
      //   () {},
      // );
    }
  }

  void navigationToMaintenance() {
    if (!navigationCompleted) {
      navigationCompleted = true;
      if (mounted) {
        RouteManager.navigateAndPopAll(MaintainenceView());
      }
      // Future.delayed(
      //   Duration(seconds: 2),
      //   () {},
      // );
    }
  }

  void completeNavigation(VoidCallback navigationAction) {
    if (!navigationCompleted) {
      navigationCompleted = true;
      navigationAction();
    }
  }

  @override
  void dispose() {
    streamSubscriptionDeepLink?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF022e47),
      body: Center(
        child: Logo(
          heightFraction: 4,
        ),
      ),
    );
  }
}
