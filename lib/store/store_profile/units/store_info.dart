import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/chat/cubit.dart';
import 'package:silah/shared/chat/view.dart';
import 'package:silah/store/generate_qr_code/view.dart';

import '../../../constants.dart';
import '../../../widgets/app/profile_avatar.dart';
import '../../add_status/view.dart';
import '../cubit/cubit.dart';

class StoreInfo extends StatelessWidget {
  const StoreInfo(
      {Key? key, this.advName, this.advNickname, this.advId, this.image})
      : super(key: key);
  final String? advName;
  final String? advNickname;
  final String? advId;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        (AppStorage.isStore &&
                (AppStorage.customerID.toString() == advId || advId == null))
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppStorage.isLogged
                        ? InkWell(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: kGreyColor,
                              child: Icon(
                                FontAwesomeIcons.camera,
                                size: 14,
                                color: kPrimaryColor,
                              ),
                            ),
                            onTap: () async {
                              final forceRefresh =
                                  await RouteManager.navigateTo(
                                          AddStatusView()) ??
                                      false;
                              if (forceRefresh) {
                                StoreProfileCubit.of(context).init();
                              }
                            },
                          )
                        : SizedBox(),
                    (image != null)
                        ? ProfileAvatar(
                            userID: advId!,
                            image: image!,
                            width: 120,
                            height: 120)
                        : SizedBox(),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: Color(0xff0022E47),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => GenerateQRCodeView(
                                  id: advId,
                                ));
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: kGreyColor,
                        child: Icon(
                          FontAwesomeIcons.qrcode,
                          size: 14,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (AppStorage.isLogged && !AppStorage.isStore)
                        ? InkWell(
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: kGreyColor,
                              child: Icon(
                                FontAwesomeIcons.solidEnvelope,
                                size: 12,
                                color: kDarkGreyColor,
                              ),
                            ),
                            onTap: () async {
                              final chatID = await ChatCubit.getChatID(advId!);
                              RouteManager.navigateTo(
                                ChatView(
                                  profileImage: image!,
                                  chatID: chatID,
                                  username: advName ?? '',
                                  productID: null,
                                  userID: advId ?? '',
                                  messagesCubit: null,
                                ),
                              );
                            },
                          )
                        : SizedBox(width: 40),
                    ProfileAvatar(
                      image: advId == AppStorage.customerID.toString()
                          ? AppStorage.getUserModel()!.profileImage.toString()
                          : image ?? PLACE_HOLDER_IMAGE,
                      userID: advId!,
                      height: 110,
                      width: 110,
                      onTap: null,
                    ),
                    GestureDetector(
                      onTap: () => RouteManager.navigateTo(
                          GenerateQRCodeView(id: advId)),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: kGreyColor,
                        child: Icon(
                          FontAwesomeIcons.qrcode,
                          size: 12,
                          color: kDarkGreyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // AppStorage.getUserModel()!.nickname ?? AppStorage.getUserModel()!.name ??
              (advId == AppStorage.customerID.toString())
                  ? AppStorage.getUserModel()!.nickname.toString()
                  : advNickname ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            Text(
              '@',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: kPrimaryColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
