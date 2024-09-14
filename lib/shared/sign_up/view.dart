import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/core/validator/validation.dart';
import 'package:silah/shared/login/view.dart';
import 'package:silah/shared/sign_up/cubit/cubit.dart';
import 'package:silah/shared/sign_up/cubit/states.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/bottom_sheet_picker.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/saudi_flag_with_num.dart';
import 'package:silah/widgets/text_form_field.dart';

import '../../constants.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: Scaffold(
        appBar: appBar(
          elevation: false,
        ),
        body: BlocBuilder<SignUpCubit, SignUpStates>(
          builder: (context, state) {
            final cubit = SignUpCubit.of(context);
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
                  SizedBox(height: 30),
                  BottomSheetPicker(
                    items: [
                      'زبون',
                      'معلن',
                    ],
                  ),

                  // DropMenu(
                  //     hint: "نوع الحساب",
                  //     items: ['زبون', 'معلن'],
                  //     isMapDepartment: false,
                  //     onChanged: null,
                  //     //  (v) => cubit.changeGroup(v),

                  //     value: null
                  //     // cubit.groupId == null || cubit.groupId!.isEmpty
                  //     //     ? null
                  //     //     : cubit.groupId == '1'
                  //     //         ? 'زبون'
                  //     //         : 'معلن',
                  //     ),
                  const SizedBox(height: 15),
                  // if (cubit.groupId != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InputFormField(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        hasBorder: true,
                        hint: 'الاسم',
                        validator: Validator.name,
                        onSave: (v) => cubit.name = v,
                        onChanged: (p0) => cubit.checkInputsValidity(),
                      ),
                      BlocBuilder(
                        bloc: cubit,
                        buildWhen: (previous, current) =>
                            current is SignUpChangeGroupState,
                        builder: (context, state) {
                          if (cubit.groupId == "2") {
                            return Column(
                              children: [
                                const SizedBox(height: 15),
                                InputFormField(
                                  fillColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  hasBorder: true,
                                  hint: 'الاسم المستعار',
                                  validator: Validator.username,
                                  onSave: (v) => cubit.nickname = v,
                                  onChanged: (p0) =>
                                      cubit.checkInputsValidity(),
                                ),
                              ],
                            );
                          }
                          return SizedBox();
                        },
                      ),
                      const SizedBox(height: 15),
                      InputFormField(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        hasBorder: true,
                        hint: 'أدخل البريد الالكتروني',
                        onSave: (v) => cubit.email = v,
                        onChanged: (p0) => cubit.checkInputsValidity(),
                      ),
                      const SizedBox(height: 15),
                      InputFormField(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        hasBorder: true,
                        validator: Validator.phoneNumber,
                        hint: 'أدخل رقم الجوال',
                        isNumber: true,
                        maxLength: 10,
                        onSave: (v) => cubit.telephone = v,
                        onChanged: (p0) => cubit.checkInputsValidity(),
                        suffixIcon: const SaudiFlagWithNum(),
                      ),
                      const SizedBox(height: 15),
                      InputFormField(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        hasBorder: true,
                        hint: 'أدخل كلمة المرور',
                        secure: true,
                        validator: Validator.password,
                        onSave: (v) => cubit.password = v,
                        onChanged: (p0) => cubit.checkInputsValidity(),
                      ),
                      const SizedBox(height: 40),
                      BlocBuilder<SignUpCubit, SignUpStates>(
                          buildWhen: (previous, current) =>
                              current is SignUpLoadingState ||
                              current is SignUpInitState,
                          builder: (context, state) =>
                              state is SignUpLoadingState
                                  ? LoadingIndicator()
                                  : ConfirmButton(
                                      isExpanded: true,
                                      title: 'تسجيل',
                                      color: cubit.areInputsValid
                                          ? activeButtonColor
                                          : kLightGreyColor,
                                      onPressed: cubit.areInputsValid
                                          ? cubit.signUp
                                          : null,
                                      horizontalPadding: 30,
                                    )),
                      const SizedBox(height: 14),
                      Center(
                        child: InkWell(
                          onTap: () {
                            RouteManager.navigateTo(LoginView());
                          },
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: Color(0xFF5972EA),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
