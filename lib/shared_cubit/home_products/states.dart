abstract class HomeProductsStates {}

class HomeProductsInitState extends HomeProductsStates {}

class HomeProductsLoadingState extends HomeProductsStates {}

class HomeProductsMoreLoadingState extends HomeProductsStates {}

class HomeProductsErrorState extends HomeProductsStates {
  String? error;
  HomeProductsErrorState(this.error);
}
class IsUserBannedState extends HomeProductsStates {
  bool? isBanned;
  IsUserBannedState(this.isBanned);
}