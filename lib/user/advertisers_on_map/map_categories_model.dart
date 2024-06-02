// To parse this JSON data, do
//
//     final mapCategoiresModel = mapCategoiresModelFromJson(jsonString);

import 'dart:convert';

MapCategoriesModel mapCategoiresModelFromJson(String str) =>
    MapCategoriesModel.fromJson(json.decode(str));

String mapCategoiresModelToJson(MapCategoriesModel data) =>
    json.encode(data.toJson());

class MapCategoriesModel {
  MapCategoriesModel({
    this.mapCategories,
  });

  List<MapCategory>? mapCategories;

  factory MapCategoriesModel.fromJson(Map<String, dynamic> json) =>
      MapCategoriesModel(
        mapCategories: List<MapCategory>.from(
            json["map_categories"].map((x) => MapCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "map_categories":
            List<dynamic>.from(mapCategories!.map((x) => x.toJson())),
      };
}

class MapCategory {
  MapCategory({
    this.id,
    this.name,
    this.image,
  });

  int? id;
  String? name;
  String? image;

  factory MapCategory.fromJson(Map<String, dynamic> json) => MapCategory(
        id: json["map_category_id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "map_category_id": id,
        "name": name,
        "image": image,
      };
}
