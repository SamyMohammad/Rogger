import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/location/location_manager.dart';
import 'package:silah/store/change_map_activity/states.dart';
import 'package:silah/user/advertisers_on_map/map_categories_model.dart';
import 'package:silah/widgets/snack_bar.dart';

class ChangeMapActivityCubit extends Cubit<ChangeMapActivityStates> {
  ChangeMapActivityCubit() : super(ChangeMapActivityInitState());

  static ChangeMapActivityCubit of(context) => BlocProvider.of(context);

  Set<Marker> mapMarkers = {
    Marker(
        markerId: MarkerId('v'),
        position: LocationManager.currentLocationFromServer!),
  };

  MapCategoriesModel? mapCategoriesModel;
  MapCategory? selectedMapCategory;
  Future<void> getMapCategories() async {
    if (!AppStorage.isStore) {
      return;
    }
    try {
      final response = await DioHelper.post('provider/account/map_categories');
      mapCategoriesModel = MapCategoriesModel.fromJson(response.data);

      selectedMapCategory =
          (mapCategoriesModel?.mapCategories ?? []).firstWhere((element) {
        return element.id == AppStorage.getUserModel()?.mapCategoryID;
      });
    } catch (e) {}
    emit(ChangeMapActivityInitState());
  }

  Future<void> updateMapCategory(int mapCategoryId) async {
    if (!AppStorage.isStore) {
      return;
    }

    try {
      final response =
          await DioHelper.post('customer/account/update_map_category', data: {
        'map_category_id': mapCategoryId,
        'customer_id': AppStorage.customerID,
      });

      AppStorage.cacheUser(
          AppStorage.getUserModel()!..mapCategoryID = mapCategoryId);
      // getMapCategories();
      // mapCategoriesModel = MapCategoriesModel.fromJson(response.data);
      // selectedMapCategory = (mapCategoriesModel?.mapCategories ?? [])
      //     .firstWhere((element) =>
      //         element.id == AppStorage.getUserModel()?.mapCategoryID);
    } catch (e) {}
    emit(ChangeMapActivityInitState());
  }

  void toggleActivityStatus(bool v) async {
    LocationManager.locationInfoModel?.locationInfo?.locActive = v ? "1" : '0';
    emit(ChangeMapActivityLoadingState());
    final data = {
      'customer_id': AppStorage.getUserModel()?.customerId,
      'loc_active': LocationManager.locationInfoModel?.locationInfo?.locActive,
    };
    try {
      final response = await DioHelper.post(
          'provider/account/location_activity',
          data: data);
      if (response.data['success']) {
        showSnackBar(v ? 'تم التشغيل' : "تم الإغلاق");
      } else {
        throw Exception();
      }
    } catch (e) {
      showSnackBar('فشل تعديل الحالة');
    }
    emit(ChangeMapActivityInitState());
  }
}
