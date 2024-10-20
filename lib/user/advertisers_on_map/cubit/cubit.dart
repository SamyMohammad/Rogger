import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/location/location_manager.dart';
import 'package:silah/user/advertisers_on_map/cubit/states.dart';
import 'package:silah/user/advertisers_on_map/map_categories_model.dart';
import 'package:silah/user/advertisers_on_map/model.dart';

class AdvertisersOnMapCubit extends Cubit<AdvertisersOnMapStates> {
  AdvertisersOnMapCubit() : super(AdvertisersOnMapInitStates());

  static AdvertisersOnMapCubit of(context) => BlocProvider.of(context);
  AdvertisersOnMapModel? advertisersOnMapModel;
  MapCategoriesModel? mapCategoriesModel;
  MapCategory? selectedMapCategory;
  late GoogleMapController googleMapController;

  // Set<Marker> mapMarkers = {};

  Future<void> getAdvertisers() async {
    try {
      advertisersOnMapModel = null;
      emit(AdvertisersOnMapLoadingStates());
      await getMapCategories();
      if (selectedMapCategory == null) {
        selectedMapCategory = mapCategoriesModel!.mapCategories!.first;
      }
      final response =
          await DioHelper.post('customer/account/get_advertizers', data: {
        "map_category_id": selectedMapCategory?.id ?? 0,
      });
      print('map_category_id$response');
      final data = response.data;
      print('AdvertisersOnMapLoadingStates$data');

      advertisersOnMapModel = AdvertisersOnMapModel.fromJson(data);
      print(
          'AdvertisersOnMapLoadingStatesName${advertisersOnMapModel?.advertizers?.first.nickname}');
      // final markerIcon = await getMapIcon('enabled-marker');
      // advertisersOnMapModel?.advertizers?.forEach((element) {
      //   final marker = Marker(
      //     markerId: MarkerId(element.advertizerId!),
      //     position: element.location!,
      //     icon: markerIcon,
      //     infoWindow: InfoWindow(
      //       title: element.nickname ?? '',
      //       onTap: () => RouteManager.navigateTo(StoreProfileView(storeId: element.advertizerId!,))
      //     ),
      //   );
      //   mapMarkers.add(marker);
      // });
      emit(AdvertisersOnMapLoadedStates());
    } catch (e) {
      emit(AdvertisersOnMapErrorStates(e.toString()));
    }
    // await Future.delayed(Duration(milliseconds: 500));
    // emit(AdvertisersOnMapInitStates());
  }

  Future<void> getMapCategories() async {
    final all = {
      "map_category_id": 0,
      "name": 'الكل',
      "image": '',
    };
    try {
      final response = await DioHelper.post('provider/account/map_categories');
      response.data['map_categories'].insert(0, all);
      mapCategoriesModel = MapCategoriesModel.fromJson(response.data);
    } catch (e) {}
  }

  void toggleMapCategory(MapCategory? category) {
    if (selectedMapCategory?.id == category?.id) {
      return;
    } else {
      selectedMapCategory = category;
    }
    emit(AdvertisersOnMapInitStates());
    getAdvertisers();
  }

  void showCurrentLocation() async {
    final position = await LocationManager.getLocationFromDevice();
    googleMapController.animateCamera(CameraUpdate.newLatLng(position == null
        ? defaultLatLng
        : LatLng(position.latitude ?? defaultLatLng.latitude,
            position.longitude ?? defaultLatLng.longitude)));
  }

  @override
  Future<void> close() {
    googleMapController.dispose();
    return super.close();
  }
}

/*
      // advertisersOnMapModel?.advertizers?.forEach((element) {
      //   final marker = Marker(
      //     markerId: MarkerId(element.advertizerId!),
      //     position: element.location!,
      //     icon: markerIcon,
      //     infoWindow: InfoWindow(
      //       title: element.nickname ?? '',
      //       onTap: () => RouteManager.navigateTo(StoreProfileView(storeId: element.advertizerId!,))
      //     ),
      //   );
      //   mapMarkers.add(marker);
      // });
            final http.Response r = await http.get(Uri.parse('https://www.w3schools.com/css/img_lights.jpg'));
      final marker = BitmapDescriptor.fromBytes(r.bodyBytes);
 */
