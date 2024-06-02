import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared/nav_bar/cubit/cubit.dart';

class PopScaffold extends StatefulWidget {
  final Widget child;

  PopScaffold({required this.child});

  @override
  State<PopScaffold> createState() => _PopScaffoldState();
}

class _PopScaffoldState extends State<PopScaffold> with WidgetsBindingObserver {
  Timer? timer;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    timer = Timer.periodic(Duration(minutes: ONLINE_MINUTES_COUNT_CHECKER - 1),
        (timer) {
      if (state == AppLifecycleState.resumed) {
        navBarCubit.toggleOnlineStatus(true);
      } else {
        navBarCubit.toggleOnlineStatus(false);
      }
    });
    super.initState();
  }

  final navBarCubit = NavBarCubit(currentIndex: 0);

  AppLifecycleState? state;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    this.state = state;
    navBarCubit.toggleOnlineStatus(state == AppLifecycleState.resumed);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        child: Directionality(
          child: widget.child,
          textDirection: TextDirection.rtl,
        ),
        onTap: () => closeKeyboard(),
        // Platform.isIOS ?
        // : null,
      ),
    );
  }
}
