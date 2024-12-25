// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);


// CategoriesModel categoriesModelFromJson(String str) =>
//     CategoriesModel.fromJson(json.decode(str));

// String categoriesModelToJson(CategoriesModel data) =>
//     json.encode(data.toJson());

// class CategoriesModel {
//   CategoriesModel({
//     this.categories,
//   });

//   List<Category>? categories;

//   factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
//       CategoriesModel(
//         categories: List<Category>.from(
//             json["categories"].map((x) => Category.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
//       };
// }

// class Category {
//   Category({
//     this.id,
//     this.name,
//     this.image,
//     this.cover
//   });

//   String? id;
//   String? name;
//   String? image;
//   String? cover;

//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//         id: json["category_id"],
//         name: json["name"],
//         image: json["image"],
//                  cover: json["ad_image"],
      
//       );

//   Map<String, dynamic> toJson() => {
//         "category_id": id,
//         "name": name,
//         "image": image,
//         'ad_image':cover
//       };
// }



class CategoriesModel {
  bool? success;
  List<Category>? categories;

  CategoriesModel({this.success, this.categories});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? id;
  String? name;
  String? image;

  Category({this.id, this.name, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
