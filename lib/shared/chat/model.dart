// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'package:intl/intl.dart';

class ChatModel {
  ChatModel({this.productInfo, this.chatDetails, this.isBlocked});

  ProductInfo? productInfo;
  List<ChatDetail>? chatDetails;
  bool? isBlocked;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        isBlocked: json["is_blocked"],
        chatDetails: List<ChatDetail>.from(
            json["chat_details"].reversed.map((x) => ChatDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_blocked": isBlocked,
        "chat_details": List<dynamic>.from(chatDetails!.map((x) => x.toJson())),
      };
}

class ChatDetail {
  ChatDetail({
    this.messageId,
    this.fromId,
    this.toId,
    this.text,
    this.attachment,
    this.productInfo,
    this.time,
    this.date,
    this.isRead = false,
  });

  String? messageId;
  String? fromId;
  String? toId;
  String? text;
  String? attachment;
  String? time;
  String? date;
  ProductInfo? productInfo;
  bool isRead;

  factory ChatDetail.fromJson(Map<String, dynamic> json) => ChatDetail(
        messageId: json["message_id"].toString(),
        fromId: json["from_id"].toString(),
        toId: json["to_id"].toString(),
        text: json["text"].toString(),
        attachment: json["attachment"],
        time: DateFormat.jm('en')
            .format(json['date_added'].runtimeType == int
                ? DateTime.fromMillisecondsSinceEpoch(json['date_added'])
                : DateTime.parse(json['date_added'].toString()))
            .replaceAll('PM', 'م')
            .replaceAll('AM', 'ص'),
        productInfo:
            json['product_info'] == null || json['product_info'].isEmpty
                ? null
                : ProductInfo.fromJson(json["product_info"]),
        date: DateFormat.yMMMEd('en').format(
            json['date_added'].runtimeType == int
                ? DateTime.fromMillisecondsSinceEpoch(json['date_added'])
                : DateTime.parse(json['date_added'].toString())),
        isRead: json['status'] == 1,
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "from_id": fromId,
        "to_id": toId,
        "text": text,
        "attachment": attachment,
        "product_info": productInfo?.toJson(),
        "status": isRead ? 1 : 0,
      };
}

class ProductInfo {
  ProductInfo({
    this.productId,
    this.name,
    this.image,
  });

  String? productId;
  String? name;
  String? image;

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
        productId: json["product_id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "name": name,
        "image": image,
      };
}
