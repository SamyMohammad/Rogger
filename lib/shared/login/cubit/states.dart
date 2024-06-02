abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginErroeState extends LoginStates {
  String? error;
  LoginErroeState(this.error);
}
