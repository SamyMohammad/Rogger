import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';

class CustomTabview extends StatefulWidget {
  final String firstTabTitle;
  final String secondTabTitle;
  final Function(bool isFirstActive) onTap;
  const CustomTabview({
    required this.firstTabTitle,
    required this.onTap,
    required this.secondTabTitle,
    super.key,
  });

  @override
  State<CustomTabview> createState() => _CustomTabviewState();
}

class _CustomTabviewState extends State<CustomTabview> {
  bool isFirstActive = true;
  void onFirstTapPressed() {
    setState(() {
      isFirstActive = true;
    });
    widget.onTap(isFirstActive);
  }

  void onSecondTapPressed() {
    setState(() {
      isFirstActive = false;
    });
    widget.onTap(isFirstActive);
  }

  @override
  Widget build(BuildContext context) {
    final List<BoxShadow> activeBoxShadow = [
      //Top
      BoxShadow(
          color: ThemeCubit.of(context).isDark
              ? kPrimary1Color.withOpacity(0.5)
              : Colors.grey.withOpacity(0.6),
          offset: Offset(0, 5),
          blurRadius: 2,
          spreadRadius: 1,
          inset: true),
      //left
      BoxShadow(
        inset: true,
        color: ThemeCubit.of(context).isDark
            ? kPrimary1Color.withOpacity(0.3)
            : Colors.grey.withOpacity(0.3),
        offset: Offset(2, 0),
        blurRadius: 2,
        spreadRadius: -1,
      ),
    ];
    final List<BoxShadow> inActiveBoxShadow = [
      BoxShadow(
        color: ThemeCubit.of(context).isDark
            ? kPrimary1Color.withOpacity(0.3)
            : Colors.grey.withOpacity(0.5),
        offset: Offset(0, 5),
        blurRadius: 2,
        spreadRadius: 1,
      ),
    ];
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onFirstTapPressed,
            child: Container(
              height: 44,
              child: Center(
                  child: Text(
                widget.firstTabTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isFirstActive
                      ? Theme.of(context).primaryColor
                      : kLightGreyColorB4,
                ),
              )),
              decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                  // border: Border.all(color: Colors.red),
                  boxShadow:
                      isFirstActive ? activeBoxShadow : inActiveBoxShadow),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onSecondTapPressed,
            child: Container(
              height: 44,
              child: Center(
                child: Text(widget.secondTabTitle,
                    style: TextStyle(
                        color: !isFirstActive
                            ? Theme.of(context).primaryColor
                            : kLightGreyColorB4,
                        fontWeight: FontWeight.bold)),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  boxShadow:
                      !isFirstActive ? activeBoxShadow : inActiveBoxShadow),
            ),
          ),
        ),
      ],
    );
  }
}
