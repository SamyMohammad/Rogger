import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silah/shared/nav_bar/view.dart';

import '../../constants.dart';
import '../router/router.dart';

showNotificationDialog({
  required String title,
  required String body,
  required String type,
}) {
  showCupertinoDialog(
    context: RouteManager.currentContext,
    barrierDismissible: false,
    builder: (context) => _Dialog(title, body, type),
  );
}

class _Dialog extends StatelessWidget {
  final String title, body, type;
  _Dialog(this.title, this.body, this.type);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            body,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          actions: [
            CupertinoButton(
              child: Text(
                'الغاء',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: RouteManager.pop,
            ),
            CupertinoButton(
              child: Text(
                'متابعة',
                style: TextStyle(
                  color: kPrimaryColor,
                ),
              ),
              onPressed: () {
                if (type == 'chat') {
                  RouteManager.navigateAndPopAll(NavBarView(initialIndex: 2));
                } else {
                  RouteManager.pop();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
