abstract class FollowersStates {}

class FollowersInitState extends FollowersStates {}

class FollowersLoadingState extends FollowersStates {}

class FollowersErrorState extends FollowersStates {
  String? error;
  FollowersErrorState(this.error);
}
