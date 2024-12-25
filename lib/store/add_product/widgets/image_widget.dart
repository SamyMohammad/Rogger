import 'dart:io';

import 'package:flutter/material.dart';
import 'package:silah/constants.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.index,
    required this.image,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final File image;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      height: sizeFromWidth(3.5),
      width: sizeFromWidth(3.5),
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: kGreyColor,
            child: Text(
              (index + 1).toString(),
              style: TextStyle(
                color: kPrimaryColor,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: kGreyColor,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                onTap: onDelete,
              ),
              GestureDetector(
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: kGreyColor,
                  child: Icon(
                    Icons.edit,
                    color: kPrimaryColor,
                    size: 20,
                  ),
                ),
                onTap: onEdit,
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.fill,
        ),
        color: kPrimaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
