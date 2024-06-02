/// success : true
/// message : "all parent categories with subcategories"
/// data : [{"parent_id":6,"parent_image":"catalog/banks/Surface Pro 8 - 6 (2).png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":5,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:48:12","parent_date_modified":"2023-10-14 14:11:36","sub":[{"category_id":7,"parent_image":"catalog/banks/Surface Pro 8 - 4 (2).png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":4,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:48:51","parent_date_modified":"2023-10-14 13:26:28"}]},{"parent_id":7,"parent_image":"catalog/banks/Surface Pro 8 - 4 (2).png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":4,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:48:51","parent_date_modified":"2023-10-14 13:26:28","sub":[]},{"parent_id":1,"parent_image":"catalog/banks/Surface Pro 8 - 6.png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":2,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:45:33","parent_date_modified":"2023-10-14 13:54:55","sub":[]},{"parent_id":2,"parent_image":"catalog/banks/Surface Pro 8 - 7.png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":6,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:45:58","parent_date_modified":"2023-10-14 15:07:06","sub":[]},{"parent_id":5,"parent_image":"catalog/banks/Surface Pro 8 - 6 (1).png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":3,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:47:40","parent_date_modified":"2023-10-14 14:04:12","sub":[]},{"parent_id":4,"parent_image":"catalog/banks/Surface Pro 8 - 5 (1).png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":1,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:46:59","parent_date_modified":"2023-10-14 13:44:58","sub":[]},{"parent_id":3,"parent_image":"catalog/banks/Surface Pro 8 - 7 (2).png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":7,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:46:31","parent_date_modified":"2023-10-14 15:20:52","sub":[]},{"parent_id":9,"parent_image":"catalog/banks/Surface Pro 8 - 7 (5).png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":9,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:49:44","parent_date_modified":"2023-10-14 19:25:33","sub":[]},{"parent_id":8,"parent_image":"catalog/banks/Surface Pro 8 - 7 (3).png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":8,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:49:21","parent_date_modified":"2023-10-14 15:29:47","sub":[]},{"parent_id":12,"parent_image":"catalog/IMG_6739.png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":11,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-12-02 17:57:18","parent_date_modified":"2023-08-24 16:47:46","sub":[]},{"parent_id":13,"parent_image":"catalog/banks/Surface Pro 8 - 8.png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":10,"parent_details_status":1,"parent_status":1,"parent_date_added":"2023-08-23 14:11:58","parent_date_modified":"2023-10-15 23:57:23","sub":[]}]

class GetCategories {
  GetCategories({
    this.success,
    this.message,
    this.data,
  });

  GetCategories.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  bool? success;
  String? message;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// parent_id : 6
/// parent_image : "catalog/banks/Surface Pro 8 - 6 (2).png"
/// parent_parent_id : 0
/// parent_tax_value : 0
/// parent_top : 1
/// parent_column : 1
/// parent_sort_order : 5
/// parent_details_status : 1
/// parent_status : 1
/// parent_date_added : "2022-03-10 18:48:12"
/// parent_date_modified : "2023-10-14 14:11:36"
/// sub : [{"category_id":7,"parent_image":"catalog/banks/Surface Pro 8 - 4 (2).png","parent_parent_id":0,"parent_tax_value":0,"parent_top":1,"parent_column":1,"parent_sort_order":4,"parent_details_status":1,"parent_status":1,"parent_date_added":"2022-03-10 18:48:51","parent_date_modified":"2023-10-14 13:26:28"}]

class Data {
  Data({
    this.parentId,
    this.parentImage,
    this.parentParentId,
    this.parentTaxValue,
    this.parentTop,
    this.parentColumn,
    this.parentSortOrder,
    this.parentDetailsStatus,
    this.parentStatus,
    this.parentDateAdded,
    this.parentDateModified,
    this.sub,
  });

  Data.fromJson(dynamic json) {
    parentId = json['parent_id'];
    parentImage = json['parent_image'];
    parentParentId = json['parent_parent_id'];
    parentTaxValue = json['parent_tax_value'];
    parentTop = json['parent_top'];
    parentColumn = json['parent_column'];
    parentSortOrder = json['parent_sort_order'];
    parentDetailsStatus = json['parent_details_status'];
    parentStatus = json['parent_status'];
    parentDateAdded = json['parent_date_added'];
    parentDateModified = json['parent_date_modified'];
    if (json['sub'] != null) {
      sub = [];
      json['sub'].forEach((v) {
        sub?.add(Sub.fromJson(v));
      });
    }
  }
  num? parentId;
  String? parentImage;
  num? parentParentId;
  num? parentTaxValue;
  num? parentTop;
  num? parentColumn;
  num? parentSortOrder;
  num? parentDetailsStatus;
  num? parentStatus;
  String? parentDateAdded;
  String? parentDateModified;
  List<Sub>? sub;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['parent_id'] = parentId;
    map['parent_image'] = parentImage;
    map['parent_parent_id'] = parentParentId;
    map['parent_tax_value'] = parentTaxValue;
    map['parent_top'] = parentTop;
    map['parent_column'] = parentColumn;
    map['parent_sort_order'] = parentSortOrder;
    map['parent_details_status'] = parentDetailsStatus;
    map['parent_status'] = parentStatus;
    map['parent_date_added'] = parentDateAdded;
    map['parent_date_modified'] = parentDateModified;
    if (sub != null) {
      map['sub'] = sub?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// category_id : 7
/// parent_image : "catalog/banks/Surface Pro 8 - 4 (2).png"
/// parent_parent_id : 0
/// parent_tax_value : 0
/// parent_top : 1
/// parent_column : 1
/// parent_sort_order : 4
/// parent_details_status : 1
/// parent_status : 1
/// parent_date_added : "2022-03-10 18:48:51"
/// parent_date_modified : "2023-10-14 13:26:28"

class Sub {
  Sub({
    this.categoryId,
    this.parentImage,
    this.parentParentId,
    this.parentTaxValue,
    this.parentTop,
    this.parentColumn,
    this.parentSortOrder,
    this.parentDetailsStatus,
    this.parentStatus,
    this.parentDateAdded,
    this.parentDateModified,
  });

  Sub.fromJson(dynamic json) {
    categoryId = json['category_id'];
    parentImage = json['parent_image'];
    parentParentId = json['parent_parent_id'];
    parentTaxValue = json['parent_tax_value'];
    parentTop = json['parent_top'];
    parentColumn = json['parent_column'];
    parentSortOrder = json['parent_sort_order'];
    parentDetailsStatus = json['parent_details_status'];
    parentStatus = json['parent_status'];
    parentDateAdded = json['parent_date_added'];
    parentDateModified = json['parent_date_modified'];
  }
  num? categoryId;
  String? parentImage;
  num? parentParentId;
  num? parentTaxValue;
  num? parentTop;
  num? parentColumn;
  num? parentSortOrder;
  num? parentDetailsStatus;
  num? parentStatus;
  String? parentDateAdded;
  String? parentDateModified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category_id'] = categoryId;
    map['parent_image'] = parentImage;
    map['parent_parent_id'] = parentParentId;
    map['parent_tax_value'] = parentTaxValue;
    map['parent_top'] = parentTop;
    map['parent_column'] = parentColumn;
    map['parent_sort_order'] = parentSortOrder;
    map['parent_details_status'] = parentDetailsStatus;
    map['parent_status'] = parentStatus;
    map['parent_date_added'] = parentDateAdded;
    map['parent_date_modified'] = parentDateModified;
    return map;
  }
}
