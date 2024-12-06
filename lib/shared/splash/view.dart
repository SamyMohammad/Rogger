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
    checkNaviagtionOrListenDeepLink();

    // listenDeepLinkData(context);
  }

  StreamSubscription<Map>? streamSubscriptionDeepLink;

  Future<void> checkNaviagtionOrListenDeepLink() async {
    final response = await DioHelper.get(
      'maintenance',
      // data: {'customer_id': AppStorage.customerID},
    );
    if (response.data["data"][0]['maintenance'] == "1") {
      print(" Navigate to maintainence");
      NavigationToMaintainence();
    } else {
      streamSubscriptionDeepLink =
          FlutterBranchSdk.listSession().listen((data) {
        debugPrint('data:________ $data');
        if (data.containsKey(AppConstants.clickedBranchLink) &&
            data[AppConstants.clickedBranchLink] == true) {
          print("Navigate to relative screen");
          // Navigate to relative screen              print("Navigate to relative screen");

          print("Navigate to relative screen FlutterBranch");
          RouteManager.navigateTo(StoreProfileView(
            storeId: data[AppConstants.deepLinkTitle],
          ));
        } else {
          print("Navigate to relative screen");
          NavigationToNavBarView();
        }
      }, onError: (error) {
        print("error Navigate to relative screen FlutterBranch");
        debugPrint('exception: $error');
      });
    }
  }
//   void listenDeepLinkData(BuildContext context) async {
// if ()

//   }

  @override
  void dispose() {
    streamSubscriptionDeepLink?.cancel();
    super.dispose();
  }

  void NavigationToNavBarView() {
    Timer(
      Duration(seconds: 2),
      () => RouteManager.navigateAndPopAll(NavBarView()),
    );
  }

  void NavigationToMaintainence() async {
    Timer(
      Duration(seconds: 2),
      () => RouteManager.navigateAndPopAll(MaintainenceView()),
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

class MintainenceResponse {
  bool? success;
  List<Data>? data;

  MintainenceResponse({this.success, this.data});

  MintainenceResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? maintenance;

  Data({this.id, this.maintenance});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maintenance = json['maintenance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['maintenance'] = this.maintenance;
    return data;
  }
}
