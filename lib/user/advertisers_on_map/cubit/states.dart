abstract class AdvertisersOnMapStates {}

class AdvertisersOnMapInitStates extends AdvertisersOnMapStates {}

class AdvertisersOnMapLoadingStates extends AdvertisersOnMapStates {}

class AdvertisersOnMapLoadedStates extends AdvertisersOnMapStates {   }

class AdvertisersOnMapErrorStates extends AdvertisersOnMapStates {
  String? error;
  AdvertisersOnMapErrorStates(this.error);
}
