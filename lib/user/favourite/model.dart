// To parse this JSON data, do
//
//     final favouriteModel = favouriteModelFromJson(jsonString);

import 'dart:convert';

FavouriteModel favouriteModelFromJson(String str) =>
    FavouriteModel.fromJson(json.decode(str));

String favouriteModelToJson(FavouriteModel data) => json.encode(data.toJson());

class FavouriteModel {
  FavouriteModel({
    this.wishlistTotalProducts,
    this.wishlistProducts,
  });

  String? wishlistTotalProducts;
  List<WishlistProduct>? wishlistProducts;

  factory FavouriteModel.fromJson(Map<String, dynamic> json) => FavouriteModel(
        wishlistTotalProducts: json["wishlist_total_products"],
        wishlistProducts: List<WishlistProduct>.from(
            json["wishlist_products"].map((x) => WishlistProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wishlist_total_products": wishlistTotalProducts,
        "wishlist_products":
            List<dynamic>.from(wishlistProducts!.map((x) => x.toJson())),
      };
}

class WishlistProduct {
  WishlistProduct({
    this.productId,
    this.thumb,
    this.name,
  });

  String? productId;
  String? thumb;
  String? name;

  factory WishlistProduct.fromJson(Map<String, dynamic> json) =>
      WishlistProduct(
        productId: json["product_id"],
        thumb: json["thumb"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "thumb": thumb,
        "name": name,
      };
}
