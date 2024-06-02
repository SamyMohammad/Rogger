abstract class ChangeMapActivityStates {}

class ChangeMapActivityInitState extends ChangeMapActivityStates {}

class ChangeMapActivityLoadingState extends ChangeMapActivityStates {}

class ChangeMapActivityErrorState extends ChangeMapActivityStates {
  String? error;
  ChangeMapActivityErrorState(this.error);
}
