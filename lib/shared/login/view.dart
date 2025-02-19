import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/core/validator/validation.dart';
import 'package:silah/shared/forget_password/view.dart';
import 'package:silah/shared/login/cubit/cubit.dart';
import 'package:silah/shared/login/cubit/states.dart';
import 'package:silah/shared/sign_up/view.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/saudi_flag_with_num.dart';
import 'package:silah/widgets/text_form_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isChecked = false;
  // void _handleRemeberme(bool value) {
  //   _isChecked = value;
  //   SecureStorageHelper.setSecuredString(
  //     SecureStorageKeys.userName,
  //   );
  //   SecureStorageHelper.setSecuredString(
  //     SecureStorageKeys.userPassword,
  //   );
  //   SharedPreferences.getInstance().then(
  //     (prefs) {
  //       prefs.setBool("remember_me", value);
  //       prefs.setString('email', _emailController.text);
  //       prefs.setString('password', _passwordController.text);
  //     },
  //   );
  //   setState(() {
  //     _isChecked = value;
  //   });
  // }
  LoginCubit loginCubit = LoginCubit();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginCubit.loadRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginCubit,
      child: Scaffold(
        appBar: appBar(elevation: false),
        body: BlocBuilder<LoginCubit, LoginStates>(
          builder: (context, state) {
            final cubit = LoginCubit.of(context);
            return Form(
              key: cubit.formKey,
              child: ListView(
                padding: largeHorizontalPadding,
                children: [
                  SizedBox(height: 10),

                  Center(
                      child: SvgPicture.asset(
                    getIcon("roger"),
                    color: Theme.of(context).primaryColor,
                    height: 35,
                  )),
                  SizedBox(height: 50),
                  Column(
                    children: [
                      InputFormField(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        hasBorder: true,
                        verticalMargin: 18,
                        // horizontalMargin: 5,
                        hint: 'أدخل رقم الجوال',
                        // maxLength: 10,
                        multiLine: false,
                        controller: cubit.telephoneController,
                        validator: Validator.phoneNumber,
                        onChanged: (v) => cubit.checkInputsValidity(),
                        onSave: (v) => cubit.telephone = v,
                        suffixIcon: const SaudiFlagWithNum(),
                      ),
                      InputFormField(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        // horizontalMargin: 5,
                        hasBorder: true,
                        hint: 'كلمة المرور',
                        controller: cubit.passwordController,
                        validator: Validator.password,
                        secure: true,
                        onSave: (v) => cubit.password = v,
                        onChanged: (v) => cubit.checkInputsValidity(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            BlocBuilder<LoginCubit, LoginStates>(
                              builder: (context, state) {
                                return SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Checkbox(
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      // width: 2.0,
                                    ),
                                    value: cubit.rememberMe,
                                    onChanged: (value) {
                                      cubit.toggleRememberMe();
                                    },
                                  ),
                                );
                              },
                            ),
                            Text(
                              'تذكرني',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: TextButton(
                      //     onPressed: () {
                      //       RouteManager.navigateTo(ForgetPasswordView());
                      //     },
                      //     child: Text(
                      //       'نسيت كلمة المرور',
                      //       style: TextStyle(
                      //         color: kDarkGreyColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  BlocBuilder<LoginCubit, LoginStates>(
                    builder: (context, state) {
                      return state is LoginLoadingState
                          ? LoadingIndicator()
                          : ConfirmButton(
                              isExpanded: true,
                              title: 'تسجيل الدخول',
                              fontColor: cubit.areInputsValid
                                  ? Colors.white
                                  : Color(0xFFA1A1A1),
                              color: cubit.areInputsValid
                                  ? activeButtonColor
                                  : ThemeCubit.of(context).isDark
                                      ? Color(0xFF1E1E26)
                                      : Color(0xffFAFAFF),
                              onPressed:
                                  cubit.areInputsValid ? cubit.login : null,
                            );
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => RouteManager.navigateTo(SignUpView()),
                          child: Text(
                            "إنشاء حساب جديد",
                            style: TextStyle(
                                color: Color(0xFF5972EA), fontSize: 16),
                          ),
                        ),
                        VerticalDivider(
                          thickness: 1,
                          indent: 2,
                          color: kLightGreyColorB4,
                        ),
                        InkWell(
                          onTap: () =>
                              RouteManager.navigateTo(ForgetPasswordView()),
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                                fontSize: 16, color: kLightGreyColorB4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () =>
                  //       RouteManager.navigateAndPopAll(NavBarView()),
                  //   child: Text(
                  //     'دخول ك زائر',
                  //     style: TextStyle(
                  //         color: Color(0xFF5972EA),
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
