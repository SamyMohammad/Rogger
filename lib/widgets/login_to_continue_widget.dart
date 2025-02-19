import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silah/shared/login/view.dart';

import '../constants.dart';
import '../core/router/router.dart';
import 'confirm_button.dart';

class LoginToContinueWidget extends StatelessWidget {
  const LoginToContinueWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              onPressed: () => RouteManager.navigateAndPopAll(LoginView()),
            ),
            // Row(
            //   children: [],
            // ),
          ],
        ),
      ),
    );
  }
}
