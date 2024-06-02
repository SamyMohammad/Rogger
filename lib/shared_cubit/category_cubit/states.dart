import '../../store/tickets/ErrorModel.dart';

abstract class CategoryStates {}

class CategoryInitState extends CategoryStates {}

class CategoryLoadingState extends CategoryStates {}

class CategoryMoreLoadingState extends CategoryStates {}

class CategoryErrorState extends CategoryStates {
  String? error;
  CategoryErrorState(this.error);
}

class GetSubCategoriesLoadingState extends CategoryStates {}

class GetSubCategoriesSuccessState extends CategoryStates {}

class GetSubCategoriesErrorState extends CategoryStates {
  String? error;
  GetSubCategoriesErrorState(this.error);
}

class ValidateState extends CategoryStates {
  bool? state;
  ValidateState({this.state});
}

class RequestVerificationLoadingState extends CategoryStates {}

class RequestVerificationSucessState extends CategoryStates {
  dynamic response;
  RequestVerificationSucessState(this.response);
}

class RequestVerificationErrorState extends CategoryStates {
  dynamic response;
  RequestVerificationErrorState(this.response);
}
