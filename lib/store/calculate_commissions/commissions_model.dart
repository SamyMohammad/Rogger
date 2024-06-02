// To parse this JSON data, do
//
//     final commissionsModel = commissionsModelFromJson(jsonString);

import 'dart:convert';

CommissionsModel commissionsModelFromJson(String str) =>
    CommissionsModel.fromJson(json.decode(str));

String commissionsModelToJson(CommissionsModel data) =>
    json.encode(data.toJson());

class CommissionsModel {
  CommissionsModel({
    this.commissions,
  });

  List<Commission>? commissions;

  factory CommissionsModel.fromJson(Map<String, dynamic> json) =>
      CommissionsModel(
        commissions: List<Commission>.from(
            json["commissions"].map((x) => Commission.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "commissions": List<dynamic>.from(commissions!.map((x) => x.toJson())),
      };
}

class Commission {
  Commission({
    this.commissionId,
    this.commissionValue,
    this.dateAdded,
  });

  String? commissionId;
  String? commissionValue;
  double? commission;
  String? dateAdded;

  factory Commission.fromJson(Map<String, dynamic> json) => Commission(
        commissionId: json["commission_id"],
        commissionValue: json["commission_value"],
        dateAdded: json["date_added"],
      );

  Map<String, dynamic> toJson() => {
        "commission_id": commissionId,
        "commission_value": commissionValue,
        "date_added": dateAdded,
      };
}
