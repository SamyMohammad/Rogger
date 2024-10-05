import 'package:silah/store/tickets/ErrorModel.dart';

abstract class TicketsStates {}

class TicketsInitState extends TicketsStates {}

class TicketsLoadingState extends TicketsStates {}

class TicketsEmptyState extends TicketsStates {}

class TicketsErrorState extends TicketsStates {
  String? error;
  TicketsErrorState(this.error);
}

class RequestVerificationLoadingState extends TicketsStates {}

class RequestVerificationSuccessState extends TicketsStates {
  dynamic response;
  RequestVerificationSuccessState(this.response);
}

class RequestVerificationErrorState extends TicketsStates {
  ErrorModel? error;
  RequestVerificationErrorState(this.error);
}

class ValidateState extends TicketsStates {
  ValidateState(this.isValidate);
  bool? isValidate;
}

class GetStatusVerificationSuccessState extends TicketsStates {
  dynamic response;
  GetStatusVerificationSuccessState(this.response);
}

class NavigateToVerifyMethodFormState extends TicketsStates {}
class GetStatusVerificationErrorState extends TicketsStates {}

class GetStatusVerificationLoadingState extends TicketsStates {}

class UpdateRequestVerificationLoadingState extends TicketsStates {}

class UpdateRequestVerificationSuccessState extends TicketsStates {
  dynamic response;
  UpdateRequestVerificationSuccessState(this.response);
}

class UpdateRequestVerificationErrorState extends TicketsStates {
  ErrorModel? error;
  UpdateRequestVerificationErrorState(this.error);
}

class ToggleIsFirstSelectedState extends TicketsStates {}

class ToggleIsSecondSelectedState extends TicketsStates {}
