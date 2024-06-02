import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/validator/validation.dart';
import 'package:silah/store/edit_brief/cubit.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/text_form_field.dart';

import '../../constants.dart';

class EditBriefView extends StatelessWidget {
  const EditBriefView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditBriefCubit()..printBrief(),
      child: BlocBuilder<EditBriefCubit, EditBriefStates>(
        builder: (context, state) {
          final cubit = EditBriefCubit.of(context);
          return Scaffold(
            appBar: AppBar(title: Text("نبذة عن الحساب")),
            body: Form(
              key: cubit.formKey,
              child: ListView(
                padding: VIEW_PADDING,
                children: [
                  InputFormField(
                    maxLines: 5,
                    multiLine: true,
                    upperText: 'نبذة',
                    controller: cubit.brief,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    hint: "نبذة عن الحساب",
                    onChanged: (_) => cubit.checkInputsValidity(),
                    validator: Validator.generalField,
                  ),
                  state is EditBriefLoading
                      ? LoadingIndicator()
                      : ConfirmButton(
                          title: 'تعديل',
                          verticalMargin: 20,
                          color:
                              cubit.areInputsValid ? kPrimaryColor : kGreyColor,
                          onPressed:
                              cubit.areInputsValid ? cubit.editBrief : null,
                        )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
