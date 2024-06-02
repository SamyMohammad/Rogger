import 'package:flutter/material.dart';

import '../../constants.dart';

class CategoriesAssigned extends StatelessWidget {
  const CategoriesAssigned({Key? key, this.title, this.categoryId})
      : super(key: key);
  final String? title;
  final String? categoryId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xFFE7F0FF)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.toString(),
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: kAccentColor),
            )
          ],
        ),
      ),
    );
  }
}
