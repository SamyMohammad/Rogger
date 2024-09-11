import 'package:flutter/material.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';

import '../constants.dart';
import '../core/router/router.dart';

appBar({
  String? title,
  VoidCallback? onTitleClicked,
  Widget? subtitle,
  List<Widget>? titleWidgets,
  bool centerTitle = true,
  Widget? leading,
  List<Widget>? actions,
  bool elevation = true,
  BuildContext? context,
  bool isDark = false,
}) {
  return PreferredSize(
    preferredSize: appBarSize,
    child: Builder(builder: (context) {
      return Stack(
        children: [
          AppBar(
            elevation: 0,
            // automaticallyImplyLeading: true,
            // backgroundColor: context == null
            //     ? kBackgroundColor
            //     : Theme.of(context).appBarTheme.backgroundColor,
            title: Row(
              mainAxisAlignment: centerTitle
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (titleWidgets != null) ...titleWidgets,
                SizedBox(width: 8),
                GestureDetector(
                  onTap: onTitleClicked,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) subtitle,
                    ],
                  ),
                ),
              ],
            ),
            titleSpacing: titleWidgets != null ? -8 : null,
            centerTitle: centerTitle,

            leading: Navigator.of(context).canPop()
                ? leading ??
                    IconButton(
                      onPressed: () => RouteManager.pop(),
                      // padding: EdgeInsets.all(-20),
                      icon: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(

                            // borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(.15)),
                        child: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          weight: 5,
                        ),
                      ),
                    )
                : null,
            actions: actions,

            iconTheme: IconThemeData(
              color: Theme.of(context).primaryColor,
            ),
          ),
          if (elevation)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: ThemeCubit.of(context).isDark
                          ? kPrimary1Color
                          : kGreyColor,
                      blurRadius: 1.5,
                      spreadRadius: 0.2,
                    )
                  ],
                ),
              ),
            ),
        ],
      );
    }),
  );
}

Size get appBarSize {
  return Size(double.infinity, AppBar().preferredSize.height);
}

double get appBarTopSpacing {
  final topPadding = MediaQuery.of(RouteManager.currentContext).padding.top;
  return topPadding;
}

// if (elevation)
// Align(
// alignment: Alignment.bottomCenter,
// child: Container(
// height: 1,
// width: double.infinity,
// decoration: BoxDecoration(
// boxShadow: [
// BoxShadow(
// color: kGreyColor,
// blurRadius: 1.5,
// spreadRadius: 0.2,
// )
// ],
// ),
// ),
// ),
