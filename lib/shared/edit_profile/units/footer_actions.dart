// part of '../view.dart';
//
// class _FooterActions extends StatelessWidget {
//   const _FooterActions({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final cubit = EditProfileCubit.of(context);
//     return Column(
//       children: [
//         SizedBox(height: 20),
//         BlocBuilder(
//           bloc: cubit,
//           builder: (context, state) =>
//           state is EditProfileLoadingState
//               ? LoadingIndicator()
//               : ConfirmButton(
//             title: 'تعديل الحساب',
//             onPressed: cubit.editProfile,
//           ),
//         ),
//         if (AppStorage.isStore)
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: ConfirmButton(
//               title: 'نبذة عن الحساب',
//               border: true,
//               onPressed: () =>
//                   RouteManager.navigateTo(EditBriefView()),
//             ),
//           ),
//         DeleteAccountButton(),
//         ConfirmButton(
//           title: 'تعديل كلمة المرور',
//           color: kPrimaryColor,
//           onPressed: () =>
//               RouteManager.navigateTo(EditPasswordView()),
//         ),
//       ],
//     );
//   }
// }
