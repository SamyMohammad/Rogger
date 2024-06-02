// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

import 'dart:convert';

ProductsModel productsModelFromJson(String str) =>
    ProductsModel.fromJson(json.decode(str));

String productsModelToJson(ProductsModel data) => json.encode(data.toJson());

class ProductsModel {
  ProductsModel({
    this.productsCount,
    this.products,
  });

  int? productsCount;
  List<Product>? products;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        productsCount: json["products_count"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products_count": productsCount,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    this.productId,
    this.thumb,
    this.name,
    this.price,
    this.viewed,
    this.dateAdded,
  });

  String? productId;
  String? thumb;
  String? name;
  String? price;
  String? viewed;
  String? dateAdded;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        thumb: json["thumb"],
        name: json["name"],
        price: json["price"],
        viewed: json["viewed"],
        dateAdded: json["date_added"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "thumb": thumb,
        "name": name,
        "price": price,
        "viewed": viewed,
        "date_added": dateAdded,
      };
}
