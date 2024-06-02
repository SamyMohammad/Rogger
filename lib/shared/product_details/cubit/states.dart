abstract class ProductsDetailsStates {}

class ProductsDetailsInitState extends ProductsDetailsStates {}

class ProductsDetailsLoadingState extends ProductsDetailsStates {}

class ProductsDetailsErrorState extends ProductsDetailsStates {
  String? error;
  ProductsDetailsErrorState(this.error);
}
