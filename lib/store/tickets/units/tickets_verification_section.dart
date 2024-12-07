import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/store/tickets/cubit/cubit.dart';
import 'package:silah/store/tickets/cubit/states.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/custom_checkbox.dart';
import 'package:silah/widgets/image_picker_form.dart';
import 'package:silah/widgets/text_form_field.dart';

import '../../../shared_cubit/theme_cubit/cubit.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/starter_divider.dart';

class TicketsVerificationSection extends StatefulWidget {
  const TicketsVerificationSection({
    super.key,
  });

  @override
  State<TicketsVerificationSection> createState() =>
      _TicketsVerificationSectionState();
}

class _TicketsVerificationSectionState
    extends State<TicketsVerificationSection> {
  // @override
  @override
  void initState() {
    super.initState();
    commercialRegisterNumberController = TextEditingController();
  }

  late TextEditingController commercialRegisterNumberController;

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
                                              Container(
                                                child: Column(
                                                  children: [
                                                    buildFirstHeaderInContainer(
                                                        category, cubit),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 30),
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 10),
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                3.5,
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  getIcon(cubit
                                                                          .icons[
                                                                      cubit.veirificationMethodSelectedIndex ??
                                                                          0]),
                                                                  width: 130,
                                                                  height: 55,
                                                                ),
                                                                const SizedBox(
                                                                    height: 18),
                                                                BuildRegisterNumber(
                                                                  commercialRegisterNumberController:
                                                                      commercialRegisterNumberController,
                                                                  cubit: cubit,
                                                                  category:
                                                                      category,
                                                                ),
                                                                // buildRegisterNumber(
                                                                //     cubit,
                                                                //     category,
                                                                //     context),
                                                                const SizedBox(
                                                                    height: 20),
                                                                buildcCategoryRecordImage(
                                                                    cubit,
                                                                    category),
                                                                const SizedBox(
                                                                    height: 10),
                                                                Text(
                                                                  "الرسوم السنوية $annualFee ريال",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          buildCopyOfTransferImage(
                                                              cubit),
                                                          const SizedBox(
                                                              height: 20),
                                                          Row(
                                                            children: [
                                                              BlocBuilder<
                                                                  TicketsCubit,
                                                                  TicketsStates>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                                  return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        cubit
                                                                            .toggleFirstCheckbox();
                                                                        cubit
                                                                            .getTotalFee();
                                                                        cubit
                                                                            .isValidGuaranteed();
                                                                      },
                                                                      child: CustomCheckbox(
                                                                          isActive:
                                                                              cubit.firstCheckbox));
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              buildverifiedText()
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            "الرسوم الإجمالي السنوي ${cubit.totalFee} ريال",
                                                            style: TextStyle(
                                                                color:
                                                                    kBluePurpleColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                              height: 15),
                                                          Row(
                                                            children: [
                                                              BlocBuilder<
                                                                  TicketsCubit,
                                                                  TicketsStates>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                                  return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        cubit
                                                                            .toggleSecondCheckbox();
                                                                        cubit
                                                                            .isValidGuaranteed();
                                                                      },
                                                                      child: CustomCheckbox(
                                                                          isActive:
                                                                              cubit.secondCheckbox));
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Expanded(
                                                                  child: Text(
                                                                      "أقر بمسؤليتي التامه على صحة رقم ${cubit.categories[cubit.indexOfVerification]} التابع لي، وأن صلة غير مسئولة عن صحة المعلومات المدخلة من من طرفي"))
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 24),
                                                          Text(
                                                            "*يرجى التحقق من صحة رقم ${cubit.categories[cubit.indexOfVerification]} قبل الطلب في حال الطلب سيتم إبلاغك عن طريق الأشعارات*",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff359F03),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                              height: 30),
                                                          Text(
                                                            "تنبيه : في حال التلاعب سيتم إيقاف حسابك فوراً",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                              height: 35),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Theme.of(context)
                                                        .appBarTheme
                                                        .backgroundColor,
                                                    border: Border.all(
                                                        color:
                                                            kLightGreyColorB4)),
                                              ),
                                              const SizedBox(height: 10),
                                              buildConfirmButton(cubit),
                                            ],
                                          ),
                                        ),
                                        // if (cubit.isAnyRequestExists == true &&
                                        //     cubit.request?.isExpired == false &&
                                        //     cubit.request?.sTATUS !=
                                        //         'rejected' &&
                                        //     cubit.request
                                        //             ?.verificationRequired ==
                                        //         '1')
                                        //   buildFullShadowContainer(
                                        //       cubit, context)
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

  Container buildShadowContainerWithoutGuarantee(
      BuildContext context, TicketsCubit cubit, String category) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height / 3.5,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(.85),
          borderRadius: BorderRadius.circular(15)),
      child: Text(
          cubit.request?.sTATUS == 'approved'
              ? 'لديك $category مفعل'
              : cubit.request?.sTATUS == 'processing'
                  ? ' حسابك قيد المراجعة  '
                  : '',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 20)),
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

  void onTabverificationMethodWidget(
      TicketsCubit cubit, int index, BuildContext context) {
    cubit.setIndex(index);
    cubit.getModelIndexOfVerificatio(index.name);
    cubit.isAnyRequestInTypeVerification(index.name);
    cubit.firstCheckbox = cubit.request?.verificationRequired == '1' &&
            cubit.request?.sTATUS != 'rejected'
        ? true
        : false;
    if (cubit.request?.sTATUS != 'rejected' &&
        cubit.request?.isExpired == false) {
      commercialRegisterNumberController.text =
          cubit.request?.verificationTypeNumber ?? '';
    }
    commercialRegisterNumberController.text =
        cubit.request?.sTATUS != 'rejected' && cubit.request?.isExpired == false
            ? cubit.request?.verificationTypeNumber ?? ''
            : '';

    cubit.getTotalFee();
    cubit.getFormStatus();
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
          Text("إضافة $category"),
          Icon(
            cubit.request?.sTATUS?.icon,
            color: cubit.request?.sTATUS?.color,
          ),
        ],
      ),
    );
  }

  void handleValidRequest(TicketsCubit cubit) {
    cubit.requestVerification();
  }

  determineOnPressedAction(TicketsCubit cubit) {
    if (cubit.isAnyRequestExists == false ||
        cubit.request?.sTATUS == 'rejected') {
      cubit.isValid ? handleValidRequest(cubit) : null;
    }

    bool isApprovedOrProcessing = cubit.request?.sTATUS == 'approved' ||
        cubit.request?.sTATUS == 'processing';
    bool isVerificationRequired = cubit.request?.verificationRequired == '0';

    // if (isApprovedOrProcessing &&
    //     isVerificationRequired &&
    //     cubit.isValidGuaranteedStatus) {
    //
    //   cubit.updaterequestVerification();
    // }
  }

  Color determineButtonColor(TicketsCubit cubit) {
    if (cubit.isAnyRequestExists == false ||
        cubit.request?.sTATUS == 'rejected') {
      return cubit.isValid
          ? activeButtonColor
          : ThemeCubit.of(context).isDark
              ? Color(0xFF1E1E26)
              : Color(0xffFAFAFF);
    }

    bool isApprovedOrProcessing = cubit.request?.sTATUS == 'approved' ||
        cubit.request?.sTATUS == 'processing';
    bool isVerificationNotRequired = cubit.request?.verificationRequired != '1';

    if (isApprovedOrProcessing) {
      return (isVerificationNotRequired && cubit.isValidGuaranteedStatus)
          ? activeButtonColor
          : kDarkGreyColor;
    }

    return kDarkGreyColor;
  }

  ConfirmButton buildConfirmButton(TicketsCubit cubit) {
    return ConfirmButton(
        title: "طلب",
        color: determineButtonColor(cubit),
        onPressed: () => handleValidRequest(cubit));
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

  Stack buildcCategoryRecordImage(TicketsCubit cubit, String category) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImagePickerForm(
            // hasBorder:
            // fileFromApi: cubit.request?.verificationTypeImage != null &&
            //         cubit.request?.isExpired == false &&
            //         cubit.request?.sTATUS != 'rejected'
            //     ? cubit.request?.verificationTypeImage
            //     : null,
            fileFromApi: null,
            // onChange:
            // cubit.request?.verificationTypeImage != null &&
            //         cubit.request?.isExpired == false &&
            //         cubit.request?.sTATUS != 'rejected'
            //     ? null
            onChange: (File? file) {
              cubit.categoryRecordImageNotifier.value = file;
              print(
                  'cubit.categoryRecordImageNotifier.value${cubit.categoryRecordImageNotifier.value}');
              cubit.isValidateToVisible();
            },
            hint: "أرفق صورة $category"),
      ],
    );
  }

// Stack buildRegisterNumber(
//     TicketsCubit cubit, String category, BuildContext context) {
//   return BuildRegisterNumber();
// }
}

class BuildRegisterNumber extends StatefulWidget {
  const BuildRegisterNumber({
    super.key,
    required this.commercialRegisterNumberController,
    required this.cubit,
    required this.category,
  });

  final TextEditingController commercialRegisterNumberController;
  final TicketsCubit cubit;
  final String category;

  @override
  State<BuildRegisterNumber> createState() => _BuildRegisterNumberState();
}

class _BuildRegisterNumberState extends State<BuildRegisterNumber> {
  @override
  void initState() {
    // TODO: implement initState
    // widget.commercialRegisterNumberController.text =
    //     TicketsCubit.of(context).request?.sTATUS != 'rejected'
    //         ? ''
    //         : TicketsCubit.of(context).request?.verificationTypeNumber ?? '';
    // widget.cubit.request?.verificationTypeNumber??'';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InputFormField(
          initialValue: widget.cubit.request?.sTATUS == 'rejected'
              ? null
              : widget.cubit.request?.verificationTypeNumber,
          // controller: widget.commercialRegisterNumberController,
          // disabled: widget.cubit.request?.verificationTypeNumber != null &&
          //     widget.cubit.request?.isExpired == false &&
          //     widget.cubit.request?.sTATUS != 'rejected',
          disabled: false,
          hasBorder: true,
          hint: 'أدخل رقم ${widget.category}',
          // textColor: cubit.request?.verificationTypeNumber != null &&
          //         cubit.request?.isExpired == false &&
          //         cubit.request?.sTATUS != 'rejected'
          //     ? Colors.grey
          //     : null,
          fillColor: Theme.of(context).appBarTheme.backgroundColor,
          isNumber: true,

          onChanged: (value) {
            widget.cubit.registerNumberControllerNotifier.value = value;
            widget.cubit.isValidateToVisible();
          },
          // controller:
          //     cubit.commercialRegisterNumberController,
          icon: Icons.vertical_align_bottom,
        ),
      ],
    );
  }
}
