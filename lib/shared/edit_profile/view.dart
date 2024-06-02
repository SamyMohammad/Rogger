// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:silah/constants.dart';
// import 'package:silah/core/app_storage/app_storage.dart';
// import 'package:silah/core/validator/validation.dart';
// import 'package:silah/shared/edit_profile/cubit/cubit.dart';
// import 'package:silah/shared/edit_profile/cubit/states.dart';
// import 'package:silah/shared/verify/view.dart';
// import 'package:silah/widgets/app_bar.dart';
// import 'package:silah/widgets/confirm_button.dart';
// import 'package:silah/widgets/loading_indicator.dart';
// import 'package:silah/widgets/text_form_field.dart';
//
// import '../../core/cities/cubit/cubit.dart';
// import '../../core/cities/cubit/states.dart';
// import '../../core/cities/model.dart';
// import '../../core/router/router.dart';
// import '../../store/edit_brief/view.dart';
// import '../../widgets/app/delete_account_button.dart';
// import '../../widgets/drop_menu.dart';
// import '../edit_password/view.dart';
//
// part 'units/phone_field.dart';
// part 'units/profile_avatar.dart';
// part 'units/footer_actions.dart';
// part 'units/drop_menus.dart';
// part 'units/fields.dart';
//
// class EditProfileView extends StatelessWidget {
//   const EditProfileView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(title: 'الاعدادات', elevation: 5.0),
//       body: BlocProvider(
//         create: (context) => EditProfileCubit()..getMapCategories(),
//         child: Builder(
//           builder: (context) {
//             final cubit = EditProfileCubit.of(context);
//             return Form(
//               key: cubit.formKey,
//               child: SingleChildScrollView(
//                 padding: VIEW_PADDING,
//                 child: Column(
//                   children: [
//                     _ProfileAvatar(),
//                     _Fields(),
//                     _DropMenus(),
//                     _FooterActions(),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
