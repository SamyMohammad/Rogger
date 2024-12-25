import 'package:flutter/material.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/store/change_map_activity/view.dart';

Future showConfirmationDialog(
    {required String title,
    required String subTitle,
    required BuildContext context,
    VoidCallback? onSubmit,
    final String? submitTitle,
    final String? cancelTitle}) async {
  //Remove Keyboard Focus
  FocusManager.instance.primaryFocus!.unfocus();

  return showDialog(
      context: RouteManager.currentContext,
      builder: (context) => AlertDialog(
            // backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 15),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedRoundedButton(
                    isSignOut: true,
                    backgroundColor: Theme.of(context).appBarTheme.backgroundColor!,
                    icon: const SizedBox(),
                    title: "خروج",
                    titleColor: Color(0xFFFD6E6E),
                    borderColor: Color(0xFFFEE2E1),
                    onTap: () {
                      Navigator.pop(context);
                      if (onSubmit != null) {
                        onSubmit();
                      }
                    },
                  ),
                  const SizedBox(height: 4),
                  ElevatedRoundedButton(
                    isSignOut: true,
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor!,
                    icon: const SizedBox(),
                    title: "إلغاء",
                    titleColor: Color(0xFF6B8EFF),
                    borderColor: Color(0xFFE3EFFF),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ));
}
