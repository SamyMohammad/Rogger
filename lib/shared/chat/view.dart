import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/chat/cubit.dart';
import 'package:silah/shared/chat/options_dialog.dart';
import 'package:silah/shared/chat/states.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/store/store_profile/view.dart';
import 'package:silah/widgets/app/profile_avatar.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../constants.dart';
import '../../widgets/app/message_bubble.dart';
import '../../widgets/app/online_status_tile.dart';
import '../black_list/cubit/cubit.dart';
import '../black_list/cubit/states.dart';
import '../messages/cubit.dart';

class ChatView extends StatelessWidget {
  const ChatView(
      {Key? key,
      required this.chatID,
      required this.username,
      required this.productID,
      this.productImage,
      required this.userID,
      required this.messagesCubit,
      required this.profileImage})
      : super(key: key);

  final String profileImage;
  final String? productImage;
  final String chatID;
  final String? productID;
  final String userID;
  final String username;
  final MessagesCubit? messagesCubit;

  @override
  Widget build(BuildContext context) {
    bool isVisible = productImage != null;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatCubit(
            chatID: chatID,
            productID: productID,
            userID: userID,
            username: username,
            messagesCubit: messagesCubit,
          )..init(),
        ),
        BlocProvider(
          create: (context) => BlackListCubit()..getBlackedList(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          // backgroundColor:
          //     ThemeCubit.of(context).isDarkMode() ? Color() : Colors.white,

          title: Row(
            children: [
              ProfileAvatar(
                userID: userID,
                image: profileImage,
                width: 35,
                height: 35,
                onlineDotRadius: 0,
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: AppStorage.isStore
                    ? null
                    : () => RouteManager.navigateTo(
                        StoreProfileView(storeId: userID)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeCubit.of(context).isDarkMode()
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    OnlineStatusTile(userID: userID, chatID: chatID),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Builder(builder: (context) {
              final cubit = ChatCubit.of(context);
              final blackListCubit = BlackListCubit.of(context);
              blackListCubit.getBlackedList();
              print(
                  'blackListCubit.getBlackedList${blackListCubit.getBlackedList()}');
              return IconButton(
                onPressed: () => showChatOptionsDialog(
                    cubit: cubit,
                    isBlocked: blackListCubit.isUserBlocked(cubit.userID)),
                icon: Icon(FontAwesomeIcons.ellipsisVertical),
              );
            })
          ],
          // elevation: 0,
        ),
        //     appBar(
        //   title: username,
        //   centerTitle: false,
        //   titleWidgets: [
        //     ProfileAvatar(
        //       userID: userID,
        //       image: profileImage,
        //       width: 35,
        //       height: 35,
        //       onlineDotRadius: 0,
        //     ),
        //   ],
        //   subtitle: OnlineStatusTile(userID: userID, chatID: chatID),
        //   onTitleClicked: AppStorage.isStore
        //       ? null
        //       : () =>
        //           RouteManager.navigateTo(StoreProfileView(storeId: userID)),
        //   actions: [
        //     Builder(builder: (context) {
        //       final cubit = ChatCubit.of(context);
        //       return IconButton(
        //         onPressed: () => showChatOptionsDialog(cubit: cubit),
        //         icon: Icon(FontAwesomeIcons.ellipsisVertical),
        //       );
        //     })
        //   ],
        // ),
        body: BlocBuilder<BlackListCubit, BlackListStates>(
          builder: (context, state) {
            return BlocBuilder<ChatCubit, ChatStates>(
              builder: (context, state) {
                final cubit = ChatCubit.of(context);
                final messages = cubit.chatModel?.chatDetails;
                var blackListCubit = BlackListCubit.of(context);

                print(
                    'BlackListCubittt ${blackListCubit.isUserBlocked(cubit.userID)}');
                // print('${ blackListCubit.}');
                print('${blackListCubit.blackListModel?.bannedList}');
                print('cubit.chatModel?.isBlocked __${cubit.isBlocked}');
                return state is ChatLoadingStates
                    ? LoadingIndicator()
                    : Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: messages?.length ?? 0,
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    final message = messages![index];
                                    bool isMe = message.fromId ==
                                        AppStorage.customerID.toString();
                                    bool isLocation =
                                        message.text?.contains('location#') ==
                                            true;
                                    LatLng? location;
                                    if (isLocation) {
                                      String m = '${message.text}';
                                      m = m.replaceAll('location#', '');
                                      final lat = double.parse(
                                          m.substring(0, m.indexOf(',')));
                                      final lng = double.parse(m.substring(
                                          m.indexOf(',') + 1, m.length));
                                      location = LatLng(lat, lng);
                                      return LocationBubble(
                                          location: location,
                                          isMe: isMe,
                                          date: message.time! +
                                              '\n' +
                                              message.date!);
                                    }
                                    return MessageBubble(
                                      productInfo: message.productInfo,
                                      senderName: message.fromId ==
                                              AppStorage.customerID.toString()
                                          ? ''
                                          : username,
                                      message: message.text,
                                      attachment: message.attachment,
                                      isMe: isMe,
                                      date: message.time!,
                                      isRead: message.isRead,
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 6, left: 16, right: 25, bottom: 6),
                                color:ThemeCubit.of(context).isDark? Theme.of(context).appBarTheme.backgroundColor:kGreyColor,
                                child: cubit.isBlocked ?? false
                                    ? buildBlockBanner(blackListCubit, cubit)
                                    : Column(
                                        children: [
                                          // Container(
                                          //   width: double.infinity,
                                          //   height: 30,
                                          //   child: Image.asset(productID),
                                          // ),
                                          StatefulBuilder(
                                              builder: (context, setState) {
                                            return Column(
                                              children: [
                                                Visibility(
                                                  visible: isVisible,
                                                  child: Image.network(
                                                    productImage ?? '',
                                                    fit: BoxFit.fill,
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Spacer(),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                isVisible =
                                                                    false;
                                                              });
                                                              cubit
                                                                  .sendMessage();
                                                            },
                                                            child: CircleAvatar(
                                                              maxRadius: 14,
                                                              backgroundColor: cubit
                                                                      .textEditingController
                                                                      .text
                                                                      .isEmpty
                                                                  ? kDarkGreyColor
                                                                  : kPrimaryColor,
                                                              child: Center(
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  getIcon(
                                                                      "large_back_arrow")
                                                                      ,
                                                                  height: 18,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      child: ChatTextField(
                                                          cubit: cubit),
                                                      //     TextFormField(
                                                      //   style: TextStyle(fontSize: 10, height: 1),
                                                      //   decoration: InputDecoration(
                                                      //       fillColor: kBackgroundColor,
                                                      //       filled: true,
                                                      //       contentPadding: EdgeInsets.all(8),
                                                      //       prefixIcon: Container(
                                                      //         width: 20,
                                                      //         height: 20,
                                                      //         decoration: BoxDecoration(
                                                      //             color: kGreyButtonColorD9),
                                                      //         child: Center(
                                                      //           child: SvgPicture.asset(
                                                      //             getIcon("large_back_arrow"),
                                                      //             height: 10,
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //       border: OutlineInputBorder(
                                                      //           borderSide:
                                                      //               BorderSide(color: Colors.grey)),
                                                      //       isDense: true),
                                                      // )
                                                      //     InputFormField(
                                                      //   radius: 10,
                                                      //   isDense: true,
                                                      //   controller: cubit.textEditingController,
                                                      //   onChanged: (_) => cubit.validateInput(),
                                                      //   multiLine: true,
                                                      //   minLines: 1,
                                                      //   maxLines: 4,
                                                      //   fontSize: 10,
                                                      //   fillColor: Colors.white,
                                                      //   iconWidget: IconButton(
                                                      //       onPressed: cubit.sendMessage,
                                                      //       icon: CircleAvatar(
                                                      //         backgroundColor: cubit
                                                      //                 .textEditingController
                                                      //                 .text
                                                      //                 .isEmpty
                                                      //             ? kGreyButtonColorD9
                                                      //             : kPrimaryColor,
                                                      //         radius: 30,
                                                      //         child: SvgPicture.asset(
                                                      //           getIcon("large_back_arrow"),
                                                      //         ),
                                                      //       )),
                                                      // ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    InkWell(
                                                      onTap: () {
                                                        cubit.sendImage();
                                                      },
                                                      child: SvgPicture.asset(
                                                          getIcon("image"),
                                                          color: Theme.of(context).primaryColor,
                                                          height: 26),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                          // if (cubit.chatModel?.productInfo != null)
                          // InkWell(
                          //   onTap: () => RouteManager.navigateTo(ProductDetailsView(productId: cubit.chatModel!.productInfo!.productId!)),
                          //   child: Container(
                          //     height: 80,
                          //     width: sizeFromWidth(1),
                          //     child: Row(
                          //       children: [
                          //         Image.network(
                          //           cubit.chatModel!.productInfo!.image!,
                          //           width: 100,
                          //           height: 80,
                          //           fit: BoxFit.fill,
                          //         ),
                          //         SizedBox(width: 10),
                          //         Expanded(
                          //           child: Text(
                          //             cubit.chatModel!.productInfo!.name!,
                          //             maxLines: 3,
                          //             overflow: TextOverflow.ellipsis,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(
                          //         color: kGreyColor,
                          //       )
                          //     ),
                          //   ),
                          // ),
                        ],
                      );
              },
            );
          },
        ),
      ),
    );
  }

  Container buildBlockBanner(BlackListCubit blackListCubit, ChatCubit cubit) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      height: 30,
      child: Text(
        blackListCubit.isUserBlocked(cubit.userID)
            ? 'يمكنك إلغاء الحظر لمراسلة هذا المستخدم'
            : 'لا يمكنك الإرسال لهذا المستخدم',
        style: TextStyle(
            fontSize: 12,
            color: Color(0xffA9A7A7),
            fontWeight: FontWeight.w400,
            fontFamily: 'IBMPlexSansArabic'),
      ),
    );
  }
}

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    required this.cubit,
  });

  final ChatCubit cubit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: cubit.textEditingController,
      onChanged: (_) => cubit.validateInput(),
      style: TextStyle(fontSize: 10),
      minLines: 1,
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: 5,
      inputFormatters: [
        LengthLimitingTextInputFormatter(200),
      ],
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: kGreyColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: kGreyColor)),
        fillColor: Colors.white,
        filled: true,
        // icon: Container(
        //   height: 30,
        //   child: Column(
        //     mainAxisAlignment:
        //         MainAxisAlignment.end,
        //     children: [
        //       Spacer(),
        //       GestureDetector(
        //         onTap: cubit.sendMessage,
        //         child: CircleAvatar(
        //           maxRadius: 14,
        //           backgroundColor: cubit
        //                   .textEditingController
        //                   .text
        //                   .isEmpty
        //               ? kGreyButtonColorD9
        //               : kPrimaryColor,
        //           child: Center(
        //             child: SvgPicture.asset(
        //               getIcon("large_back_arrow"),
        //               height: 18,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        prefixIconConstraints: BoxConstraints.tight(Size(40, 30)),
        // prefixIcon: IconButton(
        //     onPressed: cubit.sendMessage,
        //     icon: CircleAvatar(
        //       backgroundColor: cubit
        //               .textEditingController
        //               .text
        //               .isEmpty
        //           ? kGreyButtonColorD9
        //           : kPrimaryColor,
        //       radius: 30,
        //       child: SvgPicture.asset(
        //         getIcon("large_back_arrow"),
        //       ),
        //     )),
        isDense: true, // Added this
        contentPadding: EdgeInsets.all(8), // Added this
      ),
    );
  }
}
