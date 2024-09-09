import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/edit_password/view.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/store/edit_brief/view.dart';
import 'package:silah/widgets/confirm_button.dart';

import '../../core/app_storage/app_storage.dart';
import '../../core/validator/validation.dart';
import '../../widgets/drop_menu.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/text_form_field.dart';
import '../verify/view.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

part 'units/phone_field.dart';
part 'units/profile_avatar.dart';
part 'views/edit_email.dart';
part 'views/edit_phone.dart';
part 'views/edit_profile.dart';

class ProfileSettingView extends StatelessWidget {
  ProfileSettingView({Key? key}) : super(key: key);

  final cubit = EditProfileCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit..getMapCategories(),
      child: Scaffold(
        appBar: AppBar(title: Text("الاعدادات")),
        body: ListView(
          children: [
            _ProfileAvatar(),
            _vSizedBox,
            ProfileSettingButton(
              title: "الملف الشخصي",
              onPressed: () => RouteManager.navigateTo(
                _EditProfileView(cubit: cubit),
              ),
            ),
            _vSizedBox,
            ProfileSettingButton(
              title: "البريد الالكتروني",
              onPressed: () => RouteManager.navigateTo(
                _EditEmailView(cubit: cubit),
              ),
            ),
            _vSizedBox,
            ProfileSettingButton(
              title: "رقم الجوال",
              onPressed: () => RouteManager.navigateTo(
                _EditPhoneView(cubit: cubit),
              ),
            ),
            _vSizedBox,
            ProfileSettingButton(
              title: "كلمة المرور",
              onPressed: () => RouteManager.navigateTo(
                EditPasswordView(),
              ),
            ),
            if (AppStorage.isStore) _vSizedBox,
            if (AppStorage.isStore)
              ProfileSettingButton(
                title: "نبذة عن الحساب",
                onPressed: () => RouteManager.navigateTo(
                  EditBriefView(),
                ),
              ),
            _vSizedBox,
            ProfileSettingButton(
              title: "حذف الحساب",
              onPressed: () {},
            ),
            const SizedBox(height: 30)
            // DeleteAccountButton(),
          ],
        ),
      ),
    );
  }

  SizedBox get _vSizedBox => const SizedBox(height: 20);

  Widget _button({required String title, required Widget page}) {
    return ConfirmButton(
      title: title,
      horizontalMargin: 15,
      color: activeButtonColor,
      fontColor: kPrimaryColor,
      border: true,
      onPressed: () => RouteManager.navigateTo(page),
    );
  }
}

class ProfileSettingButton extends StatelessWidget {
  const ProfileSettingButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).appBarTheme.backgroundColor,
            boxShadow: !ThemeCubit.of(context).isDark
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
