import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/constants.dart';

class SearchTextField extends StatelessWidget {
  SearchTextField({
    super.key,
  });
  final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: kPrimaryColor, width: 2));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 2,
        left: 2,
      ),
      child: TextField(
        cursorHeight: 20,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 10, right: 20),
          hintText: 'البحث',
          hintStyle: TextStyle(
            color: kGreyColor,
          ),
          enabledBorder: borderStyle,
          focusedBorder: borderStyle,
          suffixIcon: Container(
            margin: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ),
            child: Icon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.white,
              size: 16,
            ),
            decoration: BoxDecoration(
              color: kAccentColor,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    );
  }
}
