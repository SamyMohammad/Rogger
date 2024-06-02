abstract class FavouriteStates {}

class FavouriteInitStates extends FavouriteStates {}

class FavouriteLoadingStates extends FavouriteStates {}

class FavouriteErrorStates extends FavouriteStates {
  String? error;
  FavouriteErrorStates(this.error);
}
