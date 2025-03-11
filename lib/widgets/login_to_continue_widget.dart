import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silah/shared/login/view.dart';

import '../constants.dart';
import '../core/router/router.dart';
import 'confirm_button.dart';

class LoginToContinueWidget extends StatelessWidget {
  final bool showAppBar;

  // First constructor with AppBar
  const LoginToContinueWidget({Key? key})
      : showAppBar = true,
        super(key: key);

  // Second constructor without AppBar
  const LoginToContinueWidget.withoutAppBar({Key? key})
      : showAppBar = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              leading: IconButton(
                onPressed: () => RouteManager.pop(),
                icon: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(.15)),
                  child: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    weight: 5,
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  SvgPicture.asset(
                    getIcon("roger"),
                    color: Theme.of(context).primaryColor,
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "يجب تسجيل الدخول للمتابعة",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ConfirmButton(
                    color: activeButtonColor,
                    fontColor: Colors.white,
                    title: 'تسجيل الدخول',
                    onPressed: () => RouteManager.navigateTo(LoginView()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
