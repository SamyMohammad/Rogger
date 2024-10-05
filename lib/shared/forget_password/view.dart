import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/validator/validation.dart';
import 'package:silah/shared/forget_password/cubit/cubit.dart';
import 'package:silah/shared/forget_password/cubit/states.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/custom_tabview.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/text_form_field.dart';

import '../../constants.dart';
import '../../shared_cubit/theme_cubit/cubit.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPassCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("نسيت كلمة المرور", style: TextStyle(fontSize: 14)),
        ),
        body: Builder(
          builder: (context) {
            final cubit = ForgetPassCubit.of(context);
            return Column(
              children: [
                Divider(thickness: 5, height: 0.5, color: kLightGreyColorB4),
                CustomTabview(
                    firstTabTitle: "رقم الجوال",
                    onTap: cubit.toggleIsPhone,
                    secondTabTitle: "البريد الالكتروني"),
                Expanded(
                  child: Form(
                    key: cubit.formKey,
                    child: ListView(
                      padding: largeHorizontalPadding,
                      children: [
                        // FadeInRightBig(
                        //   duration: Duration(milliseconds: 400),
                        //   delay: Duration(milliseconds: 400),
                        //   child: Logo(
                        //     heightFraction: 4,
                        //   ),
                        // ),
                        // FadeInLeftBig(
                        //   duration: Duration(milliseconds: 400),
                        //   delay: Duration(milliseconds: 800),
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(vertical: 15),
                        //     child: Center(
                        //         child: Text(
                        //       'نسيت كلمة المرور  ',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w700,
                        //           color: kPrimaryColor),
                        //     )),
                        //   ),
                        // ),
                        SizedBox(height: 50),
                        FadeInUpBig(
                          duration: Duration(milliseconds: 400),
                          delay: Duration(milliseconds: 1200),
                          child: BlocBuilder<ForgetPassCubit, ForgetPassStates>(
                              builder: (context, state) {
                            return InputFormField(
                              fillColor: kBackgroundColor,
                              hasBorder: true,
                              hint: cubit.isPhone
                                  ? 'ادخل رقم الجوال'
                                  : "ادخل البريد الالكتروني",
                              maxLength: cubit.isPhone ? 10 : 50,
                              isNumber: cubit.isPhone,
                              isNext: false,
                              validator: cubit.isPhone
                                  ? Validator.phoneNumber
                                  : Validator.email,
                              onChanged: (p0) => cubit.checkInputsValidity(),
                              onSave: (v) => cubit.telephone = v,
                            );
                          }),
                        ),
                        BlocBuilder<ForgetPassCubit, ForgetPassStates>(
                          builder: (context, state) {
                            if (state is ForgetPassLoadingState) {
                              return LoadingIndicator();
                            }
                            return FadeInUpBig(
                              duration: Duration(milliseconds: 400),
                              delay: Duration(milliseconds: 1500),
                              child: ConfirmButton(
                                title: "إرسال",
                                verticalMargin: 28,
                                fontColor: cubit.areInputsValid
                                    ? Colors.white
                                    : Color(0xFFA1A1A1),
                                color: cubit.areInputsValid
                                    ? activeButtonColor
                                    : ThemeCubit.of(context).isDark
                                        ? Color(0xFF1E1E26)
                                        : Color(0xffFAFAFF),
                                onPressed: cubit.areInputsValid
                                    ? cubit.forgetPass
                                    : null,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
