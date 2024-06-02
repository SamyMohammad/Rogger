// part of '../view.dart';
//
// class _Fields extends StatelessWidget {
//   const _Fields({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final cubit = EditProfileCubit.of(context);
//     return Column(
//       children: [
//         InputFormField(
//           controller: cubit.nameController,
//           upperText: 'الاسم',
//           verticalMargin: 10,
//           fillColor: Colors.white,
//           suffixIcon: Icon(
//             FontAwesomeIcons.pen,
//             color: kGreyColor,
//             size: 16,
//           ),
//           validator: Validator.name,
//         ),
//         if (AppStorage.isStore)
//           InputFormField(
//             controller: cubit.nicknameController,
//             upperText: 'اسم المستخدم@',
//             fillColor: Colors.white,
//             suffixIcon: Icon(
//               FontAwesomeIcons.pen,
//               color: kGreyColor,
//               size: 16,
//             ),
//             validator: Validator.username,
//           ),
//         InputFormField(
//           controller: cubit.emailController,
//           upperText: 'البريد الالكتروني',
//           verticalMargin: 10,
//           fillColor: Colors.white,
//           suffixIcon: Icon(
//             FontAwesomeIcons.pen,
//             color: kGreyColor,
//             size: 16,
//           ),
//         ),
//         _PhoneField(),
//       ],
//     );
//   }
// }
