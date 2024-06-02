/// success : true
/// data : [{"name":"شعبيات","id":"7"},{"name":"عطور","id":"37"}]

class CategoriesInAddProduct {
  CategoriesInAddProduct({
    this.success,
    this.data,
  });

  CategoriesInAddProduct.fromJson(dynamic json) {
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CategoryInAddProduct.fromJson(v));
      });
    }
  }
  bool? success;
  List<CategoryInAddProduct>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// name : "شعبيات"
/// id : "7"

class CategoryInAddProduct {
  CategoryInAddProduct({
    this.name,
    this.id,
  });

  CategoryInAddProduct.fromJson(dynamic json) {
    name = json['name'];
    id = json['id'];
  }
  String? name;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['id'] = id;
    return map;
  }
}