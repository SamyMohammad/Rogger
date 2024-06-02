import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';

class HeaderActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isActive;
  final String activeLabel;
  final String inActiveLabel;
  const HeaderActionButton({
    required this.isActive,
    required this.onTap,
    required this.activeLabel,
    required this.inActiveLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          height: 36,
          width: 86,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2.0, // Width of the outer border
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: Center(
            child: Container(
              height: 30,
              width: 80,
              child: Center(
                child: Text(
                  AppStorage.isStore
                      ? inActiveLabel
                      : isActive
                          ? activeLabel
                          : inActiveLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isActive
                        ? kPrimary1Color
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? kLightGreyColorEB
                    : Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kLightGreyColorEB, width: .1),
              ),
            ),
          ),
        ));
  }
}
