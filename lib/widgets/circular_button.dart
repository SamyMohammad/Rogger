import 'package:flutter/material.dart';

import '../constants.dart';

class CircularButton extends StatelessWidget {
  final IconData? iconData;
  final Function? onTap;
  final Color color;
  final Color? iconColor;
  final double? radius;
  final double? iconSize;
  CircularButton(
      {this.iconData,
      this.onTap,
      this.color = kPrimaryColor,
      this.iconColor,
      this.radius,
      this.iconSize});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: CircleAvatar(
          radius: radius ?? 15,
          foregroundColor: kBackgroundColor,
          backgroundColor: color,
          child: Icon(
            iconData,
            size: iconSize ?? 13,
            color: iconColor,
          ),
        ),
      ),
      // child: Container(
      //   margin: EdgeInsets.all(10),
      //   padding: EdgeInsets.all(10),
      //   child: Icon(iconData,color: onTap == null ? kGreyColor : kPrimaryColor,size: 20,),
      //   decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       color: Colors.white,
      //       boxShadow: [
      //         BoxShadow(
      //           color: onTap == null ? kGreyColor : kPrimaryColor.withOpacity(0.5),
      //           spreadRadius: 5,
      //           blurRadius: 7,
      //           offset: Offset(0, 3), // changes position of shadow
      //         ),
      //       ]
      //   ),
      // ),
      onTap: () => onTap!(),
    );
  }
}
