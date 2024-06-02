abstract class VerifyStates {}

class VerifyInitState extends VerifyStates {}

class VerifyLoadingState extends VerifyStates {}

class VerifyErrorState extends VerifyStates {
  String? error;
  VerifyErrorState(this.error);
}
