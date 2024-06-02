import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../constants.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {Key? key,
      required this.image,
      required this.title,
      required this.id,
      this.isSelected = false,
      this.isCategoriesInStoreSearch,
      this.onPressed,
      this.backgroundColor = Colors.transparent})
      : super(key: key);
  final String image;
  final bool? isCategoriesInStoreSearch;
  final String title;
  final String id;
  final bool isSelected;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    print(image);
    if (isCategoriesInStoreSearch ?? false) {
      return InkWell(
        onTap: isSelected ? null : onPressed,
        // onTap: isSelected ? null : () => RouteManager.navigateAndPopUntilFirstPage(CategoryDetailsView(categoryId: id, title: title,)),
        child: Container(
          width: 80,
          child: Center(
            child: Text(
              title.toString(),
              style: TextStyle(
                  fontSize: isSelected ? 14 : 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? kPrimaryColor : kDarkGreyColor),
            ),
          ),
          decoration: BoxDecoration(
            color: kLightGreyColorEB,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: isSelected ? null : onPressed,
        // onTap: isSelected ? null : () => RouteManager.navigateAndPopUntilFirstPage(CategoryDetailsView(categoryId: id, title: title,)),
        child: Container(
          margin: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 5,
          ),
          // padding: EdgeInsets.all(5),
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle,
          //    border: Border.all(
          //      color: kPrimaryColor,
          //    ) ,
          //     // borderRadius: BorderRadius.circular(100),
          //     // color: isSelected ? kPrimaryColor.withOpacity(0.5) : Color(0xFFE7F0FF)
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: LoadingIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                title.toString(),
                style: TextStyle(
                  fontSize: isSelected ? 14 : 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Theme.of(context).primaryColor : kDarkGreyColor,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
