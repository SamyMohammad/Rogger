// To parse this JSON data, do
//
//     final citiesModel = citiesModelFromJson(jsonString);

import 'dart:convert';

CitiesModel citiesModelFromJson(String str) =>
    CitiesModel.fromJson(json.decode(str));

String citiesModelToJson(CitiesModel data) => json.encode(data.toJson());

class CitiesModel {
  CitiesModel({
    this.countries,
  });

  List<Country>? countries;

  factory CitiesModel.fromJson(Map<String, dynamic> json) => CitiesModel(
        countries: List<Country>.from(
            json["countries"].map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countries": List<dynamic>.from(countries!.map((x) => x.toJson())),
      };
}

class Country {
  Country({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["country_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "country_id": id,
        "name": name,
      };
}
