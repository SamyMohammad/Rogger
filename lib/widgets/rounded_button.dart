import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool border;

  const RoundedButton(
      {Key? key, required this.title, this.onPressed, this.border = true})
      : super(key: key);

  BorderRadius get _getBorderRadius => BorderRadius.circular(20);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: _getBorderRadius,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 2),
          child: Text(
            title,
            style: TextStyle()
                .copyWith(color: border ? kPrimaryColor : kBackgroundColor),
          ),
          decoration: BoxDecoration(
              color: border ? Colors.transparent : kPrimaryColor,
              border: Border.all(color: kPrimaryColor),
              borderRadius: _getBorderRadius),
        ),
      ),
    );
  }
}
