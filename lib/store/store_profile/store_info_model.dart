// To parse this JSON data, do
//
//     final storeInfoModel = storeInfoModelFromJson(jsonString);

import 'dart:convert';

StoreInfoModel storeInfoModelFromJson(String str) =>
    StoreInfoModel.fromJson(json.decode(str));

String storeInfoModelToJson(StoreInfoModel data) => json.encode(data.toJson());

class StoreInfoModel {
  StoreInfoModel({
    this.profileImage,
    this.name,
    this.nickname,
    this.brief,
    this.email,
    this.telephone,
    this.totalRating,
    this.totalRatingCount,
    this.totalFollowerCount,
    this.address,
    this.profileCover,
  });

  String? profileImage;
  String? profileCover;
  String? name;
  String? nickname;
  String? brief;
  String? email;
  String? address;
  String? telephone;
  int? totalRating;
  String? totalRatingCount;
  String? totalFollowerCount;

  factory StoreInfoModel.fromJson(Map<String, dynamic> json) {
    print('json["brief"] ${json["brief"]}');
    return StoreInfoModel(
        profileImage: json["profile_image"],
        name: json["name"],
        nickname: json["nickname"],
        brief: json["brief"].toString(),
        email: json["email"],
        telephone: json["telephone"],
        totalRating: json["total_rating"],
        totalRatingCount: json["total_rating_count"].toString(),
        totalFollowerCount: json["total_follower_count"].toString(),
        address: json['address'],
        profileCover: json['profile_cover']);
  }

  Map<String, dynamic> toJson() => {
        "profile_image": profileImage,
        "name": name,
        "nickname": nickname,
        "brief": brief,
        "email": email,
        "telephone": telephone,
        "total_rating": totalRating,
        "total_rating_count": totalRatingCount,
        "total_follower_count": totalFollowerCount,
        'address': address,
        'profile_cover': profileCover,
      };
}
