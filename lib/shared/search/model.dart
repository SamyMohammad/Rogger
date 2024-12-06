// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

SearchModel notificationsModelFromJson(String str) =>
    SearchModel.fromJson(json.decode(str));

String notificationsModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  SearchModel({
    required this.productTotal,
    required this.products,
  });

  final int productTotal;
  final List<Product> products;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        productTotal: int.tryParse(json["product_total"] ?? '') ?? 0,
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_total": productTotal,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    required this.productId,
    required this.categoryName,
    required this.customerId,
    required this.customerProfile,
    required this.thumb,
    required this.name,
    required this.description,
    required this.price,
    required this.customerName,
    required this.dateAdded,
    required this.dateModified,
    required this.rate,
    required this.city,
  });

  final String? productId;
  final String? categoryName;
  final String? customerId;
  final String? customerProfile;
  final String? thumb;
  final String? name;
  final String? description;
  final String? price;
  final String? customerName;
  final String? dateAdded;
  final String? dateModified;
  final double? rate;
  final String? city;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        categoryName: json["category_name"],
        customerId: json["customer_id"],
        thumb: json["thumb"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        customerName: json["customer_name"],
        dateAdded: json["date_added"],
        dateModified: json["date_modified"],
        customerProfile: json['customer_profile'],
        city: json['city'] ?? '',
        rate: double.tryParse(json['rate'].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "category_name": categoryName,
        "customer_id": customerId,
        "thumb": thumb,
        "name": name,
        "description": description,
        "price": price,
        "customer_name": customerName,
        "date_added": dateAdded,
        "date_modified": dateModified,
        'customer_profile': customerProfile,
      };
}
