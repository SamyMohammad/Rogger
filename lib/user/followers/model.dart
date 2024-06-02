// To parse this JSON data, do
//
//     final followersModel = followersModelFromJson(jsonString);

import 'dart:convert';

FollowersModel followersModelFromJson(String str) =>
    FollowersModel.fromJson(json.decode(str));

String followersModelToJson(FollowersModel data) => json.encode(data.toJson());

class FollowersModel {
  FollowersModel({
    this.followingList,
  });

  List<FollowingList>? followingList;

  factory FollowersModel.fromJson(Map<String, dynamic> json) => FollowersModel(
        followingList: List<FollowingList>.from(
            json["following_list"].map((x) => FollowingList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "following_list":
            List<dynamic>.from(followingList!.map((x) => x.toJson())),
      };
}

class FollowingList {
  FollowingList({
    this.advertizerId,
    this.advertizerName,
    this.advertizerProfile,
    this.isFollowing = true,
  });

  String? advertizerId;
  String? advertizerName;
  String? advertizerProfile;
  bool? isFollowing;

  factory FollowingList.fromJson(Map<String, dynamic> json) => FollowingList(
        advertizerId: json["advertizer_id"],
        advertizerName: json["advertizer_name"],
        advertizerProfile: json["advertizer_profile"],
      );

  Map<String, dynamic> toJson() => {
        "advertizer_id": advertizerId,
        "advertizer_name": advertizerName,
        "advertizer_profile": advertizerProfile,
      };
}
