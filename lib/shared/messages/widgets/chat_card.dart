import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/shared/messages/cubit.dart';
import 'package:silah/shared/messages/model.dart';
import 'package:silah/shared/nav_bar/cubit/cubit.dart';

import '../../../constants.dart';
import '../../../core/app_storage/app_storage.dart';
import '../../../core/router/router.dart';
import '../../../widgets/app/profile_avatar.dart';
import '../../chat/view.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({Key? key, required this.chat}) : super(key: key);

  final ChatList chat;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    final userID = "${AppStorage.customerID}" == widget.chat.advertizerId
        ? widget.chat.customerId!
        : widget.chat.advertizerId!;
    bool isMe = widget.chat.customerId == AppStorage.customerID.toString();
    return InkWell(
      onTap: () async {
        widget.chat.unreadMessages = false;
        setState(() {});
        await RouteManager.navigateTo(ChatView(
          profileImage: widget.chat.userProfile!,
          chatID: widget.chat.chatId!,
          username: widget.chat.userName!,
          productID: null,
          userID: userID,
          messagesCubit: MessagesCubit.of(context),
        ));
        NavBarCubit.get(context).checkIfHasUnreadMessages();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileAvatar(
              image: widget.chat.userProfile ?? PLACE_HOLDER_IMAGE,
              userID: userID,
              height: 55,
              width: 55,
              onlineDotRadius: 5,
            ),
            // Image.network(, width: 50,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.userName!,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  if (widget.chat.unreadMessages!)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.red,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'غير مقروءه',
                          style: TextStyle(color: kDarkGreyColor, fontSize: 12),
                        ),
                      ],
                    )
                ],
              ),
            ),
            Spacer(),
            if (!widget.chat.unreadMessagesParty!)
              Icon(
                FontAwesomeIcons.checkDouble,
                size: 12,
                color: isMe ? Color(0xFF9cd192) : Color(0xFF395C82),
              ),
            if (widget.chat.dateTime != null)
              Text(
                customizeDateTimeFromNow(widget.chat.dateTime!),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA0A0A0),
                  fontSize: 14,
                ),
              )
          ],
        ),
      ),
    );
  }
}
