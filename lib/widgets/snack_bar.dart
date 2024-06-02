import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silah/core/router/router.dart';

import '../constants.dart';

showSnackBar(
  String message, {
  bool upperSnack = true,
  bool errorMessage = false,
  bool popPage = false,
  duration = 800,
  Color color = kPrimaryColor,
  BuildContext? context,
}) {
  ScaffoldMessenger.of(RouteManager.currentContext).hideCurrentSnackBar();
  ScaffoldMessenger.of(RouteManager.currentContext).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      behavior: upperSnack ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      elevation: 0.0,
      animation: context != null
          ? CurvedAnimation(
              parent: AnimationController(
                vsync: Scaffold.of(context),
                duration: Duration(milliseconds: 300),
              ),
              curve: Curves.slowMiddle,
              reverseCurve: Curves.easeInCirc)
          : null,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(RouteManager.currentContext).height * 0.9),
      dismissDirection: DismissDirection.none,
      content: Column(
        children: [
          // SizedBox(height: sizeFromHeight(9.5)),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: upperSnack ? 5 : 0, horizontal: 25),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: errorMessage
                    ? Colors.red
                    : upperSnack
                        ? Color.fromRGBO(0, 0, 0, 0.7)
                        : color,
                borderRadius: BorderRadius.circular(15)),
          ),
        ],
      ),
      duration: Duration(milliseconds: duration),
    ),
  );
  if (popPage) Timer(Duration(seconds: 5), () => RouteManager.pop());
  // // _snackBar?.remove();
  // AnimatedSnackBar(
  //   snackBarStrategy: RemoveSnackBarStrategy(),
  //   duration: Duration(seconds: 5),
  //   builder: (context) {
  //     return Container(
  //       height: 48,
  //       width: double.infinity,
  //       alignment: Alignment.center,
  //       child: Text(
  //         message,
  //         style: TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //       decoration: BoxDecoration(
  //         color: errorMessage ? Colors.red : color,
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //     );
  //   },
  // )..show(RouteManager.currentContext);
  // if (popPage) Timer(Duration(seconds: 5), () => RouteManager.pop());
}
/*
showSnackBar(String message,{bool upperSnack = false ,bool errorMessage = false,bool popPage = false,duration = 5,Color color = kPrimaryColor}) {
  ScaffoldMessenger.of(RouteManager.currentContext).hideCurrentSnackBar();
  ScaffoldMessenger.of(RouteManager.currentContext).showSnackBar(
    SnackBar(
      backgroundColor: errorMessage ? Colors.red :  upperSnack ? kAccentColor : color,
      behavior: upperSnack ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(5)
      // ),
      margin: upperSnack ? EdgeInsets.only(bottom: sizeFromHeight(1.1)) : null,
      elevation: 0.0,
      content: Text(message,style: TextStyle(color: Colors.white),),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
      duration: Duration(seconds: duration),
    ),
  );
  if(popPage)
    Timer(Duration(seconds: 5),()=> RouteManager.pop());
}
 */
