import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/black_list/view.dart';
import 'package:silah/shared/contact_us/view.dart';
import 'package:silah/shared/login/view.dart';
import 'package:silah/shared/nav_bar/cubit/cubit.dart';
import 'package:silah/shared/policy/view.dart';
import 'package:silah/shared/setting/units/confirmatory_dialog.dart';
import 'package:silah/shared/sign_up/view.dart';
import 'package:silah/shared/splash/view.dart';
import 'package:silah/shared_cubit/home_products/cubit.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/shared_cubit/theme_cubit/states.dart';
import 'package:silah/store/add_product/view.dart';
import 'package:silah/store/calculate_commissions/view.dart';
import 'package:silah/store/generate_qr_code/view.dart';
import 'package:silah/store/store_profile/view.dart';
import 'package:silah/store/tickets/view.dart';
import 'package:silah/user/favourite/view.dart';
import 'package:silah/user/followers/view.dart';
import 'package:silah/user/scan_qr_code/view.dart';
import 'package:silah/widgets/app/list__tile.dart';

import '../../store/add_status/view.dart';
import '../../widgets/app/profile_avatar.dart';
import '../profile_setting/view.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  void initState() {
    changeTheme();

    if (AppStorage.isLogged)
      getUserAndCache(
        AppStorage.customerID,
        AppStorage.getUserModel()!.customerGroup!,
      ).then((_) => setState(() {}));
    super.initState();
  }

  changeTheme() {
    ThemeCubit.of(context).isDark = ThemeCubit.of(context).isDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    if (!AppStorage.isLogged) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            ListTileWidget(
              title: 'تسجيل الدخول',
              trailing: SvgPicture.asset(
                getIcon(
                  "left-arrow",
                ),
                color: Theme.of(context).primaryColor,
              ),
              leading: SvgPicture.asset(getIcon("login")),
              onPressed: () => RouteManager.navigateAndPopAll(LoginView()),
            ),
            ListTileWidget(
              title: 'انشاء حساب',
              trailing: SvgPicture.asset(
                getIcon(
                  "left-arrow",
                ),
                color: Theme.of(context).primaryColor,
              ),
              leading: SvgPicture.asset(getIcon("register")),
              onPressed: () => RouteManager.navigateAndPopAll(SignUpView()),
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: VIEW_PADDING,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (AppStorage.isStore)
                InkWell(
                  onTap: () {
                    RouteManager.navigateTo(AddStatusView());
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: kAccentColor.withOpacity(0.2),
                            spreadRadius: .5,
                            blurRadius: 1,
                            offset: Offset(0, .5),
                          ),
                        ]),
                    child: Center(
                      child: SvgPicture.asset("assets/icons/camera.svg",
                          color: Theme.of(context).primaryColor, height: 12),
                    ),
                  ),
                ),
              ProfileAvatar(
                image: AppStorage.getUserModel()!.profileImage!,
                userID: AppStorage.customerID.toString(),
                height: 70,
                width: 70,
                onTap: () => RouteManager.navigateTo(ProfileSettingView()),
              ),
              if (AppStorage.isStore)
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: Color(0xff022E47),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        builder: (context) => GenerateQRCodeView(
                              id: AppStorage.customerID.toString(),
                            ));
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: kAccentColor.withOpacity(0.2),
                            spreadRadius: .5,
                            blurRadius: 1,
                            offset: Offset(0, .5),
                          ),
                        ]),
                    child: Center(
                      child: SvgPicture.asset("assets/icons/qrcode.svg",
                          color: Theme.of(context).primaryColor, height: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 10),
        // (AppStorage.getUserModel()!.customerGroup == 2) ? Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text('4.5',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: kAccentColor),textAlign: TextAlign.center,),
        //     SizedBox(width: 8),
        //     Icon(FontAwesomeIcons.solidStar,size: 12,color: Color(0xFFEBA328),),
        //   ],
        // ) : SizedBox(),
        SettingButton(
          title: 'ليلي/نهاري',
          icon: "dark light",
          onPressed: () {},
          onChangeTheme: changeTheme,
          isTheme: true,
        ),
        if (AppStorage.isStore)
          SettingButton(
              title: 'الموقع',
              icon: "icon3",
              onPressed: () => context.read<NavBarCubit>().toggleTab(1)
              //RouteManager.navigateTo(SelectLocationView()),
              ),
        SettingButton(
            title: 'شروط وسياسة الاستخدام',
            icon: "shorot",
            onPressed: () {
              RouteManager.navigateTo(PolicyView());
            }),
        if ((AppStorage.getUserModel()!.customerGroup == 2))
          SettingButton(
              title: 'حسابات العمولة',
              icon: "7sabat",
              // width: 35,
              // height: 35,
              onPressed: () =>
                  RouteManager.navigateTo(SCalculateCommissionsView())),
        SettingButton(
            title: 'محظورة',
            icon: "ban",
            onPressed: () {
              RouteManager.navigateTo(BlackListView());
            }),
        if (AppStorage.isStore)
          SettingButton(
              title: "تذاكر الاشتراك",
              icon: "icon4",
              onPressed: () {
                RouteManager.navigateTo(TicketsView());
                // RouteManager.navigateTo(SelectLocationView());
              }),

        // if (AppStorage.isStore)
        //   ListTileWidget(
        //       title: 'حدد موقعك',
        //       icon: FontAwesomeIcons.mapPin,
        //       onPressed: (){
        //         RouteManager.navigateTo(SelectLocationView());
        //       }
        //   ),
        if (!AppStorage.isStore)
          SettingButton(
              title: 'الماسح الضوئي ',
              icon: "qrcode",
              onPressed: () {
                RouteManager.navigateTo(ScanQRCodeView());
                // RouteManager.navigateTo(SelectLocationView());
              }),

        // ListTileWidget(
        //     title: 'انشء رمز',
        //     icon: FontAwesomeIcons.mapPin,
        //     onPressed: (){
        //       RouteManager.navigateTo(GenerateQRCodeView());
        //     }
        // ),
        // ListTileWidget(
        //     title: 'تحقق من رمز',
        //     icon: FontAwesomeIcons.mapPin,
        //     onPressed: (){
        //       RouteManager.navigateTo(ScanQRCodeView());
        //     }
        // ),

        // (AppStorage.getUserModel()!.customerGroup == 2)
        //     ? SettingButton(
        // isDark: isDark,
        //         title: 'حسابات العمولة',
        //         icon: "accounts",
        //         onPressed: () =>
        //             RouteManager.navigateTo(SCalculateCommissionsView()))
        //     : SizedBox(),
        // if (AppStorage.getUserModel()!.customerGroup == 2)

        if (AppStorage.getUserModel()!.customerGroup == 1)
          SettingButton(
              title: 'المفضلة',
              icon: "heart",
              onPressed: () {
                RouteManager.navigateTo(FavouriteView());
              }),
        (AppStorage.getUserModel()!.customerGroup == 1)
            ? SettingButton(
                title: 'المتابعة',
                icon: "follow_client",
                onPressed: () {
                  RouteManager.navigateTo(FollowersView());
                })
            : SizedBox(),
        (AppStorage.getUserModel()!.customerGroup == 2)
            ? SettingButton(
                title: 'اعلاناتي',
                icon: "icon2",
                onPressed: () {
                  RouteManager.navigateTo(StoreProfileView(
                    storeId: AppStorage.customerID.toString(),
                  ));
                })
            : SizedBox(),
        (AppStorage.getUserModel()!.customerGroup == 2 &&
                !HomeProductsCubit.of(context).isUserBanned)
            ? SettingButton(
                title: 'أضف اعلانك',
                icon: "icon1",
                onPressed: () {
                  RouteManager.navigateTo(SAddProductView());
                })
            : SizedBox(),
        SettingButton(
          title: 'تواصل معنا',
          icon: "headphone",
          onPressed: () => RouteManager.navigateTo(ContactUsView()),
        ),

        SettingButton(
            title: 'الاعدادات',
            icon: "settings",
            onPressed: () => RouteManager.navigateTo(ProfileSettingView())),
        SettingButton(
            title: 'تسجيل الخروج  ',
            icon: "logout",
            onPressed: () {
              showConfirmationDialog(
                  title: " خروج",
                  subTitle: "هل أنت متأكد أنك تريد تسجيل الخروج ؟",
                  context: context,
                  onSubmit: () {
                    NavBarCubit.get(context).toggleOnlineStatus(false);
                    RouteManager.navigateAndPopAll(SplashView());
                    AppStorage.clearCache();
                  });
            }),
      ],
    );
  }
}

class SettingButton extends StatefulWidget {
  SettingButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressed,
      this.isTheme = false,
      this.onChangeTheme,
      this.width,
      this.height
      // this.isDark
      });

  final String title;
  final String icon;
  final VoidCallback onPressed;
  final bool? isTheme;
  final VoidCallback? onChangeTheme;
  final double? width;
  final double? height;
  // bool? isDark;
  @override
  State<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeStates>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: widget.onPressed,
            child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ThemeCubit.of(context).isDark ?? false
                    ? Color(0xFF1E1E26)
                    : kBackgroundColor,
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
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: widget.width == null ? 30 : 20,
                        right: widget.width == null ? 5 : 0),
                    child: widget.icon.isNotEmpty
                        ? SvgPicture.asset(
                            width: 19,
                            height: 19,
                            fit: BoxFit.scaleDown,
                            'assets/icons/${widget.icon}.svg',
                            color: ThemeCubit.of(context).isDark ?? false
                                ? Colors.white
                                : null,
                          )
                        : SizedBox.shrink(),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeCubit.of(context).isDark ?? false
                          ? Colors.white
                          : kAccentColor,
                    ),
                  ),
                  Spacer(),
                  widget.isTheme == true
                      ? Switch.adaptive(
                          value: ThemeCubit.of(context).isDark ?? false,
                          onChanged: (value) {
                            setState(() {
                              ThemeCubit.of(context).isDark = value;
                            });
                            ThemeCubit.of(context).changeTheme(
                                ThemeCubit.of(context).isDark
                                    ? ThemeMode.dark
                                    : ThemeMode.light);
                            // ThemeCubit.of(context).getThemes();
                            widget.onChangeTheme!();

                            // SystemChrome.setSystemUIOverlayStyle(
                            //     SystemUiOverlayStyle(
                            //   statusBarColor: Colors.red, // Status bar color
                            //   statusBarIconBrightness:
                            //       Brightness.dark, // Light icons for status bar
                            // ));

                            // AppStorage.saveDarkMode(value);
                            // NavBarCubit.get(context).toggleTheme(value);
                          },
                          activeColor: activeSwitchColor,
                          inactiveThumbColor: kAccentColor,
                          inactiveTrackColor: kAccentColor.withOpacity(0.2),
                        )
                      : Icon(
                          Icons.arrow_forward_ios,
                          color: ThemeCubit.of(context).isDarkMode()
                              ? Colors.white
                              : kAccentColor,
                          size: 20,
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 10),
    //   child: InkWell(
    //     onTap: widget.onPressed,
    //     child: Container(
    //       height: 50,
    //       padding: EdgeInsets.all(5),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10),
    //         color: ThemeCubit.of(context).isDark ?? false
    //             ? Color(0xFF1E1E26)
    //             : kBackgroundColor,
    //         boxShadow: !ThemeCubit.of(context).isDark
    //             ? [
    //           BoxShadow(
    //             color: Colors.grey.withOpacity(0.3),
    //             blurRadius: 5,
    //             offset: const Offset(0, 2),
    //           ),
    //         ]
    //             : null,
    //       ),
    //       child: Row(
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.only(
    //                 left: widget.width == null ? 30 : 20,
    //                 right: widget.width == null ? 5 : 0),
    //             child: widget.icon.isNotEmpty
    //                 ? SvgPicture.asset(
    //               // width: widget.width ?? 20,
    //               // height: widget.height ?? 20,
    //               // fit: BoxFit.cover,
    //               'assets/icons/${widget.icon}.svg',
    //               color: ThemeCubit.of(context).isDark ?? false
    //                   ? Colors.white
    //                   : null,
    //             )
    //                 : SizedBox.shrink(),
    //           ),
    //           Text(
    //             widget.title,
    //             style: TextStyle(
    //               fontSize: 16,
    //               color: ThemeCubit.of(context).isDark ?? false
    //                   ? Colors.white
    //                   : kAccentColor,
    //             ),
    //           ),
    //           Spacer(),
    //           widget.isTheme == true
    //               ? Switch.adaptive(
    //             value: ThemeCubit.of(context).isDark ?? false,
    //             onChanged: (value) {
    //               setState(() {
    //                 ThemeCubit.of(context).isDark = value;
    //               });
    //               ThemeCubit.of(context).changeTheme(
    //                   ThemeCubit.of(context).isDark
    //                       ? ThemeMode.dark
    //                       : ThemeMode.light);
    //               // ThemeCubit.of(context).getThemes();
    //               widget.onChangeTheme!();
    //
    //               // SystemChrome.setSystemUIOverlayStyle(
    //               //     SystemUiOverlayStyle(
    //               //   statusBarColor: Colors.red, // Status bar color
    //               //   statusBarIconBrightness:
    //               //       Brightness.dark, // Light icons for status bar
    //               // ));
    //
    //               // AppStorage.saveDarkMode(value);
    //               // NavBarCubit.get(context).toggleTheme(value);
    //             },
    //             activeColor: activeSwitchColor,
    //             inactiveThumbColor: kAccentColor,
    //             inactiveTrackColor: kAccentColor.withOpacity(0.2),
    //           )
    //               : Icon(
    //             Icons.arrow_forward_ios,
    //             color: ThemeCubit.of(context).isDarkMode()
    //                 ? Colors.white
    //                 : kAccentColor,
    //             size: 20,
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
