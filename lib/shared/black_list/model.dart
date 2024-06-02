// To parse this JSON data, do
//
//     final blackListModel = blackListModelFromJson(jsonString);

import 'dart:convert';

BlackListModel blackListModelFromJson(String str) =>
    BlackListModel.fromJson(json.decode(str));

String blackListModelToJson(BlackListModel data) => json.encode(data.toJson());

class BlackListModel {
  BlackListModel({
    this.totalBanned,
    this.bannedList,
  });

  int? totalBanned;
  List<BannedList>? bannedList;

  factory BlackListModel.fromJson(Map<String, dynamic> json) => BlackListModel(
        totalBanned: json["total_banned"],
        bannedList: List<BannedList>.from(
            json["banned_list"].map((x) => BannedList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_banned": totalBanned,
        "banned_list": List<dynamic>.from(bannedList!.map((x) => x.toJson())),
      };
}

class BannedList {
  BannedList({
    this.customerId,
    this.name,
    this.icon,
  });

  String? customerId;
  String? name;
  String? icon;

  factory BannedList.fromJson(Map<String, dynamic> json) => BannedList(
        customerId: json["customer_id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "name": name,
        "icon": icon,
      };
}
