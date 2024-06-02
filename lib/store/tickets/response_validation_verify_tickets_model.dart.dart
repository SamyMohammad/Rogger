// /// error : {"verification_type_number":"تحذير: ضبط تفاصيل الرقم !","verification_type_image":"تحذير:يحب ارسال صورة الرقم !","error_transaction_image":"تحذير:يجب ارسال صورة التحويل !"}
//
// class ErrorResponseValidationVerifyTicketsModel {
//   ErrorResponseValidationVerifyTicketsModel({
//     Error error,
//   }) {
//     _error = error;
//   }
//
//   ErrorResponseValidationVerifyTicketsModel.fromJson(dynamic json) {
//     _error = json['error'] != null ? Error.fromJson(json['error']) : null;
//   }
//   Error _error;
//   ErrorResponseValidationVerifyTicketsModel copyWith({
//     Error error,
//   }) =>
//       ErrorResponseValidationVerifyTicketsModel(
//         error: error ?? _error,
//       );
//   Error get error => _error;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_error != null) {
//       map['error'] = _error.toJson();
//     }
//     return map;
//   }
// }
//
// /// verification_type_number : "تحذير: ضبط تفاصيل الرقم !"
// /// verification_type_image : "تحذير:يحب ارسال صورة الرقم !"
// /// error_transaction_image : "تحذير:يجب ارسال صورة التحويل !"
//
// class Error {
//   Error({
//     String verificationTypeNumber,
//     String verificationTypeImage,
//     String errorTransactionImage,
//   }) {
//     _verificationTypeNumber = verificationTypeNumber;
//     _verificationTypeImage = verificationTypeImage;
//     _errorTransactionImage = errorTransactionImage;
//   }
//
//   Error.fromJson(dynamic json) {
//     _verificationTypeNumber = json['verification_type_number'];
//     _verificationTypeImage = json['verification_type_image'];
//     _errorTransactionImage = json['error_transaction_image'];
//   }
//   String _verificationTypeNumber;
//   String _verificationTypeImage;
//   String _errorTransactionImage;
//   Error copyWith({
//     String verificationTypeNumber,
//     String verificationTypeImage,
//     String errorTransactionImage,
//   }) =>
//       Error(
//         verificationTypeNumber:
//             verificationTypeNumber ?? _verificationTypeNumber,
//         verificationTypeImage: verificationTypeImage ?? _verificationTypeImage,
//         errorTransactionImage: errorTransactionImage ?? _errorTransactionImage,
//       );
//   String get verificationTypeNumber => _verificationTypeNumber;
//   String get verificationTypeImage => _verificationTypeImage;
//   String get errorTransactionImage => _errorTransactionImage;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['verification_type_number'] = _verificationTypeNumber;
//     map['verification_type_image'] = _verificationTypeImage;
//     map['error_transaction_image'] = _errorTransactionImage;
//     return map;
//   }
// }
