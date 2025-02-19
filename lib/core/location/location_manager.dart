import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/location/location_info_model.dart';
import 'package:silah/widgets/snack_bar.dart';

import '../../constants.dart';

class LocationManager {
  static LatLng? currentLocationFromServer;
  static LatLng? currentLocationFromDevice;
  static LocationInfoModel? locationInfoModel;
  // static Location location = new Location();
  // static Geolocator location = Geolocator;

  static Future<Position?> getLocationFromDevice() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showLocationErrorBar();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showLocationErrorBar();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showLocationErrorBar();
      }
      print("getLocationFromDeviceFailure");

      final position = await Geolocator.getCurrentPosition();
      currentLocationFromDevice = LatLng(
          position.latitude ?? defaultLatLng.latitude,
          position.longitude ?? defaultLatLng.longitude);
      debugPrint(
          "getLocationFromDevice${position.latitude} ${position.longitude}");

      return position;
    } catch (e) {}
    return null;
  }

  static Future<bool> setLocation([LatLng? latLng]) async {
    try {
      Position? position;

      if (latLng == null) position = await getLocationFromDevice();

      currentLocationFromServer = LatLng(position?.latitude ?? latLng!.latitude,
          position?.longitude ?? latLng!.longitude);
      final city = await getCityByLatLng(
        latitude: position?.latitude ?? latLng!.latitude,
        longitude: position?.longitude ?? latLng!.longitude,
        onlyCity: false,
      );
      final response = await DioHelper.post(
        AppStorage.isStore
            ? 'provider/account/set_location'
            : 'customer/account/set_location',
        data: {
          "customer_id": AppStorage.customerID,
          "loc_lat": position?.latitude ?? latLng!.latitude,
          "loc_long": position?.longitude ?? latLng!.longitude,
          'city': city,
        },
      );
      if (response.data['success']) {
        return true;
      }
    } catch (e, s) {
      debugPrint("$e $s");
    }
    showLocationErrorBar();
    return false;
  }

  static void showLocationErrorBar() =>
      showSnackBar('غير قادر علي تحديد موقعك!', errorMessage: true);

  static Future<String> getCityByLatLng({
    required double latitude,
    required double longitude,
    bool onlyCity = false,
  }) async {
    String location = "";
    String neighborhood = "";
    print("datagoogleapis");

    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$MAP_API_KEY&language=ar';
    try {
      final response = await Dio().post(url);
      // print("datagoogleapis ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        print("datagoogleapis $data");
        if (data['results'] != null && data['results'].length > 0) {
          final locality = data['results'] as List;

          // final locality = data['results'][2]['address_components'] as List;
          // final subLocality = data['results'][2]['address_components'] as List;
          for (var i = 0; i < locality.length; i++) {
            final locationName =
                data['results'][i]['address_components'] as List;
            for (var component in locationName) {
              List<String> types = List<String>.from(component['types']);
              if (types.contains('locality')) {
                location = component['long_name'];
                print("location--- $location");
                break;
              }
            }
            if (location.isNotEmpty) {
              break;
            }
          }
          for (var i = 0; i < locality.length; i++) {
            final locationName =
                data['results'][i]['address_components'] as List;
            for (var component in locationName) {
              List<String> types = List<String>.from(component['types']);

              if (types.contains('sublocality')) {
                neighborhood = component['long_name'];
                print("neighborhood--- $neighborhood");
              }
              if (neighborhood.isNotEmpty) {
                break;
              }
            }
            if (neighborhood.isNotEmpty) {
              break;
            }
            for (var component in locationName) {
              List<String> types = List<String>.from(component['types']);

              if (types.contains('neighborhood')) {
                neighborhood = component['long_name'];
                print("neighborhood--- $neighborhood");
              }
              if (neighborhood.isNotEmpty) {
                break;
              }
            }
            if (neighborhood.isNotEmpty) {
              break;
            }
            for (var component in locationName) {
              List<String> types = List<String>.from(component['types']);

              if (types.contains('administrative_area_level_1')) {
                neighborhood = component['long_name'];
                print("neighborhood--- $neighborhood");
              }
              if (neighborhood.isNotEmpty) {
                break;
              }
            }
            if (neighborhood.isNotEmpty) {
              break;
            }
          }
          // First, try to find locality

          // for (var component in locality) {
          //   if (component['types'].contains("locality")) {
          //     location = component['long_name'];
          //   }
          // }
          print("location $location");

          // for (var component in locality) {
          //   if (component['types'].contains("sublocality_level_1")) {
          //     neighborhood = component['long_name'];
          //   }
          // }
          print("neighborhood $neighborhood");

          // for (var component in subLocality) {
          //   if (component['types'].contains("sublocality_level_1")) {
          //     neighborhood = component['long_name'];
          //   }
          // }
          // If locality not found, try administrative_area_level_1
          if (location.isEmpty) {
            for (var component in locality) {
              if (component['types']
                  .join("")
                  .contains("administrative_area_level_1")) {
                location = component['long_name'];
                break;
              }
            }
          }

          // If still empty, try administrative_area_level_2
          if (location.isEmpty) {
            for (var component in locality) {
              if (component['types']
                  .join("")
                  .contains("administrative_area_level_2")) {
                location = component['long_name'];
                break;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error getting city: $e");
    }
    debugPrint("Error getting city: $location $neighborhood");

    // Return the location if found, otherwise return "غير معروف"
    return location.isNotEmpty ? "$location,$neighborhood" : "غير معروف";
  }

  static Future<bool> isLocationAssigned() async {
    if (!AppStorage.isLogged) {
      try {
        final position = await getLocationFromDevice();
        currentLocationFromServer =
            LatLng(position!.latitude ?? 0, position.longitude ?? 0);
      } catch (e) {
        currentLocationFromServer = defaultLatLng;

        //
      }
      return true;
    }
    final Map<String, dynamic> data = {
      'customer_id': AppStorage.getUserModel()?.customerId,
    };
    try {
      final response = await DioHelper.post(
          AppStorage.isStore
              ? 'provider/account/get_location'
              : 'customer/account/get_location',
          data: data);
      final locationInfo = response.data['location_info'];
      final responseCity = locationInfo['city'] as String?;
      locationInfoModel = LocationInfoModel.fromJson(response.data);
      currentLocationFromServer = LatLng(double.parse(locationInfo['loc_lat']),
          double.parse(locationInfo['loc_long']));
      return responseCity != null;
    } catch (e) {
      return false;
    }
  }
}
