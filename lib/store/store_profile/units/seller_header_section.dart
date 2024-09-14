import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/store/store_profile/cubit/cubit.dart';
import 'package:silah/store/store_profile/store_info_model.dart';
import 'package:silah/store/store_profile/units/header_action_button.dart';
import 'package:silah/store/store_profile/units/header_icons.dart';
import 'package:silah/store/store_profile/units/rate_dialog.dart';
import 'package:silah/widgets/app/profile_avatar.dart';

import '../../../core/router/router.dart';
import '../../../shared/login/view.dart';

class SellerHeaderSection extends StatelessWidget {
  const SellerHeaderSection({
    super.key,
    required this.storeInfo,
    required this.cubit,
    required this.storeId,
  });

  final StoreInfoModel? storeInfo;
  final StoreProfileCubit cubit;
  final String storeId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.network(
          storeInfo!.profileCover!,
          height: sizeFromHeight(3.5),
          width: double.infinity,
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) => Container(
            color: kGreyColor,
            height: sizeFromHeight(3.5),
          ),
        ),
        HeaderIcons(cubit: cubit),
        // Positioned(top: 0, right: 0, left: 0, child: HeaderIcons(cubit: cubit)),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),  
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ProfileAvatar(
              userID: storeId,
              image: storeInfo!.profileImage!,
              width: 70,
              height: 70,
            ),
          ),
        ),
        // if (AppStorage.customerID.toString() != storeId)
        Positioned(
          bottom: 12,
          right: 32,
          child: HeaderActionButton(
              isActive: cubit.isFollowing,
              activeLabel: "إلغاء المتابعة",
              inActiveLabel: "متابعة",
              onTap: () {
                if (!AppStorage.isLogged) {
                  showDialogToLogin(context, 'المتابعة');
                } else {
                  switch (AppStorage.isStore) {
                    case true:
                      if (AppStorage.customerID.toString() == storeId) {
                        return null;
                      } else {
                        showLoginACustomerDialog(context, 'المتابعة');
                      }
                      break;
                    case false:
                      // If the user is not a store, but the customerID does not match storeId, call followStore
                      cubit.followStore();

                      break;
                  }
                }
                // if (!AppStorage.isLogged) {
                //   showDialogToLogin(context, 'المتابعة');
                // } else if (AppStorage.isStore &&
                //     AppStorage.customerID.toString() == storeId) {
                //   return null;
                // } else if (AppStorage.isStore) {
                //   showLoginACustomerDialog(context, 'المتابعة');
                // } else if (!AppStorage.isStore &&
                //     AppStorage.customerID.toString() != storeId) {
                //   cubit.followStore();
                // }
              }),
        ),
        // if (AppStorage.isLogged)
        Positioned(
          bottom: 12,
          left: 32,
          child:
              // AppStorage.customerID.toString() != storeId && AppStorage.isStore
              //     ? const SizedBox(width: 86)
              //     :
              HeaderActionButton(
            isActive: false,
            activeLabel: "تقييم",
            inActiveLabel: "تقييم",
            onTap: () {
              if (!AppStorage.isLogged) {
                showDialogToLogin(context, 'التقييم');
              } else {
                if (AppStorage.isStore) {
                  if (AppStorage.customerID.toString() == storeId) {
                    return null;
                  } else {
                    showLoginACustomerDialog(context, 'التقييم');
                  }
                } else {
                  print('cubit.getRateModel?.rating ${cubit.getRateModel}');
                  showRateDialog(
                      storeId: storeId,
                      storeName: storeInfo?.name ?? '',
                      rate: cubit.getRateModel?.rating != null
                          ? double.parse(cubit.getRateModel!.rating!.rating!)
                          : null,rateId: cubit.getRateModel?.rating?.ratingId);
                }
              }
              // if (AppStorage.isStore) {
              //   showLoginACustomerDialog(context, 'التقييم');
              // } else if (AppStorage.isLogged && !AppStorage.isStore) {
              //   showRateDialog(storeId, storeInfo?.name ?? '');
              // } else if (!AppStorage.isLogged) {
              //   showDialogToLogin(context, 'التقييم');
              // }
            },
          ),
        ),
      ],
    );
  }

  void showLoginACustomerDialog(BuildContext context, String title) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('يمكن لزبون $title'),

        actions: [
          CupertinoButton(
            child: Text(
              'موافق',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: RouteManager.pop,
          ),
          // CupertinoButton(
          //   child: Text(
          //     'نعم',
          //     style: TextStyle(color: Colors.green),
          //   ),
          //   onPressed: () async {
          //     RouteManager.pop();
          //     await DioHelper.post('provider/banks/delete_all_commission',
          //         data: {
          //           'provider_id': AppStorage.customerID,
          //         });
          //     // getCommissions();
          //   },
          // ),
        ],
        // color: Colors.white,
        // child: Column(
        //   children: [
        //     Text('يمكن لزبون المتابعة'),
        //     // Row(
        //     //   children: [
        //     //
        //     //   ],
        //     // )
        //   ],
        // ),
      ),
    );
  }

  // Function()? isFollow(BuildContext context) {
  //   // if (AppStorage.isLogged) {
  //   //   if (AppStorage.customerID.toString() != storeId) {
  //   //     if (AppStorage.isStore) {
  //   //       return (){
  //   //         showLoginACustomerDialog(context, 'المتابعة');
  //   //       };
  //   //     } else if (AppStorage.customerID.toString() != storeId) {
  //   //       cubit.followStore();
  //   //     }
  //   //   } else {
  //   //     return null;
  //   //   }
  //   // } else {
  //   //   showDialogToLogin(context, 'المتابعة');
  //   // }
  //   AppStorage.customerID.toString() != storeId||AppStorage.isLogged
  //       ? () {
  //     if (!AppStorage.isLogged) {
  //       showDialogToLogin(context, 'المتابعة');
  //     } else if (AppStorage.isStore) {
  //       showLoginACustomerDialog(context, 'المتابعة');
  //     } else if (AppStorage.customerID.toString() != storeId) {
  //       cubit.followStore();
  //     } else if (AppStorage.customerID.toString() == storeId) {}
  //   }
  //       : null
  // }

  void showDialogToLogin(BuildContext context, String title) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('الرجاء التسجيل ليتم $title'),
        actions: [
          CupertinoButton(
            child: Text(
              'الغاء',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: RouteManager.pop,
          ),
          CupertinoButton(
            child: Text(
              'تسجيل',
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () async {
              RouteManager.pop();
              RouteManager.navigateTo(LoginView());
              // getCommissions();
            },
          ),
        ],
        // color: Colors.white,
        // child: Column(
        //   children: [
        //     Text('يمكن لزبون المتابعة'),
        //     // Row(
        //     //   children: [
        //     //
        //     //   ],
        //     // )
        //   ],
        // ),
      ),
    );
  }
}
