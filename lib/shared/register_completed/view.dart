import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/nav_bar/view.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/confirm_button.dart';

class RegisterCompletedView extends StatelessWidget {
  const RegisterCompletedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: VIEW_PADDING,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Image.asset('assets/images/check.png'),
              ),
            ),
            Text(
              'لقد تم انشاء الحساب بنجاح',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor),
            ),
            ConfirmButton(
              verticalMargin: 20,
              title: 'الدخول للتطبيق',
              onPressed: () => RouteManager.navigateTo(NavBarView()),
            ),
          ],
        ),
      ),
    );
  }
}
