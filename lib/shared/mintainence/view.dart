import 'package:flutter/material.dart';

class MaintainenceView extends StatelessWidget {
  const MaintainenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset('assets/images/mintainince.jpg'),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: const Text('التطبيق تحت الصيانة \n الرجاء المحاولة في وقت لاحق',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            )),
      )
    ])));
  }
}
