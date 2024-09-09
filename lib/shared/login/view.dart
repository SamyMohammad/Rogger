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
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/saudi_flag_with_num.dart';
import 'package:silah/widgets/text_form_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        appBar: appBar(elevation: false),
        body: BlocBuilder<LoginCubit, LoginStates>(
          builder: (context, state) {
            final cubit = LoginCubit.of(context);
            return Form(
              key: cubit.formKey,
              child: ListView(
                children: [
                  Center(
                      child: SvgPicture.asset(
                    getIcon("logo_text"),
                    height: 50,
                    color: Theme.of(context).primaryColor,
                  )),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Column(
                      children: [
                        InputFormField(
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          hasBorder: true,
                          verticalMargin: 18,
                          horizontalMargin: 5,
                          hint: 'أدخل رقم الجوال',
                          // maxLength: 10,
                          multiLine: false,
                          validator: Validator.phoneNumber,
                          onChanged: (v) => cubit.checkInputsValidity(),
                          onSave: (v) => cubit.telephone = v,
                          suffixIcon: const SaudiFlagWithNum(),
                        ),
                        InputFormField(
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          horizontalMargin: 5,
                          hasBorder: true,
                          hint: 'كلمة المرور',
                          validator: Validator.password,
                          secure: true,
                          onSave: (v) => cubit.password = v,
                          onChanged: (v) => cubit.checkInputsValidity(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(
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
                  ),
                  BlocBuilder<LoginCubit, LoginStates>(
                    builder: (context, state) {
                      return state is LoginLoadingState
                          ? LoadingIndicator()
                          : ConfirmButton(
                              title: 'تسجيل الدخول',
                              color: cubit.areInputsValid
                                  ? activeButtonColor
                                  : kLightGreyColor,
                              onPressed:
                                  cubit.areInputsValid ? cubit.login : null,
                            );
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
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
                          VerticalDivider(thickness: 1, indent: 2),
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
