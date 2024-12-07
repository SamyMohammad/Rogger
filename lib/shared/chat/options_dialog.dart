import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/black_list/cubit/cubit.dart';
import 'package:silah/shared/chat/cubit.dart';
import 'package:silah/shared/location_view/view.dart';
import 'package:silah/shared/nav_bar/view.dart';
import 'package:silah/shared/product_details/report_dialog.dart';
import 'package:silah/widgets/starter_divider.dart';

showChatOptionsDialog(
    {required ChatCubit cubit, required bool isBlocked}) async {
  showDialog(
      context: RouteManager.currentContext,
      builder: (context) => _Dialog(
            cubit: cubit,
            isBlocked: isBlocked,
          ),
      barrierDismissible: true);
}

class _Dialog extends StatelessWidget {
  const _Dialog({Key? key, required this.cubit, required this.isBlocked})
      : super(key: key);

  final ChatCubit cubit;
  final bool isBlocked;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Container(
            width: width - 300,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                const SizedBox(height: 5),
                StarterDivider(),
                const SizedBox(height: 20),

                _tile(
                    title: 'حذف المحادثة',
                    onPressed: () {
                      RouteManager.navigateAndPopAll(NavBarView());
                      cubit.deleteChat();
                    },
                    icon: Image.asset(getAsset("trash"),
                        height: 25, color: kDarkGreyColor)),
                // if (AppStorage.isStore)

                _tile(
                  title: 'ارسال الموقع',
                  onPressed: () {
                    RouteManager.pop();
                    RouteManager.navigateTo(LocationView(
                      viewOnly: false,
                      onConfirm: cubit.sendLocation,
                    ));
                  },
                  icon: SvgPicture.asset(getIcon("icon3"),
                      height: 21, color: kDarkGreyColor),
                ),
                _tile(
                  title: 'بلاغ',
                  onPressed: () {
                    RouteManager.pop();

                    showReportDialogChat(
                        chatId: int.parse(cubit.chatID),
                        reportedCustomerId: int.parse(cubit.userID));
                    // RouteManager.navigateTo(ContactUsView());
                  },
                  icon: SvgPicture.asset(getIcon("exclamation_2"),
                      height: 20, color: kDarkGreyColor),
                ),
                if (cubit.isBlocked == false || cubit.isBlocked == null)
                  _tile(
                    title: 'حظر',
                    onPressed: () {
                      RouteManager.navigateAndPopAll(NavBarView());
                      BlackListCubit().blocUser(cubit.userID);
                    },
                    icon: SvgPicture.asset(getIcon("block"),
                        height: 20, color: kDarkGreyColor),
                  ),

                const SizedBox(height: 20),
                // TextButton(
                //   onPressed: RouteManager.pop,
                //   child: Text(
                //     "الغاء",
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold, color: Colors.red),
                //   ),
                // )
              ],
            ),
          ),
        ),
        if (isBlocked)
          Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: width - 300,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  _tile(
                    title: 'إلفاء الحظر',
                    color: Colors.red,
                    onPressed: () {
                      RouteManager.navigateAndPopAll(NavBarView());
                      BlackListCubit().unBlockUser(cubit.userID);
                    },
                    icon: SvgPicture.asset(getIcon("block"),
                        height: 20, color: Colors.red),
                  ),

                  const SizedBox(height: 10),
                  // TextButton(
                  //   onPressed: RouteManager.pop,
                  //   child: Text(
                  //     "الغاء",
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold, color: Colors.red),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _tile(
      {required String title,
      required VoidCallback onPressed,
      required Widget icon,
      Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            Spacer(),
            icon
          ],
        ),
      ),
    );
  }
}
