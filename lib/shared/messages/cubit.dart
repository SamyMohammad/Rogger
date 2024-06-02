import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared/messages/model.dart';
import 'package:silah/shared/messages/states.dart';

class MessagesCubit extends Cubit<MessagesStates> {
  MessagesCubit() : super(MessagesInitStates());

  static MessagesCubit of(context) => BlocProvider.of(context);

  MessagesModel? messagesModel;
  late StreamSubscription _messagesStream;
  final _database = FirebaseDatabase.instance;
  bool _isMessagesStreamInitialized = false;

  Future<void> init() async {
    getMessages();
    _messagesStream =
        _database.ref('chats/${AppStorage.customerID}').onValue.listen((event) {
      print('_isMessagesStreamInitialized');
      if (!_isMessagesStreamInitialized) {
        _isMessagesStreamInitialized = true;
        return;
      }
      getMessages(loading: false);
    });
  }

  Future<void> getMessages({bool loading = true}) async {
    if (loading) emit(MessagesLoadingStates());
    messagesModel = null;
    final response = await DioHelper.post('messages/chat_list', data: {
      'customer_id': AppStorage.customerID,
      'customer_group_id': AppStorage.getUserModel()?.customerGroup
    });
    messagesModel = MessagesModel.fromJson(response.data);
    emit(MessagesInitStates());
  }

  @override
  Future<void> close() async {
    _messagesStream.cancel();
    super.close();
  }
}

/*
      final chatID = (event.snapshot.value as Map?)?.keys.first;
      rearrangeChats(chatID);

void rearrangeChats(String chatID) {
    try {
      final chat = messagesModel?.chatList?.firstWhere((element) => element.chatId == chatID);
      if (chat != null) {
        messagesModel?.chatList?.remove(chat);
        messagesModel?.chatList?.insert(0, chat);
        emit(MessagesInitStates());
      }
    } catch (e) {

    }
  }

 */
