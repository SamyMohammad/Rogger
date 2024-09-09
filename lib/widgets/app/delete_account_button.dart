import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silah/constants.dart';

import '../../core/app_storage/app_storage.dart';
import '../../core/router/router.dart';
import '../../shared/splash/view.dart';
import '../confirm_button.dart';

class DeleteAccountButton extends StatefulWidget {
  const DeleteAccountButton({Key? key, this.horizontalMargin = 0})
      : super(key: key);

  final double horizontalMargin;

  @override
  State<DeleteAccountButton> createState() => _DeleteAccountButtonState();
}

class _DeleteAccountButtonState extends State<DeleteAccountButton> {
  bool showDeleteButton = true;

  @override
  void initState() {
    getButtonVisibility();
    super.initState();
  }

  void getButtonVisibility() async {
    try {
      final response = await Dio()
          .get('https://sila-321715-default-rtdb.firebaseio.com/isDebug.json');
      showDeleteButton = response.data;
    } catch (e) {
      showDeleteButton = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!showDeleteButton) {
      return SizedBox();
    }
    return ConfirmButton(
      horizontalMargin: 15,
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('هل تريد حذف حسابك نهائيا ؟'),
            actions: [
              CupertinoButton(
                child: Text(
                  'حذف',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  RouteManager.navigateAndPopAll(SplashView());
                  AppStorage.clearCache();
                },
              ),
              CupertinoButton(
                child: Text(
                  'الغاء',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: RouteManager.pop,
              ),
            ],
          ),
        );
      },
      title: "حذف الحساب",
      color: activeButtonColor,
      border: true,
    );
  }
}
