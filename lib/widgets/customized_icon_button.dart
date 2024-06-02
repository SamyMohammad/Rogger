import 'package:flutter/material.dart';

class SmallIconButton extends StatelessWidget {
  final IconData iconData;
  final Function() onTap;
  final double iconSize;
  final Color? iconColor;

  const SmallIconButton(
      {required this.iconData,
      required this.onTap,
      this.iconSize = 20,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        ),
      ),
      onTap: onTap,
    );
  }
}
