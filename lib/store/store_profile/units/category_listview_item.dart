import 'package:flutter/material.dart';
import 'package:silah/constants.dart';

class CategoryListviewItem extends StatelessWidget {
  final VoidCallback onTap;
  final String categoryName;
  final bool isSelected;
  const CategoryListviewItem(
      {super.key,
      required this.isSelected,
      required this.categoryName,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(25),
          color: isSelected
              ? kLightGreyColorEB
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? kBackgroundCDarkColor : kDarkGreyColor,
            ),
          ),
        ),
      ),
    );
  }
}
