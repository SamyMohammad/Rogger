// To parse this JSON data, do
//
//     final productsDetailsModel = productsDetailsModelFromJson(jsonString);

import 'dart:convert';

class BaseModel {
  int? productId;
  String? productName;
  String? categoryID;
  String? categoryName;
  List<String>? productImages;
  bool? inWishlist;
  String? totalWishlist;
  String? location;
  String? price;
  String? video;
  String? advertizerId;
  String? advertizerName;
  String? advertizerProfile;
  String? description;

  BaseModel({
    this.productId,
    this.productName,
    this.categoryID,
    this.categoryName,
    this.productImages,
    this.inWishlist,
    this.totalWishlist,
    this.location,
    this.price,
    this.video,
    this.advertizerId,
    this.advertizerName,
    this.advertizerProfile,
    this.description,
  });
}

ProductsDetailsModel productsDetailsModelFromJson(String str) =>
    ProductsDetailsModel.fromJson(json.decode(str));

String productsDetailsModelToJson(ProductsDetailsModel data) =>
    json.encode(data.toJson());

class ProductsDetailsModel extends BaseModel {
  ProductsDetailsModel({
    int? productId,
    String? productName,
    String? categoryID,
    String? categoryName,
    List<String>? productImages,
    bool? inWishlist,
    String? totalWishlist,
    String? location,
    String? price,
    String? video,
    String? advertizerId,
    String? advertizerName,
    String? advertizerProfile,
    String? description,
    this.realted,
  }) : super(
          productId: productId,
          productName: productName,
          categoryID: categoryID,
          categoryName: categoryName,
          productImages: productImages,
          inWishlist: inWishlist,
          totalWishlist: totalWishlist,
          location: location,
          price: price,
          video: video,
          advertizerId: advertizerId,
          advertizerName: advertizerName,
          advertizerProfile: advertizerProfile,
          description: description,
        );

  List<Realted>? realted;

  factory ProductsDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProductsDetailsModel(
        productId: json["product_id"],
        productName: json["product_name"],
        productImages: List<String>.from(json["product_images"].map((x) => x)),
        inWishlist: json["in_wishlist"],
        totalWishlist: json["total_wishlist"],
        location: json["location"],
        price: json["price"],
        video: json["video"],
        advertizerId: json["advertizer_id"],
        advertizerName: json["advertizer_name"],
        advertizerProfile: json['advertizer_profile'],
        categoryID: json['category_id'],
        categoryName: json['category_name'],
        description: json['description'],
        realted:
            List<Realted>.from(json['realted'].map((x) => Realted.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_images": List<dynamic>.from(productImages!.map((x) => x)),
        "in_wishlist": inWishlist,
        "total_wishlist": totalWishlist,
        "location": location,
        "price": price,
        "video": video,
        "advertizer_id": advertizerId,
        "advertizer_name": advertizerName,
        'advertizer_profile': advertizerProfile,
        'description': description,
      };
}

class Realted extends BaseModel {
  String? categoryId;

  Realted({
    int? productId,
    String? productName,
    String? description,
    List<String>? productImages,
    bool? inWishlist,
    String? totalWishlist,
    String? location,
    String? price,
    String? video,
    String? advertizerId,
    String? advertizerName,
    String? advertizerProfile,
    this.categoryId,
  });

  Realted.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    description = json['description'];
    productImages = json['product_images'].cast<String>();
    inWishlist = json['in_wishlist'];
    totalWishlist = json['total_wishlist'];
    location = json['location'];
    price = json['price'];
    video = json['video'];
    categoryId = json['category_id'];
    advertizerId = json['advertizer_id'];
    advertizerName = json['advertizer_name'];
    advertizerProfile = json['advertizer_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['description'] = this.description;
    data['product_images'] = this.productImages;
    data['in_wishlist'] = this.inWishlist;
    data['total_wishlist'] = this.totalWishlist;
    data['location'] = this.location;
    data['price'] = this.price;
    data['video'] = this.video;
    data['category_id'] = this.categoryId;
    data['advertizer_id'] = this.advertizerId;
    data['advertizer_name'] = this.advertizerName;
    data['advertizer_profile'] = this.advertizerProfile;
    return data;
  }
}
