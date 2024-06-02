import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dynamic_links_constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/nav_bar/cubit/cubit.dart';
import 'package:silah/shared/nav_bar/cubit/states.dart';
import 'package:silah/shared/nav_bar/units/navigator_bottom.dart';
import 'package:silah/shared/notifications/view.dart';
import 'package:silah/shared/search/view.dart';
import 'package:silah/shared/stores/view.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/store/store_profile/view.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../constants.dart';
import '../../widgets/app_bar.dart';

class NavBarView extends StatefulWidget {
  final int initialIndex;

  const NavBarView({super.key, this.initialIndex = 0});

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
   StreamSubscription<Map>? streamSubscriptionDeepLink;

  void listenDeepLinkData(BuildContext context) async {
    streamSubscriptionDeepLink = FlutterBranchSdk.listSession().listen((data) {
      debugPrint('data: $data');
      if (data.containsKey(AppConstants.clickedBranchLink) &&
          data[AppConstants.clickedBranchLink] == true) {
        // Navigate to relative screen
        RouteManager.navigateTo(StoreProfileView(
          storeId: data[AppConstants.deepLinkTitle],
        ));
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      debugPrint('exception: $platformException');
    });
  }
  @override
  void initState() {
    super.initState();
    listenDeepLinkData(context);
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavBarCubit(currentIndex: widget.initialIndex)..init(),
      child: BlocBuilder<NavBarCubit, NavBarStates>(
        builder: (context, state) {
          final cubit = NavBarCubit.get(context);
          NavBarCubit.currentContext = context;
          return Scaffold(
            appBar: PreferredSize(
              child: Builder(
                builder: (context) {
                  if (cubit.currentIndex == 0) {
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: appBarTopSpacing,
                            right: 20,
                            left: 20,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  RouteManager.navigateTo(StoresView());
                                },
                                child: Image.asset(
                                  getAsset('store'),
                                  width: 20,
                                  height: 20,
                                  color: ThemeCubit.of(context).isDarkMode()
                                      ? Colors.white
                                      : kPrimaryColor,
                                ),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await RouteManager.navigateTo(
                                          NotificationsView());
                                      cubit.checkIfHasNotifications();
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.bell,
                                      color: ThemeCubit.of(context).isDarkMode()
                                          ? Colors.white
                                          : Colors.black,
                                      size: 18,
                                    ),
                                  ),
                                  if (cubit.hasNotifications)
                                    Positioned(
                                      top: 0,
                                      bottom: 15,
                                      left: 15,
                                      right: 0,
                                      child: UnconstrainedBox(
                                        child: CircleAvatar(
                                          radius: 4,
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      RouteManager.navigateTo(SearchView()),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      right: 14,
                                      top: 2,
                                      bottom: 2,
                                      left: 2,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'البحث',
                                          style: TextStyle(
                                            color: kGreyColor,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 16,
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.magnifyingGlass,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: kAccentColor,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          width: 2,
                                          color: ThemeCubit.of(context)
                                                  .isDarkMode()
                                              ? Colors.white
                                              : kAccentColor,
                                        )),
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   child: SearchTextField(),
                              // Container(
                              //   padding: EdgeInsets.only(
                              //     right: 14,
                              //     top: 2,
                              //     bottom: 2,
                              //     left: 2,
                              //   ),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(
                              //         'البحث',
                              //         style: TextStyle(
                              //           color: kGreyColor,
                              //         ),
                              //       ),
                              //       Container(
                              //         padding: EdgeInsets.symmetric(
                              //           vertical: 5,
                              //           horizontal: 16,
                              //         ),
                              //         child: Icon(
                              //           FontAwesomeIcons.magnifyingGlass,
                              //           color: Colors.white,
                              //           size: 16,
                              //         ),
                              //         decoration: BoxDecoration(
                              //           color: kAccentColor,
                              //           borderRadius:
                              //               BorderRadius.circular(50),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(50),
                              //       border: Border.all(
                              //         width: 2,
                              //         color: kAccentColor,
                              //       )),
                              // ),
                              // ),
                              SizedBox(width: 16),
                              InkWell(
                                onTap: () => cubit.toggleViewMode(),
                                child: Center(
                                  child: SvgPicture.asset(
                                    getIcon(cubit.isGrid ? 'list' : "grid"),
                                    color: ThemeCubit.of(context).isDarkMode()
                                        ? Colors.white
                                        : kPrimaryColor,
                                    width: cubit.isGrid ? 18 : 20,
                                    height: cubit.isGrid ? 18 : 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 1,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:ThemeCubit.of(context).isDark?kPrimary1Color: kGreyColor,
                                  blurRadius: 1.5,
                                  spreadRadius: 0.5,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return BlocBuilder<NavBarCubit, NavBarStates>(
                      builder: (context, state) {
                    return (AppStorage.getUserModel()?.customerGroup == 1 &&
                            cubit.currentIndex == 1)
                        ? SizedBox()
                        : AppBar(
                            title: Text(cubit.getCurrentTitle),
                            // elevation: 2,
                          );
                  });
                },
              ),
              preferredSize: Size.fromHeight(cubit.currentIndex == 0? 40 : 50),
            ),
            bottomNavigationBar: BottomNavBar(
              onTap: cubit.toggleTab,
            
              index: cubit.currentIndex,
            ),
            body: state is NavBarLoadingState
                ? LoadingIndicator()
                : cubit.getCurrentView,
          );
        },
      ),
    );
  }
}
