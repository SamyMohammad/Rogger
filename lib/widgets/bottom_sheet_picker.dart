import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared/sign_up/cubit/cubit.dart';

class BottomSheetPicker extends StatefulWidget {
  // int? selectedIndex;

  final List<String> items;
  BottomSheetPicker({super.key, required this.items});

  @override
  State<BottomSheetPicker> createState() => _BottomSheetPickerState();
}

class _BottomSheetPickerState extends State<BottomSheetPicker> {
  @override
  Widget build(BuildContext context) {
    final cubit = SignUpCubit.of(context);
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          showCustomBottomSheet(
            context,
            cubit: cubit,
            children: widget.items,
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: kDarkGreyColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cubit.seletedIndex != null
                    ? widget.items[cubit.seletedIndex!]
                    : 'نوع الحساب',
                style: TextStyle(
                  fontSize: 16,
                  color: cubit.seletedIndex != null
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

  void showCustomBottomSheet(BuildContext context,
      {required List<String> children, required SignUpCubit cubit}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: MediaQuery.sizeOf(context).height * 0.22,
            child: Column(children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kGreyColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'نوع الحساب',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 5);
                  },
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    bool isSelected = cubit.seletedIndex == index;

                    return Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          cubit.changeGroup(children[index], index);
                          Navigator.pop(
                              context); // Close the bottom sheet after selection
                        },
                        child: Container(
                          height: 35.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeBlue
                                .withOpacity(isSelected ? 0.08 : 0.0),
                            borderRadius: BorderRadius.circular(5),
                            // border: Border.all(
                            //   color: isSelected
                            //       ? CupertinoColors.activeBlue
                            //       : Colors.transparent,
                            //   width: 1.5,
                            // ),
                          ),
                          child: Text(
                            children[index],
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
            ]));
      },
    );
  }
}
