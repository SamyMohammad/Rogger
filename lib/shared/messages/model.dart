// To parse this JSON data, do
//
//     final messagesModel = messagesModelFromJson(jsonString);

import 'dart:convert';

MessagesModel messagesModelFromJson(String str) =>
    MessagesModel.fromJson(json.decode(str));

String messagesModelToJson(MessagesModel data) => json.encode(data.toJson());

class MessagesModel {
  MessagesModel({
    this.chatList,
  });

  List<ChatList>? chatList;

  factory MessagesModel.fromJson(Map<String, dynamic> json) {
    return MessagesModel(
      chatList: List<ChatList>.from(
          json["chat_list"].map((x) => ChatList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "chat_list": List<dynamic>.from(chatList!.map((x) => x.toJson())),
      };
}

class ChatList {
  ChatList(
      {this.chatId,
      this.customerId,
      this.advertizerId,
      this.userName,
      this.userProfile,
      this.unreadMessages,
      this.dateTime,
      this.unreadMessagesParty});

  String? chatId;
  String? customerId;
  String? advertizerId;
  String? userName;
  String? userProfile;
  bool? unreadMessages;
  DateTime? dateTime;
  bool? unreadMessagesParty;

  factory ChatList.fromJson(Map<String, dynamic> json) => ChatList(
        chatId: json["chat_id"],
        customerId: json["customer_id"],
        advertizerId: json["advertizer_id"],
        userName: json["user_name"],
        userProfile: json["user_profile"],
        unreadMessages: json['unread_messages'],
        unreadMessagesParty: json['unread_messages_party'],
        dateTime: DateTime.tryParse(json['date_added'] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "customer_id": customerId,
        "advertizer_id": advertizerId,
        "user_name": userName,
        "user_profile": userProfile,
      };
}
