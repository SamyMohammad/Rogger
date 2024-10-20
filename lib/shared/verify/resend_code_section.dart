import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silah/shared/verify/cubit/cubit.dart';

class ResendCodeSection extends StatefulWidget {
  const ResendCodeSection({Key? key}) : super(key: key);
  @override
  _ResendCodeSectionState createState() => _ResendCodeSectionState();
}

class _ResendCodeSectionState extends State<ResendCodeSection> {
  int seconds = 59;
  Timer? _timer;

  @override
  void initState() {
    count();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void count() {
    setState(() => seconds = 30);
    if (_timer != null) _timer!.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds <= 0) {
        timer.cancel();
      } else {
        setState(() => seconds--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
        color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: seconds != 0
          ? Center(
              child: Text(
              '00:' + seconds.toString().padLeft(2, '0'),
              style: _style,
            ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('لـم تستلم الرسالة ؟'),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {
                    VerifyCubit.of(context).resendCode().then((value) {
                      count();
                    });
                  },
                  child: Text(
                    'اعاده ارسال',
                    style: _style,
                  ),
                ),
              ],
            ),
    );
  }
}
