// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) =>
    json.encode(data.toJson());

class NotificationsModel {
  NotificationsModel({
    this.accountPhoto,
    this.adminNotifications,
    this.inquiryNotifications,
    this.communicationNotifications,
    this.suggestionNotifications,
  });

  String? accountPhoto;
  Notifications? adminNotifications;
  Notifications? inquiryNotifications;
  Notifications? communicationNotifications;
  Notifications? suggestionNotifications;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        accountPhoto: json["account_photo"],
        adminNotifications: json["admin_notifications"] == null
            ? null
            : Notifications.fromJson(json["admin_notifications"]),
        inquiryNotifications: json["inquiry_notifications"] == null
            ? null
            : Notifications.fromJson(json["inquiry_notifications"]),
        communicationNotifications: json["communication_notifications"] == null
            ? null
            : Notifications.fromJson(json["communication_notifications"]),
        suggestionNotifications: json["suggestion_notifications"] == null
            ? null
            : Notifications.fromJson(json["suggestion_notifications"]),
      );

  Map<String, dynamic> toJson() => {
        "account_photo": accountPhoto,
        "admin_notifications": adminNotifications?.toJson(),
        "inquiry_notifications": inquiryNotifications?.toJson(),
        "communication_notifications": communicationNotifications?.toJson(),
        "suggestion_notifications": suggestionNotifications?.toJson(),
      };
}

class Notifications {
  Notifications({
    this.unread,
    this.icon,
    this.list,
  });

  int? unread;
  String? icon;
  List<ListElement>? list;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        unread: json["unread"],
        icon: json["icon"],
        list: json["list"] == null
            ? []
            : List<ListElement>.from(
                json["list"]!.map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "unread": unread,
        "icon": icon,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ListElement {
  ListElement({
    this.name,
    this.text,
    this.dateDiff,
    this.photo,
  });

  String? name;
  String? text;
  DateTime? dateDiff;
  String? photo;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        name: json["name"],
        text: json["text"],
        dateDiff: DateTime.tryParse(json["date_diff"]) ?? DateTime.now(),
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "text": text,
        "date_diff": dateDiff,
        "photo": photo,
      };
}
