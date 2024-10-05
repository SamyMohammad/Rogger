import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/store/tickets/cubit/cubit.dart';
import 'package:silah/store/tickets/units/verification_method_widget.dart';
import 'package:silah/widgets/confirm_button.dart';

import '../../shared_cubit/theme_cubit/cubit.dart';
import 'get_status_verification/get_status_verification.dart';

class ChooseVerificationMethodSection extends StatefulWidget {
  const ChooseVerificationMethodSection({super.key});

  @override
  State<ChooseVerificationMethodSection> createState() =>
      _ChooseVerificationMethodSectionState();
}

class _ChooseVerificationMethodSectionState
    extends State<ChooseVerificationMethodSection> {
  late TicketsCubit cubit;

  String? commercialRegisterFee;
  String? identityDocumentFee;
  String? freelancerDocumentFee;
  // @override
  // initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   fetchData();
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    cubit = TicketsCubit.of(context);
    await Future.delayed(Duration(seconds: 2));

    commercialRegisterFee = cubit.settings?['data']['commercial_register_fee'];
    identityDocumentFee = cubit.settings?['data']['identity_document_fee'];
    freelancerDocumentFee = cubit.settings?['data']['freelancer_document_fee'];
    setState(() {});
    // Simulate a delay
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        VerificationMethodWidget(
          isGuranteed: cubit.getStatusVerification?.requests?.contains(
                  (element) => element.verificationRequired == '1') ??
              false,
          icon: "verified",
          isVerificationMethodContainer: false,
          price: null,
          isActivated: false,
          isAnyMethodVerified: cubit.getStatusVerification?.requests
                  ?.any((element) => element.sTATUS == 'approved') ??
              false,
          name: "حساب مضمون",
          isChoosen: cubit.veirificationMethodSelectedIndex ==
              0, // Highlight if selected
          onTap: () {
            setState(() {
              // Toggle selection: if already selected, deselect it
              cubit.veirificationMethodSelectedIndex =
                  cubit.veirificationMethodSelectedIndex == 0 ? null : 0;
            });
          },
        ),
        const SizedBox(height: 20),
        // First VerificationMethodWidget
        VerificationMethodWidget(
          icon: cubit.icons[1],
          isPending: 'Commercial Register'.verificationTypeStatus(cubit) ==
                  'processing'
              ? true
              : false,
          price: commercialRegisterFee ?? '0',
          isActivated:
              'Commercial Register'.verificationTypeStatus(cubit) == 'approved'
                  ? true
                  : false,

          isVerificationMethodContainer: true,
          name: "السجل التجاري",
          isChoosen: cubit.veirificationMethodSelectedIndex ==
              1, // Highlight if selected
          onTap: () {
            setState(() {
              // Toggle selection: if already selected, deselect it
              print("status of request ${cubit.request?.sTATUS}");
              cubit.veirificationMethodSelectedIndex =
                  cubit.veirificationMethodSelectedIndex == 1 ? null : 1;
              onTabverificationMethodWidget(
                  cubit: cubit, index: 0, context: context);
            });
          },
        ),
        const SizedBox(height: 10),
        // Second VerificationMethodWidget
        VerificationMethodWidget(
          icon: cubit.icons[2],
          price: identityDocumentFee ?? '0',
          isPending:
              'Identity Document'.verificationTypeStatus(cubit) == 'processing'
                  ? true
                  : false,
          isActivated:
              'Identity Document'.verificationTypeStatus(cubit) == 'approved'
                  ? true
                  : false,
          isVerificationMethodContainer: true,
          name: "شهادة معروف",
          isChoosen: cubit.veirificationMethodSelectedIndex ==
              2, // Highlight if selected
          onTap: () {
            setState(() {
              // Toggle selection: if already selected, deselect it
              cubit.veirificationMethodSelectedIndex =
                  cubit.veirificationMethodSelectedIndex == 2 ? null : 2;
              onTabverificationMethodWidget(
                cubit: cubit,
                index: 1,
                context: context,
              );
            });
          },
        ),
        const SizedBox(height: 10),
        // Third VerificationMethodWidget
        VerificationMethodWidget(
          icon: cubit.icons[3],
          price: freelancerDocumentFee ?? '0',
          isPending: 'Freelancer Document'.verificationTypeStatus(cubit) ==
                  'processing'
              ? true
              : false,
          isActivated:
              'Freelancer Document'.verificationTypeStatus(cubit) == 'approved'
                  ? true
                  : false,

          isVerificationMethodContainer: true,
          name: "وثيقة ممارس حر",
          isChoosen: cubit.veirificationMethodSelectedIndex ==
              3, // Highlight if selected
          onTap: () {
            setState(() {
              // Toggle selection: if already selected, deselect it
              cubit.veirificationMethodSelectedIndex =
                  cubit.veirificationMethodSelectedIndex == 3 ? null : 3;
              onTabverificationMethodWidget(
                cubit: cubit,
                index: 2,
                context: context,
              );
            });
          },
        ),
        const SizedBox(height: 10),
        // Continue Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ConfirmButton(
            onPressed: cubit.veirificationMethodSelectedIndex != null &&
                    cubit.veirificationMethodSelectedIndex != 0
                ? () => cubit.navigateToVerifyMethodForm()
                : cubit.veirificationMethodSelectedIndex == 0
                    ? () => cubit.navigateToGuaranteeForm()
                    : null, // Disable button when no method is selected
            isExpanded: true,
            title: 'استمرار',
            fontColor: cubit.veirificationMethodSelectedIndex != null
                ? Colors.white
                : Color(0xFFA1A1A1),
            color: cubit.veirificationMethodSelectedIndex != null
                ? activeButtonColor
                : ThemeCubit.of(context).isDark
                    ? Color(0xFF1E1E26)
                    : Color(0xffFAFAFF),
            // color: cubit.veirificationMethodSelectedIndex != null
            //     ? activeButtonColor
            //     : kGreyColor,
          ),
        ),
      ],
    );
  }

  // String? buildSTATUS(String verificationType, TicketsCubit cubit) {
  //   return cubit.getStatusVerification?.requests
  //       ?.firstWhere((request) => request.verificationType == verificationType,
  //           orElse: () => Request())
  //       .sTATUS;
  // }

  void onTabverificationMethodWidget({
    required TicketsCubit cubit,
    required int index,
    required BuildContext context,
  }) {
    cubit.setIndex(index);
    cubit.getModelIndexOfVerificatio(index.name);
    cubit.isAnyRequestInTypeVerification(index.name);
    cubit.firstCheckbox = cubit.request?.verificationRequired == '1' &&
            cubit.request?.sTATUS != 'rejected'
        ? true
        : false;
    // if (cubit.request?.sTATUS != 'rejected' &&
    //     cubit.request?.isExpired == false) {
    //   commercialRegisterNumberController.text =
    //       cubit.request?.verificationTypeNumber ?? '';
    // }
    // commercialRegisterNumberController.text =
    //     cubit.request?.sTATUS != 'rejected' && cubit.request?.isExpired == false
    //         ? cubit.request?.verificationTypeNumber ?? ''
    //         : '';

    cubit.getTotalFee();
    cubit.getFormStatus();
  }
}

extension StringStatusExtension on String {
  String? verificationTypeStatus(TicketsCubit cubit) {
    return cubit.getStatusVerification?.requests
        ?.firstWhere((request) => request.verificationType == this,
            orElse: () => Request())
        .sTATUS;
  }
}
