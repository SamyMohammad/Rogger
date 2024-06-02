import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/location/location_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/nav_bar/view.dart';
import 'package:silah/shared/select_location_from_map/view.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/logo.dart';
import 'package:silah/widgets/snack_bar.dart';

class SelectLocationView extends StatelessWidget {
  const SelectLocationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if(LocationManager.locationInfoModel?.locationInfo?.locTimes == '3') {
    //   return Scaffold(
    //     appBar: appBar(title: 'حدد موقعك'),
    //     body: Center(
    //       child: Text('لقد تخطيت العدد المسموح لتعديل الموقع برجاء التواصل مع الدعم الفني'),
    //     ),
    //   );
    // }
    return Scaffold(
      appBar: AppBar(title: Text('حدد موقعك')),
      body: ListView(
        padding: VIEW_PADDING,
        children: [
          SizedBox(height: 50),
          Logo(
            heightFraction: 6,
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'يجب تحديد موقعك أولا.',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          )),
          ConfirmButton(
            onPressed: () {
              RouteManager.navigateTo(SelectLocationFromMapView());
            },
            verticalMargin: 15,
            color: kPrimaryColor,
            title: ' حدد موقعك من Google Map',
          ),
          ConfirmButton(
            onPressed: () async {
              final success = await LocationManager.setLocation();
              if (success) {
                showSnackBar("تم تحديد الموقع");
                // Navigate
                RouteManager.navigateAndPopAll(NavBarView());
              }
            },
            color: kAccentColor,
            title: ' حدد موقعك تلقائي',
          ),
        ],
      ),
    );
  }
}
