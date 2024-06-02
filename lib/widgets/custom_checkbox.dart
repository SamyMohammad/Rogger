import 'package:flutter/material.dart';
import 'package:silah/constants.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isActive;
  const CustomCheckbox({
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: kDarkGreyColor),
      ),
      child: !isActive
          ? const SizedBox.shrink()
          : Center(
              child: CircleAvatar(
                backgroundColor: activeSwitchColor,
                radius: 4,
              ),
            ),
    );
  }
}
