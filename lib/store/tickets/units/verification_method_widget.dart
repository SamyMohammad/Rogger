import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silah/constants.dart';

class VerificationMethodWidget extends StatelessWidget {
  final String icon;
  final String name;
  final bool isActive;
  final VoidCallback onTap;
  const VerificationMethodWidget({
    required this.icon,
    required this.isActive,
    required this.name,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(left: icon == "freelancing" ? 0 : 14),
          height: 75,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).appBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: isActive
                      ? kBluePurpleColor.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.5),
                  offset: Offset(0, 3),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  getIcon(icon),
                  width: 80,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
