abstract class StoreProfileStates {}

class StoreProfileInitState extends StoreProfileStates {}

class StoreProfileLoadingState extends StoreProfileStates {}

class StoreProfileEmptyState extends StoreProfileStates {}

class StoreProfileErrorState extends StoreProfileStates {
  String? error;
  StoreProfileErrorState(this.error);
}
class GetRateLoadingState extends StoreProfileStates {}

class GetRateEmptyState extends StoreProfileStates {}

class GetRateErrorState extends StoreProfileStates {
  String? error;
  GetRateErrorState(this.error);
}
class GetRelatedProductsLoadingState extends StoreProfileStates {}
class GetRelatedProductsSuccessState extends StoreProfileStates {}
class GetRelatedProductsEmptyState extends StoreProfileStates {}
class GetRelatedProductsErrorState extends StoreProfileStates {}

// class StoreProfileLoadingState extends StoreProfileStates {}

// class StoreProfileEmptyState extends StoreProfileStates {}

// class StoreProfileErrorState extends StoreProfileStates {
//   String? error;
//   StoreProfileErrorState(this.error);
// }
