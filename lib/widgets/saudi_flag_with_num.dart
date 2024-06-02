import 'package:flutter/material.dart';
import 'package:silah/constants.dart';

class SaudiFlagWithNum extends StatelessWidget {
  const SaudiFlagWithNum({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VerticalDivider(thickness: 1, endIndent: 15, indent: 15),
          const SizedBox(width: 4),
          Text(
            "966",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          const SizedBox(width: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(getAsset("saudi_flag"), width: 35, height: 20),
          ),
          const SizedBox(width: 12)
        ],
      ),
    );
  }
}
