// To parse this JSON data, do
//
//     final homeProductsModel = homeProductsModelFromJson(jsonString);

import 'dart:convert';

HomeProductsModel homeProductsModelFromJson(String str) =>
    HomeProductsModel.fromJson(json.decode(str));

String homeProductsModelToJson(HomeProductsModel data) =>
    json.encode(data.toJson());

class HomeProductsModel {
  HomeProductsModel({
    this.productsCount,
    this.products,
  });

  int? productsCount;
  List<Product>? products;

  factory HomeProductsModel.fromJson(Map<String, dynamic> json) =>
      HomeProductsModel(
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
    this.location,
    this.advertizerName,
    this.advertizerRating,
    this.customerProfile,
    this.sinceDate,
  });

  String? productId;
  String? thumb;
  String? name;
  String? price;
  String? location;
  String? advertizerName;
  String? customerProfile;
  int? advertizerRating;
  String? sinceDate;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        thumb: json["thumb"],
        name: json["name"],
        price: json["price"],
        customerProfile: json['customer_profile'],
        location: json["location"],
        advertizerName: json["advertizer_name"],
        advertizerRating: json["advertizer_rating"],
        sinceDate: json["since_date"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "thumb": thumb,
        "name": name,
        "price": price,
        "location": location,
        "advertizer_name": advertizerName,
        "advertizer_rating": advertizerRating,
        "since_date": sinceDate,
        'customer_profile': customerProfile,
      };
}
