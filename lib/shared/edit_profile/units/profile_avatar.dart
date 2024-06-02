// part of '../view.dart';
//
// class _ProfileAvatar extends StatelessWidget {
//   const _ProfileAvatar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final cubit = EditProfileCubit.of(context);
//     return Center(
//       child: BlocBuilder(
//         bloc: cubit,
//         builder: (context, state) => Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: NetworkImage(AppStorage.getUserModel()?.profileImage ?? ''),
//                   fit: BoxFit.fitHeight,
//                 ),
//               ),
//             ),
//             if (state is EditProfileAvatarLoadingState)
//               Container(
//                 width: 120,
//                 height: 120,
//                 child: LoadingIndicator(),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//               ),
//             if (state is! EditProfileAvatarLoadingState)
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: InkWell(
//                   onTap: cubit.updateImage,
//                   child: CircleAvatar(
//                     radius: 18,
//                     backgroundColor: kPrimaryColor,
//                     foregroundColor: Colors.white,
//                     child: Icon(FontAwesomeIcons.pen, size: 15),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
