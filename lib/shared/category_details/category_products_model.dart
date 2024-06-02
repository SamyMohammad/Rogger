// To parse this JSON data, do
//
//     final categoryProductsModel = categoryProductsModelFromJson(jsonString);

import 'dart:convert';

import 'package:silah/shared_models/home_products_model.dart';

CategoryProductsModel categoryProductsModelFromJson(String str) =>
    CategoryProductsModel.fromJson(json.decode(str));

String categoryProductsModelToJson(CategoryProductsModel data) =>
    json.encode(data.toJson());

class CategoryProductsModel {
  CategoryProductsModel({
    this.productsCount,
    this.products,
  });

  int? productsCount;
  List<Product>? products;

  factory CategoryProductsModel.fromJson(Map<String, dynamic> json) =>
      CategoryProductsModel(
        productsCount: json["products_count"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products_count": productsCount,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}
