import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/location/location_info_model.dart';
import 'package:silah/widgets/snack_bar.dart';

import '../../constants.dart';

class LocationManager {
  static LatLng? currentLocationFromServer;
  static LatLng? currentLocationFromDevice;
  static LocationInfoModel? locationInfoModel;
  static Location location = new Location();

  static Future<LocationData?> getLocationFromDevice() async {
    bool serviceEnabled;
    PermissionStatus permission;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        showLocationErrorBar();
      }

      permission = await location.hasPermission();
      if (permission == LocationPermission.denied) {
        permission = await location.requestPermission();
        if (permission == LocationPermission.denied) {
          showLocationErrorBar();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showLocationErrorBar();
      }
      final position = await location.getLocation();
      currentLocationFromDevice = LatLng(
          position.latitude ?? defaultLatLng.latitude,
          position.longitude ?? defaultLatLng.longitude);
      debugPrint(
          "getLocationFromDevice${position.latitude} ${position.longitude}");

      return position;
    } catch (e) {
    }
    return null;
  }

  static Future<bool> setLocation([LatLng? latLng]) async {
    try {
      LocationData? position;
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
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$MAP_API_KEY&language=ar';
    try {
      final response = await Dio().post(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['results'] != null && data['results'].length > 0) {
          final result = data['results'][0]['address_components'] as List;
          
          // First, try to find locality
          for (var component in result) {
            if (component['types'].join("").contains("locality")) {
              location = component['long_name'];
              break;
            }
          }
          
          // If locality not found, try administrative_area_level_1
          if (location.isEmpty) {
            for (var component in result) {
              if (component['types'].join("").contains("administrative_area_level_1")) {
                location = component['long_name'];
                break;
              }
            }
          }
          
          // If still empty, try administrative_area_level_2
          if (location.isEmpty) {
            for (var component in result) {
              if (component['types'].join("").contains("administrative_area_level_2")) {
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
    
    // Return the location if found, otherwise return "غير معروف"
    return location.isNotEmpty ? location : "غير معروف";
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
      return responseCity != null ;
    } catch (e) {
      return false;
    }
  }
}
