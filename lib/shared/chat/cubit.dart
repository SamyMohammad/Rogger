import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared/chat/model.dart';
import 'package:silah/shared/chat/states.dart';
import 'package:silah/widgets/snack_bar.dart';

import '../messages/cubit.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit({
    required this.chatID,
    required this.username,
    required this.productID,
    required this.userID,
    required this.messagesCubit,
  }) : super(ChatLoadingStates());

  final String chatID;
  String? productID;
  final String userID;
  final String username;
  final MessagesCubit? messagesCubit;

  static ChatCubit of(context) => BlocProvider.of(context);

  // final _firestore = FirebaseFirestore.instance;
  final _database = FirebaseDatabase.instance;

  late StreamSubscription _messagesStream;
  late StreamSubscription _messagesReadStream;

  late String _chatPath;

  ChatModel? chatModel;
  bool? isBlocked;
  List<ChatDetail> _unreadMessages = [];
  TextEditingController textEditingController = TextEditingController();

  bool _isMessagesStreamInitialized = false;
  void init() {
    _chatPath = 'chats';
    getChat().then((_) {
      _messagesStream = _database
          .ref('$_chatPath/${AppStorage.customerID}/$chatID')
          .onValue
          .listen((event) {
        if (!_isMessagesStreamInitialized) {
          _emitSeenMessages();
          _isMessagesStreamInitialized = true;
          return;
        }
        final json = event.snapshot.value as Map;
        Map<String, dynamic> body = {
          'date_added': json['date_added'],
          'from_id': json['from_id'],
          'to_id': json['to_id'],
          'text': json['text'],
          'time': json['time'],
          'status': json['status'],
        };
        if (!json.containsKey('date_added')) {
          return;
        }
        final message = ChatDetail.fromJson(body);
        chatModel?.chatDetails?.insert(0, message);
        _emitSeenMessages();
        emit(ChatInitStates());
        if (json['product_id'] != null) {
          getChat();
        }
      });
      _listenForReadingMessages();
    });
  }

  void _emitSeenMessages() {
    _database
        .ref('$_chatPath/${AppStorage.customerID}/$chatID')
        .set({'status': 1});
  }

  bool get isInputValid => textEditingController.text.trim().isNotEmpty;

  // bool _isTyping = false;

  void validateInput() {
    print('textEditingController.text${textEditingController.text}');
    emit(ChatInitStates());
  }

  Future<void> getChat() async {
    final response = await DioHelper.post('messages/chat_peer', data: {
      'chat_id': chatID,
      'user_id': AppStorage.customerID,
    });
    print('chatID$response');
    print('AppStorage.customerID${AppStorage.customerID}');
    chatModel = ChatModel();
    chatModel?.chatDetails = [];
    isBlocked = response.data["is_blocked"];
    print('chatIDisBlocked$isBlocked');

    for (var i = 0; i < response.data["chat_details"].length; i++) {
      final item = (response.data["chat_details"] as List).toList()[i];
      final chat = ChatDetail.fromJson(item);
      if (chat.productInfo != null) chatModel?.productInfo = chat.productInfo;
      chatModel?.chatDetails?.insert(0, chat);
    }
    _unreadMessages =
        chatModel?.chatDetails?.where((element) => !element.isRead).toList() ??
            [];
    if (!this.isClosed) emit(ChatInitStates());
  }

  Future<void> _listenForReadingMessages() async {
    bool initializing = true;
    _messagesReadStream = _database
        .ref('$_chatPath/$userID/$chatID/status')
        .onValue
        .listen((event) {
      if (initializing) {
        initializing = false;
        return;
      }
      if (event.snapshot.value != 1) {
        return;
      }
      _unreadMessages.forEach((element) {
        final index = chatModel!.chatDetails!.indexOf(element);
        chatModel!.chatDetails![index].isRead = true;
      });
      _unreadMessages.clear();
      emit(ChatInitStates());
    });
  }

  Future<void> sendMessage() async {
    if (textEditingController.text.isNotEmpty) {
      print('textEditingController.textinSend${textEditingController.text}');
      Map<String, dynamic> body = {
        'chat_id': chatID,
        'from_id': AppStorage.customerID,
        'to_id': userID,
        'text': textEditingController.text,
        'product_id': productID ?? '0',
      };
      _emitMessageToFirebase(body);
      textEditingController.clear();
      await DioHelper.post(
        'messages/chat_message',
        data: body,
      );
      if (productID != null) {
        getChat();
        productID = null;
      }
      messagesCubit?.getMessages(loading: false);
    }
  }

  Future<void> _emitMessageToFirebase(Map<String, dynamic> body) async {
    body['date_added'] = DateTime.now().millisecondsSinceEpoch;
    body['status'] = 0;
    body['typing'] = false;
    _database.ref('$_chatPath/$userID/$chatID').update(body);
    final message = ChatDetail.fromJson(body);
    chatModel?.chatDetails?.insert(0, message);
    _unreadMessages.insert(0, message);
    emit(ChatInitStates());
  }

  Future<void> sendImage() async {
    final path = await _pickImage();
    if (path != null) {
      final formData = FormData.fromMap({
        'chat_id': chatID,
        'from_id': AppStorage.customerID,
        'to_id': userID,
        // 'text': 'هل هذا المنتج متوفر بالفعل؟',
        'product_id': productID ?? '0'
      });
      formData.files
          .add(MapEntry('attachment', await MultipartFile.fromFile(path)));
      final response =
          await DioHelper.post('messages/chat_message', formData: formData);
      if (response.data.toString().contains('"success":true')) {
        getChat();
      }
    }
  }

  Future<void> sendLocation(LatLng latLng) async {
    await DioHelper.post(
      'messages/chat_message',
      data: {
        'chat_id': chatID,
        'from_id': AppStorage.customerID,
        'to_id': userID,
        'text': 'location#${latLng.latitude},${latLng.longitude}',
        'product_id': productID ?? '0'
      },
    );
    getChat();
  }

  Future<void> deleteChat() async {
    final response =
        await DioHelper.post('messages/chat_delete', data: {'chat_id': chatID});
    if (response.data['success']) {
      showSnackBar('تم حذف المحادثة !');
    } else {
      showSnackBar('حدث خطأ اثناء حذف المحادثة !', errorMessage: true);
    }
  }

  Future<String?> _pickImage() async {
    final permission = await Permission.photos.request();
    if (permission.isGranted) {
      final images = await ImagePicker().pickImage(source: ImageSource.gallery);
      return images == null ? null : images.path;
    }
    return null;
  }

  @override
  Future<void> close() {
    _messagesStream.cancel();
    _messagesReadStream.cancel();
    textEditingController.dispose();
    return super.close();
  }

  static Future<String> getChatID(String storeID) async {
    final response = await DioHelper.post('messages/chat',
        data: {'customer_id': AppStorage.customerID, 'advertizer_id': storeID});
    print('response.data[chat_id]${response.data['chat_id'].toString()}');
    return response.data['chat_id'].toString();
  }
}

/*
    if (_isTyping) {
      return;
    }
    _isTyping = true;
    final emitTyping = () {
      final ref = FirebaseDatabase.instance.ref('$_chatPath/$userID/$chatID');
      ref.update({'typing': _isTyping});
      ref.onDisconnect().update({'typing': false});
    };
    emitTyping();
    Timer(Duration(seconds: 3), () {
      _isTyping = false;
      emitTyping();
    });
 */
