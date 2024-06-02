import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/validator/validation.dart';
import 'package:silah/shared/contact_us/cubit/cubit.dart';
import 'package:silah/shared/contact_us/cubit/states.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/text_form_field.dart';

import '../../shared_cubit/theme_cubit/cubit.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  late final List<BoxShadow> inActiveBoxShadow;
  late final List<BoxShadow> activeBoxShadow;
  @override
  void initState() {
    super.initState();
    activeBoxShadow = [
      //Top
      BoxShadow(
          color: ThemeCubit.of(context).isDark
              ? kPrimary1Color.withOpacity(0.5)
              : Colors.grey.withOpacity(0.6),
          offset: Offset(0, 5),
          blurRadius: 2,
          spreadRadius: 1,
          inset: true),
      //left
      BoxShadow(
        inset: true,
        color: ThemeCubit.of(context).isDark
            ? kPrimary1Color.withOpacity(0.3)
            : Colors.grey.withOpacity(0.3),
        offset: Offset(2, 0),
        blurRadius: 2,
        spreadRadius: -1,
      ),
    ];

    inActiveBoxShadow = [
      BoxShadow(
        color: ThemeCubit.of(context).isDark
            ? kPrimary1Color.withOpacity(0.3)
            : Colors.grey.withOpacity(0.5),
        offset: Offset(0, 5),
        blurRadius: 2,
        spreadRadius: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactUsCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text('تواصل معنا'), elevation: 1),
        body: BlocBuilder<ContactUsCubit, ContactUsStates>(
          builder: (context, state) {
            final cubit = ContactUsCubit.of(context);
            return Form(
              key: cubit.formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                cubit.subject = 'inquiry';
                                // print(cubit.subject);
                              });
                            },
                            child: Container(
                              height: 44,
                              child: Center(
                                  child: Text(
                                "استفسار",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: cubit.subject == 'inquiry'
                                        ? Colors.white
                                        : kDarkGreyColor),
                              )),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  borderRadius: BorderRadius.circular(6),
                                  // border: Border.all(color: Colors.red),
                                  boxShadow: cubit.subject == 'inquiry'
                                      ? activeBoxShadow
                                      : inActiveBoxShadow),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                cubit.subject = 'suggestion';
                                // print(cubit.subject);
                              });
                            },
                            child: Container(
                              height: 44,
                              child: Center(
                                  child: Text(
                                "الاقتراحات",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    color: cubit.subject == 'suggestion'
                                        ? Colors.white
                                        : kDarkGreyColor),
                              )),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  borderRadius: BorderRadius.circular(6),
                                  // border: Border.all(color: Colors.red),
                                  boxShadow: cubit.subject == 'suggestion'
                                      ? activeBoxShadow
                                      : inActiveBoxShadow),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                cubit.subject = 'issue';
                                // print(cubit.subject);
                              });
                            },
                            child: Container(
                              height: 44,
                              child: Center(
                                  child: Text(
                                "البلاغات",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    color: cubit.subject == 'issue'
                                        ? Colors.white
                                        : kDarkGreyColor),
                              )),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  borderRadius: BorderRadius.circular(6),
                                  // border: Border.all(color: Colors.red),
                                  boxShadow: cubit.subject == 'issue'
                                      ? activeBoxShadow
                                      : inActiveBoxShadow),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //  Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Container(
                    //       decoration: BoxDecoration(
                    //           color: cubit.subject == 'استفسار'
                    //               ? kPrimaryColor
                    //               : Colors.transparent,
                    //           border: Border.all(color: kGreyColor, width: 1.5),
                    //           borderRadius: BorderRadius.circular(20)),
                    //       height: 40,
                    //       child: MaterialButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             cubit.subject = 'استفسار';
                    //             // print(cubit.subject);
                    //           });
                    //         },
                    //         child: Text(
                    //           'استفسار'.toString(),
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.w700,
                    //               color: cubit.subject == 'استفسار'
                    //                   ? Colors.white
                    //                   : kDarkGreyColor,
                    //               fontSize: 12),
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       height: 40,
                    //       decoration: BoxDecoration(
                    //           color: cubit.subject == 'الاقتراحات'
                    //               ? kPrimaryColor
                    //               : Colors.transparent,
                    //           border: Border.all(color: kGreyColor, width: 1.5),
                    //           borderRadius: BorderRadius.circular(20)),
                    //       child: MaterialButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             cubit.subject = 'الاقتراحات';
                    //             // print(cubit.subject);
                    //           });
                    //         },
                    //         child: Text(
                    //           'الاقتراحات'.toString(),
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.w700,
                    //               color: cubit.subject == 'الاقتراحات'
                    //                   ? Colors.white
                    //                   : kDarkGreyColor,
                    //               fontSize: 12),
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       height: 40,
                    //       decoration: BoxDecoration(
                    //           color: cubit.subject == 'البلاغات'
                    //               ? kPrimaryColor
                    //               : Colors.transparent,
                    //           border: Border.all(color: kGreyColor, width: 1.5),
                    //           borderRadius: BorderRadius.circular(20)),
                    //       child: MaterialButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             cubit.subject = 'البلاغات';
                    //             // print(cubit.subject);
                    //           });
                    //         },
                    //         child: Text(
                    //           'البلاغات'.toString(),
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.w700,
                    //               color: cubit.subject == 'البلاغات'
                    //                   ? Colors.white
                    //                   : kDarkGreyColor,
                    //               fontSize: 12),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: InputFormField(
                      hint: 'اكتب ' +
                          (cubit.subject == 'inquiry'
                              ? 'استفسار'
                              : cubit.subject == 'suggestion'
                                  ? 'الاقتراح'
                                  : 'البلاغ'),
                      hasBorder: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      maxLines: 5,
                      verticalMargin: 0,
                      onChanged: cubit.checkInputsValidity,
                      validator: Validator.enquiry,
                      // multiLine: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: state is ContactUsLoadingState
                        ? LoadingIndicator()
                        : ConfirmButton(
                            title: 'ارسال',
                            horizontalPadding: 30,
                            onPressed:
                                cubit.areInputsValid ? cubit.contactUs : null,
                            color: cubit.areInputsValid
                                ? kPrimary2Color
                                : kDarkGreyColor,
                          ),
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
