import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silah/core/app_storage/user.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/notifications/firebase.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/splash/view.dart';

import '../../widgets/snack_bar.dart';

class AppStorage {
  static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String? getTheme() {
    return _preferences.getString('theme');
  }

  static Future<void> cacheTheme(ThemeMode themeMode) async {
    await _preferences.setString(
        'theme', themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  static UserModel? getUserModel() {
    final user = _preferences.getString('user');
    print(
      'user: $user',
    );
    if (user != null) return UserModel.fromJson(json.decode(user));
    return null;
  }

  static Future<void> cacheUser(UserModel userModel) async {
    await _preferences.setString('user', json.encode(userModel.toJson()));
  }

  static List<String>? getProduct() {
    final adsList =
        _preferences.getStringList(getUserModel()?.customerId.toString() ?? '');
    if (adsList != null) return adsList;
    return null;
  }

  static Future<void> cacheProduct(String product) async {
    var products = getProduct();
    print('products$products');
    if (products == null) {
      products = [];
    }
    products.add(product);
    
    await _preferences.setStringList(
        getUserModel()!.customerId.toString(), products);
  }
  static List<String>? getAdvertisers() {
    final advertisers =
    _preferences.getStringList(getUserModel()?.customerId.toString() ?? '');
    if (advertisers != null) return advertisers;
    return null;
  }

  static Future<void> cacheAdvertiser(String advertiserId) async {
    var advertisers = getProduct();
    print('products$advertisers');
    if (advertisers == null) {
      advertisers = [];
    }
    advertisers.add(advertiserId);
    await _preferences.setStringList(
        getUserModel()!.customerId.toString(), advertisers);
  }

  static bool get isDark => getTheme() != null;

  static bool get isLogged => getUserModel() != null;

  static bool get isStore => getUserModel()?.customerGroup == 2;

  static int get customerID => getUserModel()?.customerId ?? 0;
  // static int get productID => getProduct() ?? 0;

  static void clearCache() {
    final customerID = AppStorage.customerID;
    FirebaseMessagingHelper.removeTokenFromServer(customerID);
    _preferences.remove('user');
  }
}

Future<void> getUserAndCache(int customerID, int customerGroup) async {
  try {
    final response = await DioHelper.post(
        customerGroup == 2
            ? 'provider/account/account'
            : 'customer/account/account',
        data: {
          'logged': "true",
          'customer_id': customerID,
        });
    final data = response.data as Map<String, dynamic>;
    data.addAll({'customer_id': customerID});
    data.addAll({'customer_group': customerGroup});
    await AppStorage.cacheUser(UserModel.fromJson(data));
    FirebaseMessagingHelper.sendFCMToServer();
  } catch (e, s) {
    print(e);
    print(s);
    throw e;
  }
}

Future<void> checkUserIfBanned() async {
  if (!AppStorage.isLogged) {
    return;
  }
  final response = await DioHelper.post(
    'common/banned/membership_status',
    data: {'customer_id': AppStorage.customerID},
  );
  if (response.data['approved'].toString() != '1') {
    showSnackBar('لقد تم حظرك من التطبيق لمخالفتك احدي القواعد!',
        errorMessage: true);
    AppStorage.clearCache();
    RouteManager.navigateAndPopAll(SplashView());
  }
}
