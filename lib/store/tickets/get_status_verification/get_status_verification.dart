class GetStatusVerification {
  bool? success;
  List<Request>? requests;

  GetStatusVerification({this.success, this.requests});

  GetStatusVerification.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['requests'] != null) {
      requests = <Request>[];
      json['requests'].forEach((v) {
        requests!.add(new Request.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.requests != null) {
      data['requests'] = this.requests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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
  String? verifiedAt;
  String? sTATUS;
  String? createdAt;
  String? verificationRequired;
  bool? isExpired;

  Request(
      {this.verificationRequestId,
        this.customerId,
        this.verificationType,
        this.verificationTypeNumber,
        this.verificationTypeImage,
        this.verified,
        this.transactionImage,
        this.verificationPeriod,
        this.verifiedBy,
        this.verifiedAt,
        this.sTATUS,
        this.createdAt,
        this.verificationRequired,
        this.isExpired});

  Request.fromJson(Map<String, dynamic> json) {
    verificationRequestId = json['verification_request_id'];
    customerId = json['customer_id'];
    verificationType = json['verification_type'];
    verificationTypeNumber = json['verification_type_number'];
    verificationTypeImage = json['verification_type_image'];
    verified = json['verified'];
    transactionImage = json['transaction_image'];
    verificationPeriod = json['verification_period'];
    verifiedBy = json['verified_by'];
    verifiedAt = json['verified_at'];
    sTATUS = json['STATUS'];
    verificationRequired = json['verification_required'];
    createdAt = json['created_at'];
    isExpired = json['is_expired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verification_request_id'] = this.verificationRequestId;
    data['customer_id'] = this.customerId;
    data['verification_type'] = this.verificationType;
    data['verification_type_number'] = this.verificationTypeNumber;
    data['verification_type_image'] = this.verificationTypeImage;
    data['verified'] = this.verified;
    data['transaction_image'] = this.transactionImage;
    data['verification_period'] = this.verificationPeriod;
    data['verified_by'] = this.verifiedBy;
    data['verified_at'] = this.verifiedAt;
    data['STATUS'] = this.sTATUS;
    data['created_at'] = this.createdAt;
    data['is_expired'] = this.isExpired;

    return data;
  }
}
