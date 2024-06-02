import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared/nav_bar/cubit/cubit.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key, this.onTap, required this.index}) : super(key: key);
  final Function(int)? onTap;
  final int index;
  @override
  Widget build(BuildContext context) {
    final cubit = NavBarCubit.get(context);
    getNavItem(String name, bool isSelected) {
      return SvgPicture.asset(
        getIcon(name),
        color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        height: 25,
        width: 25,
      );
    }

    getChatIcon(bool isSelected) {
      return Stack(
        children: [
          SvgPicture.asset(
            getIcon(isSelected ? "active_chat" : "inactive_chat"),
            color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            // height: 25,
            // width: 25,
          ),
          if (cubit.hasUnreadMessages)
            CircleAvatar(radius: 3, backgroundColor: Colors.red),
        ],
      );
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: index,

      showSelectedLabels: true,
      // selectedFontSize: 22,
      selectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      elevation: 20,
      selectedLabelStyle: TextStyle(fontSize: 0),
      // selectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          label: '',
          activeIcon: getNavItem("active_home", true),
          icon: getNavItem("inactive_home", false),
        ),
        BottomNavigationBarItem(
          label: '',
          activeIcon: getNavItem("active_map", true),
          icon: getNavItem("inactive_map", false),
        ),
        BottomNavigationBarItem(
          label: '',
          activeIcon: getChatIcon(true),
          icon: getChatIcon(false),
        ),
        BottomNavigationBarItem(
          label: '',
          activeIcon: getNavItem("active_profile", true),
          icon: getNavItem("inactive_profile", false),
        ),
      ],
      onTap: onTap,
    );
  }
}
