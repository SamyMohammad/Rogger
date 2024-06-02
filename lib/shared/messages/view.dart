import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/shared/messages/cubit.dart';
import 'package:silah/shared/messages/states.dart';
import 'package:silah/shared/messages/widgets/chat_card.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../widgets/login_to_continue_widget.dart';
import '../../widgets/refresh_indicator.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!AppStorage.isLogged) {
      return LoginToContinueWidget();
    }
    return BlocProvider(
      create: (context) => MessagesCubit()..init(),
      child: Scaffold(
        body: BlocBuilder<MessagesCubit, MessagesStates>(
            builder: (context, state) {
          final cubit = MessagesCubit.of(context);
          final messages = cubit.messagesModel?.chatList;
          if (state is MessagesLoadingStates) {
            return LoadingIndicator();
          }
          if (messages == null || messages.isEmpty) {
            return Center(
              child: Text(
                'لا توجد رسائل!',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            );
          }
          return CustomRefreshIndicator(
            onRefresh: cubit.getMessages,
            child: ListView.separated(
              padding: VIEW_PADDING,
              itemBuilder: (context, index) {
                return ChatCard(
                  chat: messages[index],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 8,
                  color: kDarkGreyColor.withOpacity(0.5),
                  indent: 70,
                );
              },
              itemCount: messages.length,
            ),
          );
        }),
      ),
    );
  }
}
