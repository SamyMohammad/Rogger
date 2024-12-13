import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah/constants.dart';

// class VerificationMethodWidget extends StatelessWidget {
//   final String icon;
//   final String name;
//   final bool isActive;
//   final VoidCallback onTap;
//   const VerificationMethodWidget({
//     required this.icon,
//     required this.isActive,
//     required this.name,
//     required this.onTap,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           margin: EdgeInsets.only(left: icon == "freelancing" ? 0 : 14),
//           height: 75,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Theme.of(context).appBarTheme.backgroundColor,
//               boxShadow: [
//                 BoxShadow(
//                   color: isActive
//                       ? kBluePurpleColor.withOpacity(0.3)
//                       : Colors.grey.withOpacity(0.5),
//                   offset: Offset(0, 3),
//                   blurRadius: 2,
//                   spreadRadius: 1,
//                 ),
//               ]),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Center(
//                 child: SvgPicture.asset(
//                   getIcon(icon),
//                   width: 80,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 name,
//                 style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class VerificationMethodWidget extends StatelessWidget {
  final String icon;
  final String name;
  final bool isChoosen;
  final VoidCallback onTap;
  final String? price;
  final bool isActivated;
  final bool isVerificationMethodContainer;
  final bool? isAnyMethodVerified;
  final bool? isGuranteed;
  final bool? isPending;
  const VerificationMethodWidget({
    required this.icon,
    required this.isChoosen,
    required this.isActivated,
    required this.isVerificationMethodContainer,
    this.isPending,
    this.isGuranteed,
    // TODO: Add verification isverfied
    required this.name,
    required this.onTap,
    this.isAnyMethodVerified,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isAnyMethodVerified == true &&
                  !isVerificationMethodContainer &&
                  isGuranteed == false) ||
              (!isActivated &&
                  isVerificationMethodContainer &&
                  isPending != true)
          ? onTap
          : null,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        margin: EdgeInsets.symmetric(
          horizontal: 14,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        // height: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: !isVerificationMethodContainer
                ? isAnyMethodVerified == true
                    ? isGuranteed == true
                        ? Color(0xffE3FEED)
                        : isChoosen
                            ? Color(0xff022E47)
                            : Theme.of(context).appBarTheme.backgroundColor
                    : Colors.red
                : isActivated
                    ? Color(0xffE3FEED)
                    : isPending == true
                        ? Color(0xffFEF5E3)
                        : isChoosen
                            ? Color(0xff022E47)
                            : Theme.of(context).appBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: isChoosen
                    ? kBluePurpleColor.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
                // offset: Offset(0, 3),
                blurRadius: .5,
                spreadRadius: .5,
              ),
            ]),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'توثيق $name',
                  style: TextStyle(
                      fontSize: 18,
                      color: isActivated || isGuranteed == true
                          ? Colors.black
                          : isChoosen
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: price != null ? 15 : 5),
                Text(
                  isActivated || isGuranteed == true
                      ? "مفعل"
                      : isPending == true
                          ? "قيد الانتظار"
                          : "تفعيل",
                  style: TextStyle(
                      fontSize: 16,
                      color: isActivated || isGuranteed == true
                          ? Color(0xff009530)
                          : isPending == true
                              ? Color(0xffC49425)
                              : kLightGreyColorB4,
                      fontWeight: FontWeight.w400),
                ),
                if (price != null) const SizedBox(height: 15),
                if (price != null)
                  Text(
                    "${price} ريال",
                    style: TextStyle(
                        fontSize: 16,
                        color: kLightGreyColorB4,
                        fontWeight: FontWeight.w400),
                  ),
              ],
            ),
            if (isActivated || isGuranteed == true)
              Positioned(
                left: 5,
                top: 0,
                child: Icon(
                  Icons.check_circle_outline,
                  color: Color(0xff009530),
                ),
              ),
            if (isPending == true)
              Positioned(
                left: 5,
                top: 0,
                child: Icon(
                  Icons.history,
                  color: Color(0xffC49425),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: isVerificationMethodContainer == false
                    ? Image.asset(
                        height: 30,
                        width: 30,
                        "assets/images/${icon}.png",
                      )
                    : SvgPicture.asset(
                        getIcon(icon),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // void onTabverificationMethodWidget(
  //     TicketsCubit cubit, int index, BuildContext context) {
  //   cubit.setIndex(index);
  //   cubit.getModelIndexOfVerificatio(index.name);
  //   cubit.isAnyRequestInTypeVerification(index.name);
  //   cubit.firstCheckbox = cubit.request?.verificationRequired == '1' &&
  //           cubit.request?.sTATUS != 'rejected'
  //       ? true
  //       : false;
  //   if (cubit.request?.sTATUS != 'rejected' &&
  //       cubit.request?.isExpired == false) {
  //     // commercialRegisterNumberController.text =
  //     //     cubit.request?.verificationTypeNumber ?? '';
  //   }
  //   // commercialRegisterNumberController.text =
  //   //     cubit.request?.sTATUS != 'rejected' && cubit.request?.isExpired == false
  //   //         ? cubit.request?.verificationTypeNumber ?? ''
  //   //         : '';
  //
  //   cubit.getTotalFee();
  //   cubit.getFormStatus();
  // }
}
