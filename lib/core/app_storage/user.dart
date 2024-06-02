// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.name,
    this.nickname,
    this.telephone,
    this.email,
    this.address,
    this.profileImage,
    this.profileCover,
    this.customerId,
    this.customerGroup,
    this.mapCategoryID,
    this.brief,
    this.modifiedTelephone,
    this.modificationInterval,
  });

  String? name;
  String? nickname;
  int? customerId;
  int? customerGroup;
  String? telephone;
  String? email;
  String? address;
  String? profileImage;
  String? profileCover;
  int? mapCategoryID;
  String? brief;
  String? modifiedTelephone;
  String? modificationInterval;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"],
      nickname: json["nickname"],
      telephone: json["telephone"],
      email: json["email"],
      customerId: json['customer_id'],
      customerGroup: json['customer_group'],
      address: json["address"],
      profileImage: json["profile_image"],
      mapCategoryID: json['map_category_id'],
      brief: json['brief'].toString(),
      modifiedTelephone: json['modified_telephone'],
      profileCover: json['profile_cover'],
      modificationInterval: json['modification_interval'] == null
          ? null
          : json['modification_interval'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "nickname": nickname,
      "telephone": telephone,
      "email": email,
      "address": address,
      "profile_image": profileImage,
      "customer_id": customerId,
      "customer_group": customerGroup,
      'map_category_id': mapCategoryID,
      'brief': brief,
      'modified_telephone': modifiedTelephone,
      'modification_interval': modificationInterval,
      'profile_cover': profileCover,
    };
  }
}
