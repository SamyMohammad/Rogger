import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/validator/validation.dart';
import 'package:silah/shared/edit_password/cubit.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../constants.dart';
import '../../widgets/confirm_button.dart';
import '../../widgets/text_form_field.dart';

class EditPasswordView extends StatelessWidget {
  const EditPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditPasswordCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text('تعديل كلمة المرور')),
        body: BlocBuilder<EditPasswordCubit, EditPasswordStates>(
          builder: (context, state) {
            final cubit = EditPasswordCubit.of(context);
            return Form(
              key: cubit.formKey,
              child: ListView(
                padding: VIEW_PADDING,
                children: [
                  InputFormField(
                    upperText: 'كلمة المرور الجديدة',
                    onSave: (v) => cubit.newPassword = v,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    validator: Validator.password,
                    onChanged: (_) => cubit.checkInputsValidity(),
                    secure: true,
                  ),
                  InputFormField(
                    upperText: 'اعادة كلمة المرور الجديدة',
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    verticalMargin: 8,
                    onSave: (v) => cubit.confirmNewPassword = v,
                    secure: true,
                    isNext: false,
                    onChanged: (_) => cubit.checkInputsValidity(),
                    validator: (value) =>
                        Validator.confirmPassword(value, cubit.newPassword),
                  ),
                  SizedBox(height: 16),
                  state is EditPasswordLoading
                      ? LoadingIndicator()
                      : ConfirmButton(
                          title: 'تعديل',
                          fontColor: cubit.areInputsValid
                              ? Colors.white
                              : Color(0xFFA1A1A1),
                          color: cubit.areInputsValid
                              ? activeButtonColor
                              : ThemeCubit.of(context).isDark
                                  ? Color(0xFF1E1E26)
                                  : Color(0xffFAFAFF),
                          onPressed:
                              cubit.areInputsValid ? cubit.editPassword : null,
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
