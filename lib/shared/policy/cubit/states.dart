abstract class PolicyStates {}

class PolicyInitState extends PolicyStates {}

class PolicyLoadingState extends PolicyStates {}

class PolicyErrorState extends PolicyStates {
  String? error;
  PolicyErrorState(this.error);
}
