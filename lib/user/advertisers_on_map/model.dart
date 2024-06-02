// To parse this JSON data, do
//
//     final advertisersOnMapModel = advertisersOnMapModelFromJson(jsonString);

import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

AdvertisersOnMapModel advertisersOnMapModelFromJson(String str) =>
    AdvertisersOnMapModel.fromJson(json.decode(str));

String advertisersOnMapModelToJson(AdvertisersOnMapModel data) =>
    json.encode(data.toJson());

class AdvertisersOnMapModel {
  AdvertisersOnMapModel({
    this.advertizers,
  });

  List<Advertizer>? advertizers;

  factory AdvertisersOnMapModel.fromJson(Map<String, dynamic> json) {
    List<Advertizer> advertizers = [];
    for (var i in json["advertizers"]) {
      if (i['loc_lat'] != null) {
        advertizers.add(Advertizer.fromJson(i));
      }
    }
    return AdvertisersOnMapModel(
      advertizers: advertizers,
    );
  }

  Map<String, dynamic> toJson() => {
        "advertizers": List<dynamic>.from(advertizers!.map((x) => x.toJson())),
      };
}

class Advertizer {
  Advertizer(
      {this.advertizerId,
      this.nickname,
      this.location,
      this.city,
      this.profile,
      this.activeTiming});

  String? advertizerId;
  String? nickname;
  LatLng? location;
  String? city;
  String? profile;
  String? activeTiming;

  factory Advertizer.fromJson(Map<String, dynamic> json) => Advertizer(
        advertizerId: json["advertizer_id"],
        nickname: json["nickname"] == null ? null : json["nickname"],
        location: LatLng(
            double.parse(json["loc_lat"]), double.parse(json["loc_long"])),
        city: json["city"] == null ? null : json["city"],
        profile: json['profile'],
        activeTiming: json['active_timing'],
      );

  Map<String, dynamic> toJson() => {
        "advertizer_id": advertizerId,
        "nickname": nickname == null ? null : nickname,
        // "loc_lat": locLat == null ? null : locLat,
        // "loc_long": locLong == null ? null : locLong,
        "city": city == null ? null : city,
      };
}
