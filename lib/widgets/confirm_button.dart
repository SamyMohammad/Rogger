import 'package:flutter/material.dart';

import '../constants.dart';

class ConfirmButton extends StatefulWidget {
  final String? title;
  final VoidCallback? onPressed;
  final double? verticalMargin;
  final double? horizontalMargin;
  final Color? color;
  final bool? border;
  final IconData? icon;
  final Color? fontColor;
  final Widget? child;
  final double radius;
  final bool isExpanded;
  final double horizontalPadding;
  final double? verticalPadding;

  ConfirmButton({
    this.onPressed,
    this.radius = 10,
    this.child,
    this.title,
    this.verticalPadding,
    this.verticalMargin = 3,
    this.horizontalMargin = 0,
    this.color = kPrimary2Color,
    this.border = false,
    this.icon,
    this.fontColor,
    this.isExpanded = true,
    this.horizontalPadding = 14,
  });

  ConfirmButton.expanded(
      {int flex = 1,
      this.onPressed,
      this.radius = 10,
      this.child,
      this.title,
      this.verticalPadding,
      this.verticalMargin = 3,
      this.horizontalMargin = 0,
      this.color = activeButtonColor,
      this.border = false,
      this.icon,
      this.fontColor,
      this.horizontalPadding = 14,
      this.isExpanded = true});

  @override
  State<ConfirmButton> createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<ConfirmButton> {
  @override
  Widget build(BuildContext context) {
    return widget.isExpanded
        ? _getButton
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_getButton],
          );
  }

  Widget get _getButton => InkWell(
        onTap: widget.onPressed,
        radius: widget.radius,
        borderRadius: BorderRadius.circular(widget.radius),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding,
              vertical: widget.verticalPadding ?? 12),
          margin: EdgeInsets.symmetric(
              vertical: widget.verticalMargin!,
              horizontal: widget.horizontalMargin!),
          alignment: Alignment.center,
          child: widget.child ??
              (widget.icon == null
                  ? _textTitleWidget
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        _textTitleWidget,
                      ],
                    )),
          decoration: BoxDecoration(
            color: widget.border == true
                ? Theme.of(context).scaffoldBackgroundColor
                : widget.color ?? Color(0xFF5972EA),
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
              color: widget.color!,
              width: 2,
            ),
            // boxShadow: [
            //   BoxShadow(
            //       color: Colors.grey.withOpacity(.6),
            //       spreadRadius: 1,
            //       blurRadius: 4,
            //       offset: Offset(0, 1))
            // ],
          ),
        ),
      );

  Widget get _textTitleWidget => Text(
        widget.title!,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.fontColor ?? Theme.of(context).primaryColor),
      );
}
