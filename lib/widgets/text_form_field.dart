import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class InputFormField extends StatefulWidget {
  final String? hint;
  final String? Function(String?)? validator;
  final Function? onPressed;
  final bool? secure;
  final bool? isNumber;
  final Function(String?)? onSave;
  final int? minLines;
  final int? maxLines;
  final IconData? icon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool disabled;
  final bool? isNext;
  final int? maxLength;
  final String? upperText;
  final bool? hasLabel;
  final Color? textColor;
  final bool? isRTL;
  final double? horizontalMargin;
  final double? verticalMargin;
  final bool? multiLine;
  final Color? fillColor;
  final bool hasBorder;
  final AutovalidateMode? autoValidateMode;
  final FocusNode? focusNode;
  final double? radius;
  final double? height;
  final Widget? iconWidget;
  final double? fontSize;
  final bool isDense;
  final bool? isCommetiontyping;
  final String? initialValue;
  const InputFormField({
    Key? key,
    this.isNumber = false,
    this.initialValue,
    this.isDense = false,
    this.controller,
    this.maxLines,
    this.minLines,
    this.onPressed,
    this.onSave,
    this.fontSize,
    this.secure = false,
    this.hint,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.onTap,
    this.isNext = true,
    this.maxLength,
    this.upperText,
    this.hasLabel = false,
    this.isRTL = true,
    this.icon,
    this.textColor,
    this.horizontalMargin = 0,
    this.multiLine = false,
    this.fillColor,
    this.hasBorder = true,
    this.autoValidateMode,
    this.disabled = false,
    this.verticalMargin = 0,
    this.focusNode,
    this.radius,
    this.height,
    this.iconWidget,
    this.isCommetiontyping = false,
  }) : super(key: key);

  @override
  _InputFormFieldState createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  bool? _showPassword;

  @override
  void initState() {
    _showPassword = widget.secure;
    super.initState();
  }

  @override
  void dispose() {
    widget.focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isRTL! ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: widget.verticalMargin!,
          horizontal: widget.horizontalMargin!,
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.upperText != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    widget.upperText!,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              Container(
                child: TextFormField(
                  initialValue: widget.initialValue,
                  focusNode: widget.focusNode,
                  autovalidateMode: widget.autoValidateMode,
                  controller: widget.controller,
                  obscureText: _showPassword!,
                  onSaved: widget.onSave,
                  onChanged: widget.onChanged,
                  maxLength: widget.maxLength,
                  textInputAction: widget.multiLine == true
                      ? TextInputAction.newline
                      : TextInputAction.done,
                  // textInputAction: widget.multiLine! ? TextInputAction.newline : widget.isNext! ? TextInputAction.next : TextInputAction.done,
                  keyboardType: widget.multiLine!
                      ? TextInputType.multiline
                      : widget.isNumber!
                          ? TextInputType.number
                          : TextInputType.text,
                  cursorColor: Theme.of(context).primaryColor,
                  validator: widget.validator,
                  minLines: widget.minLines,
                  maxLines: widget.secure!||widget.maxLines==null ? 1 : widget.maxLines,
                  enabled: !widget.disabled && widget.onTap == null,
                  buildCounter: (context,
                          {int? currentLength, bool? isFocused, maxLength}) =>
                      null,
                  style: TextStyle(
                      color: widget.textColor ?? Theme.of(context).primaryColor,
                      fontSize: widget.fontSize),
                  decoration: InputDecoration(
                    isDense: widget.isDense,
                    constraints: widget.height != null
                        ? BoxConstraints(
                            minHeight: widget.height!,
                            maxHeight: widget.height!,
                          )
                        : null,
                    filled: true,
                    hintStyle: TextStyle(
                        color: widget.textColor ?? Colors.grey, fontSize: 14),
                    labelStyle: TextStyle(
                        color:
                            widget.textColor ?? Theme.of(context).primaryColor),
                    fillColor: widget.fillColor ??
                        Theme.of(context).appBarTheme.backgroundColor,
                    counterStyle:
                        const TextStyle(fontSize: 0, color: Colors.transparent),
                    prefixIcon: widget.icon == null && widget.iconWidget == null
                        ? null
                        : widget.icon != null
                            ? Icon(
                                widget.icon,
                                color: kPrimaryColor,
                                size: 18,
                              )
                            : widget.iconWidget,
                    suffixIcon: widget.suffixIcon != null
                        ? widget.suffixIcon
                        : widget.secure!
                            ? IconButton(
                                padding: const EdgeInsets.all(0),
                                icon: Icon(
                                  _showPassword!
                                      ? FontAwesomeIcons.eyeSlash
                                      : FontAwesomeIcons.eye,
                                  color: Theme.of(context).primaryColor,
                                  size: 18,
                                ),
                                onPressed: () => setState(
                                    () => _showPassword = !_showPassword!),
                              )
                            : null,
                    hintText: widget.hasLabel! ? null : widget.hint,
                    labelText: widget.hasLabel! ? widget.hint : null,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: widget.maxLines == 1 && widget.icon == null
                            ? 0
                            : 15),
                    enabledBorder: getBorder(kDarkGreyColor),
                    
                    focusedBorder: getBorder(Theme.of(context).primaryColor,width: 2),
                    errorBorder: getBorder(Colors.red),
                    focusedErrorBorder: getBorder(Theme.of(context).primaryColor, width: 2),
                    disabledBorder: getBorder(kGreyColor),
                  ),
                ),
                // decoration: BoxDecoration(
                //   color: kLightPurpleColor,
                //   borderRadius: borderRadius
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BorderRadius get _borderRadius => BorderRadius.circular(widget.radius ?? 10);

  InputBorder getBorder(Color color,{ double? width}) {
    if (widget.hasBorder) {
      return OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: color,width:  width??1),
      );
    } else {
      return UnderlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: color),
      );
    }
  }
}
