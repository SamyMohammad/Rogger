import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/location/location_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/nav_bar/view.dart';
import 'package:silah/shared/select_location_from_map/view.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/store/change_map_activity/view.dart';
import 'package:silah/widgets/snack_bar.dart';
import 'package:silah/widgets/starter_divider.dart';

class LocationBottomSheet extends StatelessWidget {
  const LocationBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          const StarterDivider(),
          const SizedBox(height: 30),
          Image.asset(getAsset("map")),
          const SizedBox(height: 30),
          ElevatedRoundedButton(
              backgroundColor:
                  !ThemeCubit.of(context).isDark ? kPrimaryColor : Colors.white,
              icon: SvgPicture.asset(
                getIcon("manual_selection"),
                color: !ThemeCubit.of(context).isDark
                    ? Colors.white
                    : kPrimaryColor,
              ),
              title: "تحديد يدوي",
              titleColor:
                  !ThemeCubit.of(context).isDark ? Colors.white : kPrimaryColor,
              borderColor:
                  !ThemeCubit.of(context).isDark ? Colors.white : kPrimaryColor,
              onTap: () {
                RouteManager.navigateTo(SelectLocationFromMapView());
              }),
          const SizedBox(height: 4),
          ElevatedRoundedButton(
            backgroundColor:
                !ThemeCubit.of(context).isDark ? Colors.white : kPrimaryColor,
            icon: SvgPicture.asset(
              getIcon("automatic_selection"),
              color:
                  !ThemeCubit.of(context).isDark ? kPrimaryColor : Colors.white,
            ),
            title: "تحديد تلقائي",
            titleColor:
                !ThemeCubit.of(context).isDark ? kPrimaryColor : Colors.white,
            borderColor:
                !ThemeCubit.of(context).isDark ? kPrimaryColor : Colors.white,
            onTap: () async {
              final success = await LocationManager.setLocation();
              if (success) {
                showSnackBar("تم تحديد الموقع");
                // Navigate
                RouteManager.navigateAndPopAll(NavBarView());
              }
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
