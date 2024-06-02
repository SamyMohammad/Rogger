import 'package:flutter/material.dart';

import '../../constants.dart';

class ListTileWidget extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  final Widget? trailing;
  final Widget? leading;

  const ListTileWidget({
    Key? key,
    this.title,
    this.onPressed,
    this.trailing,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 50,
      horizontalTitleGap: 0,
      textColor: kAccentColor,
      title: Text(
        title.toString(),
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
      trailing: trailing,
      leading: leading,
      onTap: onPressed,
      contentPadding: EdgeInsets.all(0),
    );
  }
}
