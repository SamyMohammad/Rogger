import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

class Logo extends StatelessWidget {
  final double heightFraction;
  final Color? color;

  Logo({this.heightFraction = 3, this.color}) {
    withBG = false;
  }

  Logo.bg({this.heightFraction = 3, this.color}) {
    withBG = true;
  }
  late final bool withBG;

  @override
  Widget build(BuildContext context) {
    if (withBG) {
      return _logoBG();
    }
    return _logo();
  }

  Widget _logo() => Center(
        child: SizedBox(
          height: sizeFromHeight(heightFraction),
          // child: Image.asset(getAsset('logo'), color: color,)),
          child: Center(
              child: SvgPicture.asset(
            getIcon("main_logo_roger"),
            color: color,
            height: 90,
          )),
        ),
      );

  Widget _logoBG() => Center(
        child: Container(
          padding: EdgeInsets.all(6),
          child: CircleAvatar(
              backgroundColor: kBackgroundColor,
              radius: sizeFromHeight(8),
              child:
                  Image.asset(getAsset('logo'), color: color ?? kPrimaryColor)),
          decoration: BoxDecoration(color: kGreyColor, shape: BoxShape.circle),
        ),
      );
}
