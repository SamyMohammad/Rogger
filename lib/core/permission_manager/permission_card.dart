// import 'package:afaq/constants.dart';
// import 'package:flutter/material.dart';
//
// class PermissionCard extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final Function() onAccept;
//   final Function() onDeny;
//
//   PermissionCard({required this.icon, required this.text, required this.onAccept, required this.onDeny});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: [
//           Container(
//             height: double.infinity,
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             child: Icon(icon, size: 20, color: kBackgroundColor,),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
//               color: kPrimaryColor
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10),
//                 Expanded(child: Text(text, style: getTextTheme.bodyText1,)),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(onPressed: onAccept, child: Text('موافق')),
//                       TextButton(onPressed: onDeny, child: Text('الغاء')),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(width: 10),
//         ],
//       ),
//       decoration: BoxDecoration(
//         color: kLightPurpleColor,
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
// }
