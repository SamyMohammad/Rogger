// import 'package:afaq/core/permission_manager/permission_card.dart';
// import 'package:afaq/core/permission_manager/permission_model.dart' as AppPermissions;
// import 'package:flutter/material.dart';
// import '../../constants.dart';
//
// class AppPermissionsSections extends StatefulWidget {
//   @override
//   State<AppPermissionsSections> createState() => _AppPermissionsSectionsState();
// }
//
// class _AppPermissionsSectionsState extends State<AppPermissionsSections> {
//   List<AppPermissions.PermissionModel> permissions = [];
//
//   bool firstCheck = true;
//
//   @override
//   void initState() {
//     getPermissions();
//     super.initState();
//   }
//
//   void getPermissions() async {
//     final permissions = await AppPermissions.getPermissionsStatus();
//     this.permissions = permissions;
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return permissions.isEmpty ? SizedBox() : Container(
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       height: sizeFromHeight(7),
//       child: Stack(
//         children: permissions.map(
//               (e) => PermissionCard(
//                 text: e.title,
//                 icon: e.icon,
//                 onAccept: () {
//                   AppPermissions.requestPermission(e);
//                   removePermission(e);
//                 },
//                 onDeny: () => removePermission(e),
//               ),
//             ).toList(),
//       ),
//     );
//   }
//
//   void removePermission(AppPermissions.PermissionModel permissionModel) {
//     permissions.remove(permissionModel);
//     setState(() {});
//     if (permissions.isEmpty) {
//       dispose();
//     }
//   }
//
// }
//
// /*
//  # Detect if widget has been visible or not
//   visibility_detector: ^0.2.2
//
// key: Key('V'),
//       onVisibilityChanged: (info) {
//         if (info.visibleBounds.top != 0
//             || info.visibleBounds.bottom != 0
//             || info.visibleBounds.left != 0
//             || info.visibleBounds.right != 0
//         ) {
//           if(!firstCheck) {
//             getPermissions();
//           } else {
//             firstCheck = false;
//           }
//         }
//       },
//  */
//
// // return FloatingSliverAppBar(
// //   height: sizeFromHeight(7),
// //   spaceChild: Stack(
// //     children: [
// //       PermissionCard(
// //         text: 'يجب تفعيل الاشعارات',
// //         icon: Icons.height,
// //         onAccept: (){},
// //         onDeny: (){},
// //       ),
// //       PermissionCard(
// //         text: 'AA',
// //         icon: Icons.height,
// //         onAccept: (){},
// //         onDeny: (){},
// //       ),
// //       PermissionCard(
// //         text: 'يجب تفعيل الاشعارات',
// //         icon: Icons.notification_important_outlined,
// //         onAccept: (){},
// //         onDeny: (){},
// //       ),
// //     ],
// //   ),
// // );
