abstract class ProductStates {}

class ProductInitState extends ProductStates {}

class ProductLoadingState extends ProductStates {}

class ProductErrorState extends ProductStates {
  String? error;
  ProductErrorState(this.error);
}
