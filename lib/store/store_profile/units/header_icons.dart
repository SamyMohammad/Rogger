import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/store/store_profile/cubit/cubit.dart';
import 'package:silah/widgets/app/info_bottom_sheet.dart';

class HeaderIcons extends StatelessWidget {
  const HeaderIcons({
    super.key,
    required this.cubit,
  });

  final StoreProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 30,
        left: 32,
        right: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                print("object");
                RouteManager.pop();
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: kPrimaryColor.withOpacity(0.7),
                child: SvgPicture.asset(
                  getIcon("back_arrow"),
                  fit: BoxFit.scaleDown,
                  height: 15,
                ),
              ),
            ),
            // Transform.translate(
            //   offset: Offset(0, -10),
            //   child: SizedBox(
            //     height: 30,
            //     width: 80,
            //     child: DecoratedBox(
            //         child: Center(
            //             child: Text(
            //           "تم التقييم",
            //           style: TextStyle(color: Colors.white),
            //         )),
            //         decoration: BoxDecoration(
            //             color: kPrimaryColor.withOpacity(0.7),
            //             border: Border.all(color: kPrimaryColor),
            //             borderRadius: BorderRadius.circular(20))),
            //   ),
            // ),
            GestureDetector(
              onTap: () => InfoBottomSheet.show(
                title: 'نبذة عن الحساب',
                info: cubit.storeInfoModel!.brief!,
              ),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: kPrimaryColor.withOpacity(0.7),
                child: SvgPicture.asset(
                  getIcon("info"),
                  fit: BoxFit.scaleDown,
                  height: 14,
                ),
              ),
            ),
          ],
        ));
  }
}
