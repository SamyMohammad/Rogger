import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/store/tickets/cubit/cubit.dart';
import 'package:silah/store/tickets/cubit/states.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/custom_checkbox.dart';
import 'package:silah/widgets/image_picker_form.dart';

import '../../../widgets/snack_bar.dart';
import '../../../widgets/starter_divider.dart';
import '../../shared_cubit/theme_cubit/cubit.dart';

class VerificationGuaranteeSection extends StatefulWidget {
  const VerificationGuaranteeSection({
    super.key,
  });

  @override
  State<VerificationGuaranteeSection> createState() =>
      _VerificationGuaranteeSectionState();
}

class _VerificationGuaranteeSectionState
    extends State<VerificationGuaranteeSection> {
  // @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TicketsCubit, TicketsStates>(
        listener: (context, state) {
      if (state is GetStatusVerificationSuccessState) {
        TicketsCubit.of(context)
            .getModelIndexOfVerificatio('Commercial Register');
        TicketsCubit.of(context)
            .isAnyRequestInTypeVerification('Commercial Register');
        TicketsCubit.of(context).firstCheckbox =
            TicketsCubit.of(context).request?.verificationRequired == '1' &&
                    TicketsCubit.of(context).request?.sTATUS != 'rejected'
                ? true
                : false;
        TicketsCubit.of(context).getTotalFee();
      }
      if (state is RequestVerificationSuccessState) {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 5),
                      StarterDivider(),
                      const SizedBox(height: 15),
                      Image.asset(getAsset("success_verification"),
                          height: 85, width: 85),
                      const SizedBox(height: 15),
                      Text("لقد تم إرسال طلبكم بنجاح",
                          style: TextStyle(
                              color: kLightGreyColor,
                              fontSize: 20,
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 15),
                      Text("RD-${state.response['request_id']}",
                          style: TextStyle(
                              color: kLightGreyColor,
                              fontSize: 14,
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 10),
                      Text("الرجاء حفظ رقم الطلب",
                          style: TextStyle(
                              color: kLightGreyColor,
                              fontSize: 14,
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 5),
                      Text("والذي سيتم معالجته في غضون يومي عمل",
                          style: TextStyle(
                              color: kLightGreyColor,
                              fontSize: 14,
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            });
      }
      if (state is RequestVerificationErrorState) {
        showSnackBar("تحذير: ضبط تفاصيل الرقم !", errorMessage: true);
      }
      if (state is UpdateRequestVerificationSuccessState) {
        showSnackBar(
          "تم التحديث",
          errorMessage: false,
        );
      }
      if (state is UpdateRequestVerificationErrorState) {
        showSnackBar("هناك خطأ", errorMessage: true);
      }
    }, builder: (context, state) {
      final cubit = TicketsCubit.of(context);
      final category =
          cubit.categories[cubit.veirificationMethodSelectedIndex ?? 0];
      // commercialRegisterNumberController.text =
      //     TicketsCubit.of(context).request?.verificationTypeNumber ?? '';
      String? commercialRegisterFee =
          cubit.settings?['data']['commercial_register_fee'];
      String? identityDocumentFee =
          cubit.settings?['data']['identity_document_fee'];
      String? freelancerDocumentFee =
          cubit.settings?['data']['freelancer_document_fee'];
      String? subscriptionFee = cubit.settings?['data']['subscription_fee'];
      String? verificationFee = cubit.settings?['data']['verification_fee'];
      String? annualFee = cubit.indexOfVerification == 0
          ? commercialRegisterFee
          : cubit.indexOfVerification == 1
              ? identityDocumentFee
              : cubit.indexOfVerification == 2
                  ? freelancerDocumentFee
                  : '0';

      return ValueListenableBuilder(
          valueListenable: cubit.verifiedNotifier,
          builder: (context, value, child) {
            return ValueListenableBuilder(
                valueListenable: cubit.categoryRecordImageNotifier,
                builder: (context, value, child) {
                  return ValueListenableBuilder(
                      valueListenable: cubit.registerNumberControllerNotifier,
                      builder: (context, value, child) {
                        return ValueListenableBuilder(
                            valueListenable: cubit.copyOfTransferImageNotifier,
                            builder: (context, value, child) {
                              return Builder(builder: (context) {
                                // if (cubit.request?.verificationTypeImage !=
                                //     null)
                                return Form(
                                  key: cubit.formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 30),
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SizedBox(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 20),
                                              buildForm(category, cubit,
                                                  context, verificationFee),
                                              const SizedBox(height: 10),
                                              buildConfirmButton(
                                                  cubit, context),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });
                      });
                });
          });
    });
  }

  Container buildForm(String category, TicketsCubit cubit, BuildContext context,
      String? verificationFee) {
    return Container(
      child: Column(
        children: [
          buildFirstHeaderInContainer(category, cubit),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        getAsset("verified"),
                        height: 55,
                        width: 55,
                      ),
                      SizedBox(width: 10),
                      Text("مضمون",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: activeButtonColor)),
                    ]),
                const SizedBox(height: 20),
                buildCopyOfTransferImage(cubit),
                const SizedBox(height: 25),
                Row(
                  children: [
                    BlocBuilder<TicketsCubit, TicketsStates>(
                      builder: (context, state) {
                        return GestureDetector(
                            onTap: () {
                              cubit.toggleFirstCheckbox();
                              cubit.getTotalFee();
                              cubit.isValidGuaranteed();
                            },
                            child:
                                CustomCheckbox(isActive: cubit.firstCheckbox));
                      },
                    ),
                    const SizedBox(width: 8),
                    buildverifiedText()
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "الرسوم الإجمالي السنوي ${verificationFee} ريال",
                  style: TextStyle(
                      color: kBluePurpleColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Row(
                //   children: [
                //     BlocBuilder<TicketsCubit, TicketsStates>(
                //       builder: (context, state) {
                //         return GestureDetector(
                //             onTap: () {
                //               cubit.toggleSecondCheckbox();
                //               cubit.isValidGuaranteed();
                //             },
                //             child:
                //                 CustomCheckbox(isActive: cubit.secondCheckbox));
                //       },
                //     ),
                //     const SizedBox(width: 8),
                //     Expanded(
                //         child: Text(
                //             "أقر بمسؤليتي التامه على صحة رقم ${cubit.categories[cubit.indexOfVerification]} التابع لي، وأن صلة غير مسئولة عن صحة المعلومات المدخلة من من طرفي"))
                //   ],
                // ),
                // const SizedBox(height: 24),

                Text(
                  "تنبيه : في حال التلاعب سيتم إيقاف حسابك فوراً",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).appBarTheme.backgroundColor,
          border: Border.all(color: kLightGreyColorB4)),
    );
  }

  Container buildFullShadowContainer(TicketsCubit cubit, BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.87,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(.85),
          borderRadius: BorderRadius.circular(15)),
      child: Text(
          // 'لديك عضوية مفعلة',
          cubit.request?.sTATUS == 'approved'
              ? 'لديك عضوية مفعلة'
              : cubit.request?.sTATUS == 'processing'
                  ? ' حسابك قيد المراجعة  '
                  : '',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }

  Container buildFirstHeaderInContainer(String category, TicketsCubit cubit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kLightGreyColorB4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("توثيق حساب مضمون"),
          Icon(
            cubit.request?.sTATUS?.icon,
            color: cubit.request?.sTATUS?.color,
          ),
        ],
      ),
    );
  }
}

Color determineButtonColor(TicketsCubit cubit, BuildContext context) {
  return cubit.copyOfTransferImageNotifier.value != null &&
          cubit.guaranteedNotifier.value == true
      ? activeButtonColor
      : ThemeCubit.of(context).isDark
          ? Color(0xFF1E1E26)
          : Color(0xffFAFAFF);
  // cubit.areInputsValid
  //     ? activeButtonColor
  //     : ThemeCubit.of(context).isDark
  //     ? Color(0xFF1E1E26)
  //     : Color(0xffFAFAFF)
  // bool isApprovedOrProcessing = cubit.request?.sTATUS == 'approved' ||
  //     cubit.request?.sTATUS == 'processing';
  // bool isVerificationNotRequired = cubit.request?.verificationRequired != '1';
  //
  // if (isApprovedOrProcessing) {
  //   return (isVerificationNotRequired && cubit.isValidGuaranteedStatus)
  //       ? activeButtonColor
  //       : kDarkGreyColor;
  // }
  //
  // return kDarkGreyColor;
}

ConfirmButton buildConfirmButton(TicketsCubit cubit, BuildContext context) {
  return ConfirmButton(
      title: "طلب",
      color: determineButtonColor(cubit, context),
      onPressed: cubit.copyOfTransferImageNotifier.value != null &&
              cubit.guaranteedNotifier.value == true
          ? () => cubit.updaterequestVerification()
          : null);
}

Expanded buildverifiedText() {
  return Expanded(
      child: Wrap(
    children: [
      Text("عند طلب حساب مضمون ستظهر علامة "),
      Image.asset(getAsset("verified"), height: 20),
      Text("بجانب اسم الحساب مما يعطي ثقة للزبائن")
    ],
  ));
}

Stack buildCopyOfTransferImage(TicketsCubit cubit) {
  return Stack(
    alignment: Alignment.center,
    children: [
      ImagePickerForm(
        fileFromApi: null,

        // onChange: cubit.request?.isExpired == false &&
        //         cubit.request?.sTATUS != 'rejected' &&
        //         cubit.request?.verificationRequired == '1'
        //     ? null
        onChange: (File? file) {
          if (file == null) {
            cubit.isVisible = false;
          } else {
            cubit.isVisible = true;
          }

          cubit.isValidateToVisible();

          cubit.copyOfTransferImageNotifier.value = file;
          cubit.isValidGuaranteed();
        },
      ),
    ],
  );
}
