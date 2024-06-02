// To parse this JSON data, do
//
//     final customerGroupsModel = customerGroupsModelFromJson(jsonString);

import 'dart:convert';

CustomerGroupsModel customerGroupsModelFromJson(String str) =>
    CustomerGroupsModel.fromJson(json.decode(str));

String customerGroupsModelToJson(CustomerGroupsModel data) =>
    json.encode(data.toJson());

class CustomerGroupsModel {
  CustomerGroupsModel({
    this.customerGroups,
  });

  List<CustomerGroup>? customerGroups;

  factory CustomerGroupsModel.fromJson(Map<String, dynamic> json) =>
      CustomerGroupsModel(
        customerGroups: List<CustomerGroup>.from(
            json["customer_groups"].map((x) => CustomerGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "customer_groups":
            List<dynamic>.from(customerGroups!.map((x) => x.toJson())),
      };
}

class CustomerGroup {
  CustomerGroup({
    this.customerGroupId,
    this.name,
  });

  String? customerGroupId;
  String? name;

  factory CustomerGroup.fromJson(Map<String, dynamic> json) => CustomerGroup(
        customerGroupId: json["customer_group_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "customer_group_id": customerGroupId,
        "name": name,
      };
}
