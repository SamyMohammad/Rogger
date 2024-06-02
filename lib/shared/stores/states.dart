part of 'cubit.dart';

abstract class StoresStates {}

class StoresInit extends StoresStates {}

class StoresEmpty extends StoresStates {}

class StoresLoading extends StoresStates {}

class GetAdsLoadingState extends StoresStates {}

class GetAdsSuccessState extends StoresStates {}

class GetAdsErrorState extends StoresStates {
  String? error;
  GetAdsErrorState(this.error);
}

class GetAdvertisersLoadingState extends StoresStates {}

class GetAdvertisersSuccessState extends StoresStates {
  List<Advertisers> advertisers;

  GetAdvertisersSuccessState(this.advertisers);
}

class GetAdvertisersErrorState extends StoresStates {
  String? error;
  GetAdvertisersErrorState(this.error);
}

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchTextChanged extends SearchEvent {
  final String searchText;

  SearchTextChanged(this.searchText);

  @override
  List<Object> get props => [searchText];
}

class SearchInitial extends StoresStates {}

class SearchLoading extends StoresStates {}

class SearchSuccess extends StoresStates {
  final List<String> searchResults;

  SearchSuccess({required this.searchResults});

  @override
  List<Object> get props => [searchResults];
}


class GetSubCategoriesSuccessState extends StoresStates {}

class GetSubCategoriesLoadingState extends StoresStates {}

class GetSubCategoriesErrorState extends StoresStates {
  String? error;
  GetSubCategoriesErrorState(this.error);
}