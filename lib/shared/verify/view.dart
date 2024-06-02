import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared/verify/cubit/cubit.dart';
import 'package:silah/shared/verify/cubit/states.dart';
import 'package:silah/shared/verify/resend_code_section.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/logo.dart';
import 'package:silah/widgets/pin_code_field.dart';

class VerifyView extends StatelessWidget {
  const VerifyView(
      {Key? key,
      required this.customerId,
      required this.telephone,
      required this.customerGroup,
      this.reverifying = false})
      : super(key: key);
  final int customerId;
  final int customerGroup;
  final String telephone;
  final bool reverifying;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VerifyCubit(telephone, customerId, customerGroup, reverifying),
      child: Scaffold(
        appBar: appBar(),
        body: BlocBuilder<VerifyCubit, VerifyStates>(
          builder: (context, state) {
            final cubit = VerifyCubit.of(context);
            return Form(
              // key: cubit.formKey,
              child: ListView(
                padding: VIEW_PADDING,
                children: [
                  Logo(
                    heightFraction: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'برجاء ادخال الكود المرسل الي',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kAccentColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    cubit.telephone,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // TextButton(
                  //   style: ButtonStyle(
                  //     visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                  //     overlayColor: MaterialStateProperty.all(Colors.transparent),
                  //   ),
                  //   child: Text(
                  //     'تغيير رقم الجوال',
                  //     style: TextStyle(
                  //       decoration: TextDecoration.underline,
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     ChangeTelephoneDialog.show(
                  //       telephone: cubit.telephone,
                  //       userID: customerId.toString(),
                  //       onTelephoneChanged: cubit.changeTelephone,
                  //     );
                  //   },
                  // ),
                  PinCodeField(onChanged: (v) => cubit.code = v),
                  state is VerifyLoadingState
                      ? LoadingIndicator()
                      : ConfirmButton(
                          title: 'تـأكـيـد  ',
                          verticalMargin: 0,
                          onPressed: cubit.activate,
                        ),
                  ResendCodeSection()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
