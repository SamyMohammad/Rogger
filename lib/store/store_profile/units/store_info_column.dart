import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/chat/cubit.dart';
import 'package:silah/shared/chat/view.dart';
import 'package:silah/store/add_status/view.dart';
import 'package:silah/store/generate_qr_code/view.dart';
import 'package:silah/store/store_profile/store_info_model.dart';
import 'package:silah/widgets/rate_widget.dart';

class StoreInfoColumn extends StatelessWidget {
  const StoreInfoColumn(
      {super.key, required this.storeInfo, required this.storeId, this.rate});

  final StoreInfoModel? storeInfo;
  final String storeId;
  final double? rate;
  @override
  Widget build(BuildContext context) {
    return storeInfo == null
        ? SizedBox()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(storeInfo!.name ?? '',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  
                  //  if(storeInfo!.)
                  Image.asset(
                    getAsset("verified"),
                    height: 20,
                  )
                ],
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  copyText(storeInfo?.nickname ?? "");
                },
                child: Text(
                  (storeInfo?.nickname ?? '') + '@',
                  style: TextStyle(fontSize: 14, color: kDarkGreyColor),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (AppStorage.isLogged && !AppStorage.isStore)
                      ? Container(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: InkWell(
                            onTap: () async {
                              final chatID = await ChatCubit.getChatID(storeId);
                              RouteManager.navigateTo(
                                ChatView(
                                  profileImage: storeInfo!.profileImage!,
                                  chatID: chatID,
                                  username: storeInfo?.name ?? '',
                                  productID: null,
                                  userID: storeId,
                                  messagesCubit: null,
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, .5),
                                          spreadRadius: .5,
                                          blurRadius: 1,
                                          color: kLightGreyColorB4)
                                    ],
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: SvgPicture.asset(
                                    getIcon("Vector"),
                                    fit: BoxFit.scaleDown,
                                                                color: Theme.of(context).primaryColor,

                                    height: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : storeId == AppStorage.customerID.toString()
                          ? InkWell(
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 6),
                                height: 25,
                                width: 25,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, .5),
                                            spreadRadius: .5,
                                            blurRadius: 1,
                                            color: kLightGreyColorB4)
                                      ],
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      getIcon("Vector-1"),
                                      fit: BoxFit.scaleDown,
                                                                  color: Theme.of(context).primaryColor,

                                      height: 9,
                                    ),
                                  ),
                                ),
                              ),

                              // CircleAvatar(
                              //   radius: 16,
                              //   backgroundColor: kGreyColor,
                              //   child: Icon(
                              //     FontAwesomeIcons.camera,
                              //     size: 12,
                              //     color: kDarkGreyColor,
                              //   ),
                              // ),
                              onTap: () {
                                RouteManager.navigateTo(AddStatusView());
                              },
                            )
                          : const SizedBox(width: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // storeInfo?.totalRating == null
                        //     ? ''
                        //     : '${storeInfo!.totalRating}.0',
                        rate != null ? rate.toString() : '0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      RateWidget(
                        rate: rate ?? 0,
                        ignoreGestures: true,
                        itemSize: 15,
                        hItemPadding: 0,
                        // onRate: (rate) {},
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: Color(0xff022E47),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        builder: (context) => GenerateQRCodeView(id: storeId ,)),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 6),
                      height: 25,
                      width: 25,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Theme.of(context).appBarTheme.backgroundColor,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, .5),
                                  spreadRadius: .5,
                                  blurRadius: 1,
                                  color: kLightGreyColorB4)
                            ],
                            shape: BoxShape.circle),
                        child: Center(
                          child: SvgPicture.asset(
                            getIcon("Group 30"),
                            fit: BoxFit.scaleDown,
                            color: Theme.of(context).primaryColor,
                            height: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    getIcon("location_grey"),
                    height: 12,
                  ),
                  SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      storeInfo?.address?.replaceAll('\n', ' ') ?? '',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              SvgPicture.asset(getIcon("ministry"), fit: BoxFit.scaleDown)
            ],
          );
  }
}
