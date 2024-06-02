abstract class BlackListStates {}

class BlackListInitState extends BlackListStates {}

class BlackListLoadingState extends BlackListStates {}

class BlackListErrorState extends BlackListStates {
  String? error;
  BlackListErrorState(this.error);
}
