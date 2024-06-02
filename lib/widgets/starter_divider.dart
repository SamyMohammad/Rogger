import 'package:flutter/material.dart';
import 'package:silah/constants.dart';

class StarterDivider extends StatelessWidget {
  final double? height;
  final double? width;
  const StarterDivider({
    this.height,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 5,
      width: width ?? 45,
      decoration: BoxDecoration(
          color: kGreyButtonColorD9, borderRadius: BorderRadius.circular(10)),
    );
  }
}
