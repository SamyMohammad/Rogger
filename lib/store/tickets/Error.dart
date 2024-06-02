class Error {
  Error({
    this.verificationTypeNumber,
    this.verificationTypeImage,
    this.errorTransactionImage,
  });

  Error.fromJson(dynamic json) {
    verificationTypeNumber = json['verification_type_number'];
    verificationTypeImage = json['verification_type_image'];
    errorTransactionImage = json['error_transaction_image'];
  }
  String? verificationTypeNumber;
  String? verificationTypeImage;
  String? errorTransactionImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['verification_type_number'] = verificationTypeNumber;
    map['verification_type_image'] = verificationTypeImage;
    map['error_transaction_image'] = errorTransactionImage;
    return map;
  }
}
