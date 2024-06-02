import 'dart:convert';

class Request {
  String? verificationRequestId;
  String? customerId;
  String? verificationType;
  String? verificationTypeNumber;
  String? verificationTypeImage;
  String? verified;
  String? transactionImage;
  String? verificationPeriod;
  String? verifiedBy;
  dynamic verifiedAt;
  String? status;
  String? createdAt;

  Request({
    this.verificationRequestId,
    this.customerId,
    this.verificationType,
    this.verificationTypeNumber,
    this.verificationTypeImage,
    this.verified,
    this.transactionImage,
    this.verificationPeriod,
    this.verifiedBy,
    this.verifiedAt,
    this.status,
    this.createdAt,
  });

  factory Request.fromMap(Map<String, dynamic> data) => Request(
        verificationRequestId: data['verification_request_id'] as String?,
        customerId: data['customer_id'] as String?,
        verificationType: data['verification_type'] as String?,
        verificationTypeNumber: data['verification_type_number'] as String?,
        verificationTypeImage: data['verification_type_image'] as String?,
        verified: data['verified'] as String?,
        transactionImage: data['transaction_image'] as String?,
        verificationPeriod: data['verification_period'] as String?,
        verifiedBy: data['verified_by'] as String?,
        verifiedAt: data['verified_at'] as dynamic,
        status: data['STATUS'] as String?,
        createdAt: data['created_at'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'verification_request_id': verificationRequestId,
        'customer_id': customerId,
        'verification_type': verificationType,
        'verification_type_number': verificationTypeNumber,
        'verification_type_image': verificationTypeImage,
        'verified': verified,
        'transaction_image': transactionImage,
        'verification_period': verificationPeriod,
        'verified_by': verifiedBy,
        'verified_at': verifiedAt,
        'STATUS': status,
        'created_at': createdAt,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Request].
  factory Request.fromJson(String data) {
    return Request.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Request] to a JSON string.
  String toJson() => json.encode(toMap());
}
