import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

class ErrorView extends StatelessWidget {
  ErrorView([this.onTap]);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(getLottie('no_connection')),
              if (onTap != null) Text('اضغط لاعادة المحاولة!'),
            ],
          ),
        ),
      ),
    );
  }
}
