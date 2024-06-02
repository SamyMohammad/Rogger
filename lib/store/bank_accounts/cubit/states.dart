abstract class BankStates {}

class BankInitState extends BankStates {}

class BankLoadingState extends BankStates {}

class BankErrorState extends BankStates {
  String? error;
  BankErrorState(this.error);
}
