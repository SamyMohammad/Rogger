import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/widgets/confirm_button.dart';

class ChooseBottomSheet<T> extends StatefulWidget {
  final List<T> items;
  final String title;
  final String Function(T item) itemLabelBuilder;
  final void Function(T selectedItem) onItemSelected;
  final T? selectedItem;

  ChooseBottomSheet({
    super.key,
    required this.items,
    required this.title,
    required this.itemLabelBuilder,
    required this.onItemSelected,
    this.selectedItem,
  });

  @override
  State<ChooseBottomSheet<T>> createState() => _ChooseBottomSheetState<T>();
}

class _ChooseBottomSheetState<T> extends State<ChooseBottomSheet<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedItem; // Initialize with selected item
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          showCustomBottomSheet(context); // Open the bottom sheet
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey, // Customize border color if needed
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Display selected value or placeholder if no value is selected
              Text(
                selectedValue != null
                    ? widget.itemLabelBuilder(selectedValue!)
                    : widget.title,
                style: TextStyle(
                  fontSize: 16,
                  color: selectedValue != null
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 30,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCustomBottomSheet(BuildContext context) {
    T? tempSelectedValue = selectedValue; // Temporary selection

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: MediaQuery.sizeOf(context).height * 0.3,
              child: Column(
                children: [
                  // Handle section (for drag to close)
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Row with title and confirm button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Confirm button, disabled when no selection change
                      ConfirmButton(
                        verticalPadding: 0,
                        onPressed: tempSelectedValue == null ||
                                tempSelectedValue == selectedValue
                            ? null // Disable button if no selection or same selection
                            : () {
                                setState(() {
                                  selectedValue =
                                      tempSelectedValue; // Update the selected value
                                  widget.onItemSelected(
                                      selectedValue!); // Call the callback function
                                });
                                Navigator.pop(
                                    context); // Close the bottom sheet
                              },
                        title: "تعديل",
                        fontColor: tempSelectedValue == null ||
                                tempSelectedValue == selectedValue
                            ? Color(0xffA1A1A1)
                            : Colors.white,
                        color: tempSelectedValue == null ||
                                tempSelectedValue == selectedValue
                            ? ThemeCubit.of(context).isDark
                                ? Color(0xFF34343B)
                                : Color(0xFFFAFAFA)
                            : activeButtonColor,
                      ),
                      Spacer(
                        flex: 4,
                      ),
                      Text(
                        widget.title, // Customizable title
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Spacer(
                        flex: 7,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // List of items
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 5);
                      },
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        bool isSelected =
                            widget.items.elementAt(index) == tempSelectedValue;

                        return Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              // Update the temporary selected value
                              setState(() {
                                tempSelectedValue = widget.items[index];
                              });
                            },
                            child: Container(
                              height: 35.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CupertinoColors.activeBlue
                                    .withOpacity(isSelected ? 0.08 : 0.0),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                widget.itemLabelBuilder(widget.items[index]),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: isSelected
                                      ? CupertinoColors.activeBlue
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
