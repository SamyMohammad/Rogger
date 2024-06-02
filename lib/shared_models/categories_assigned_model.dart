// To parse this JSON data, do
//
//     final categoryAssignedModel = categoryAssignedModelFromJson(jsonString);

import 'dart:convert';

CategoryAssignedModel categoryAssignedModelFromJson(String str) =>
    CategoryAssignedModel.fromJson(json.decode(str));

String categoryAssignedModelToJson(CategoryAssignedModel data) =>
    json.encode(data.toJson());

class CategoryAssignedModel {
  CategoryAssignedModel({
    this.categories,
  });

  List<Category>? categories;

  factory CategoryAssignedModel.fromJson(Map<String, dynamic> json) =>
      CategoryAssignedModel(
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.categoryId,
    this.name,
  });

  String? categoryId;
  String? name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "name": name,
      };
}
