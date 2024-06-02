// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);

import 'dart:convert';

BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));

String bankModelToJson(BankModel data) => json.encode(data.toJson());

class BankModel {
  BankModel({
    this.banks,
  });

  List<Bank>? banks;

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        banks: List<Bank>.from(json["banks"].map((x) => Bank.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banks": List<dynamic>.from(banks!.map((x) => x.toJson())),
      };
}

class Bank {
  Bank({
    this.bankId,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNum,
    this.bankIpan,
    this.bankImg,
  });

  String? bankId;
  String? bankName;
  String? bankAccountName;
  String? bankAccountNum;
  String? bankIpan;
  String? bankImg;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        bankId: json["bank_id"],
        bankName: json["bank_name"],
        bankAccountName: json["bank_account_name"],
        bankAccountNum: json["bank_account_num"],
        bankIpan: json["bank_ipan"],
        bankImg: json["bank_img"],
      );

  Map<String, dynamic> toJson() => {
        "bank_id": bankId,
        "bank_name": bankName,
        "bank_account_name": bankAccountName,
        "bank_account_num": bankAccountNum,
        "bank_ipan": bankIpan,
        "bank_img": bankImg,
      };
}
