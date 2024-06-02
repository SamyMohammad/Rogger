import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/location/location_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/nav_bar/view.dart';
import 'package:silah/shared/select_location_from_map/states.dart';

import '../../widgets/snack_bar.dart';

class SelectLocationFromMapCubit extends Cubit<SelectLocationFromMapStates> {
  SelectLocationFromMapCubit() : super(SelectLocationLoadingStates());

  static SelectLocationFromMapCubit of(context) => BlocProvider.of(context);

  LatLng? initialLocation;
  Set<Marker> mapMarkers = {};

  Future<void> initialize() async {
    try {
      final position = await LocationManager.getLocationFromDevice();
      if (position != null) {
        initialLocation = LatLng(position.latitude, position.longitude);
      } else {
        throw Exception('Can not get location');
      }
    } catch (e) {
      initialLocation = defaultLatLng;
    }
    final marker =
        Marker(markerId: MarkerId('location'), position: initialLocation!);
    mapMarkers.add(marker);
    emit(SelectLocationInitStates());
  }

  void pickLocation(LatLng latLng) {
    if (LocationManager.currentLocationFromDevice != null) {
      final distance = Geolocator.distanceBetween(
          latLng.latitude,
          latLng.longitude,
          LocationManager.currentLocationFromDevice!.latitude,
          LocationManager.currentLocationFromDevice!.longitude);
      if (distance > 50) {
        showSnackBar(
            "عفوا اقصي مسافة ٥٠ متر عن نقطة تواجدك, النقطة المختارة تبعد : ${distance.toStringAsFixed(2)} متر",
            errorMessage: true);
        return;
      }
    }
    final marker = Marker(markerId: MarkerId('location'), position: latLng);
    mapMarkers.clear();
    mapMarkers.add(marker);
    emit(SelectLocationInitStates());
  }

  void updateLocation() async {
    emit(SelectLocationLoadingStates());
    try {
      final marker = mapMarkers.first;
      await LocationManager.setLocation(marker.position);
      RouteManager.navigateAndPopAll(NavBarView());
    } catch (e) {
      showInternetErrorMessage();
      emit(SelectLocationInitStates());
    }
  }
}
