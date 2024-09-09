import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/core/validator/validation.dart';

import '../constants.dart';
import '../user/advertisers_on_map/map_categories_model.dart';

class DropMenu<T> extends StatefulWidget {
  final bool hasBorder;
  final String? upperText;
  final String? hint;
  final dynamic value;
  final String? label;
  final List items;
  final Color? borderColor;
  final bool isItemsModel;
  final Function(dynamic)? onChanged;
  final bool? isMapDepartment;
  final dynamic selectedValue;

  const DropMenu(
      {this.hasBorder = true,
      this.upperText,
      required this.items,
      this.onChanged,
      this.isItemsModel = false,
      this.hint,
      this.label,
      this.isMapDepartment,
      this.borderColor,
      this.value,
      this.selectedValue});

  @override
  State<DropMenu> createState() => _DropMenuState();
}

class _DropMenuState<T> extends State<DropMenu> {
  dynamic value;

  @override
  void initState() {
    // if (widget.value != null) {
    //   value = widget.isItemsModel
    //       ? widget.items.firstWhere((element) => element.id == widget.value)
    //       : widget.value;
    // }
    //   if (widget.value != null && widget.items.isNotEmpty) {
    //   value = widget.isItemsModel
    //       ? widget.items.firstWhere((element) => element.id == widget.value)
    //       : widget.value;
    // }

    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: DropdownButtonFormField(
            isExpanded: false,
            onTap: () => showBottomSheet(
                context: context,
                builder: (context) => CupertinoPicker(
                      itemExtent: 30, // Height of each item in the picker
                      onSelectedItemChanged: (int index) {
                        // Callback function when an item is selected
                        // Use 'index' to determine which item was selected
                      },
                      children: [
                        ...widget.items.map((e) => Text(e.toString())).toList(),
                        ...widget.items.map((e) => Text(e.toString())).toList(),
                      ],
                    )),
            dropdownColor: Theme.of(context).appBarTheme.backgroundColor,
            selectedItemBuilder: widget.isMapDepartment == true
                ? (context) {
                    return widget.items
                        .map(
                          (e) => DropdownMenuItem(
                            child: Row(
                              children: [
                                if (value == null)
                                  Text(
                                    'الرجاء الاختيار',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kLightGreyColor),
                                  ),
                                if (value != null)
                                  Text(
                                    widget.isItemsModel ? e.name : e.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),

                                // if (value == e &&
                                //     isExpanded) // Show radio button only for selected item
                                //
                                //   Radio<MapCategory>(
                                //     value: e,
                                //     groupValue: value,
                                //     onChanged: (MapCategory? newValue) {
                                //       setState(() {
                                //         value = newValue;
                                //       });
                                //     },
                                //   )
                                // Radio<MapCategory>(
                                //     value: value,
                                //     groupValue: e,
                                //     onChanged: (v) {
                                //       if (widget.onChanged == null) return;
                                //       widget.onChanged!(v);
                                //       closeKeyboard();
                                //       setState(() => value = v);
                                //     })
                              ],
                            ),
                            value: e,
                          ),
                        )
                        .toList();
                  }
                : null,
            borderRadius: BorderRadius.circular(10),
            elevation: 1,
            icon: Icon(FontAwesomeIcons.chevronDown, size: 14),
            hint: Text(
              widget.hint ?? '',
              style: TextStyle(color: kDarkGreyColor, fontSize: 14),
            ),
            // style: TextStyle( color:Colors.black45, fontSize: 14),
            value: widget.value != null
                ? widget.value
                : null, // guard it with null if empty

            validator: Validator.dropMenu,
            onChanged: widget.items.isNotEmpty
                ? (v) {
                    if (widget.onChanged == null) return;
                    widget.onChanged!(v);
                    closeKeyboard();
                    setState(() => value = v);
                  }
                : null,
            iconEnabledColor: Theme.of(context).primaryColor,
            items: widget.items
                .map(
                  (e) => DropdownMenuItem(
                    child: Row(
                      children: [
                        Text(
                          widget.isItemsModel ? e.name : e.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        if (widget.isMapDepartment == true) Spacer(),
                        // if (value ==
                        //     e) // Show radio button only for selected item
                        if (widget.isMapDepartment == true)
                          Radio<MapCategory>(
                            activeColor: Color(0xFF17910D),
                            value: e,
                            focusColor: Theme.of(context).primaryColor,
                            groupValue: value,
                            onChanged: value == e
                                ? (MapCategory? newValue) {
                                    setState(() {
                                      value = newValue;
                                    });
                                  }
                                : null,
                          ),
                        // if (widget.isMapDepartment == null)
                        //   Radio<Category>(
                        //     activeColor: Color(0xFF17910D),
                        //     value: e,
                        //     focusColor: Theme.of(context).primaryColor,
                        //     groupValue: value,
                        //     onChanged: value == e
                        //         ? (Category? newValue) {
                        //             setState(() {
                        //               value = newValue;
                        //             });
                        //           }
                        //         : null,
                        //   )

                        // Radio<MapCategory>(
                        //     value: value,
                        //     groupValue: e,
                        //     onChanged: (v) {
                        //       if (widget.onChanged == null) return;
                        //       widget.onChanged!(v);
                        //       closeKeyboard();
                        //       setState(() => value = v);
                        //     })
                      ],
                    ),
                    value: e,
                  ),
                )
                .toList(),
                
            decoration: InputDecoration(
              label: widget.label != null
                  ? Text(
                      widget.label!,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  : null,
                
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              enabledBorder:
                  getBorder(Theme.of(context).primaryColor ?? kGreyColor),
              focusedBorder: getBorder(widget.borderColor ?? kGreyColor),
              errorBorder: getBorder(Colors.red),
              focusedErrorBorder: getBorder(kPrimaryColor),
              disabledBorder: getBorder(Colors.transparent),
            ),
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: borderRadius),
        ),
      ],
    );
  }

  final BorderRadius borderRadius = BorderRadius.circular(10);

  InputBorder getBorder(Color color) {
    if (widget.hasBorder) {
      return OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: color),
      );
    } else {
      return UnderlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: color),
      );
    }
  }
}
