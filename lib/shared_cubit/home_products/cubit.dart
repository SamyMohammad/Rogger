import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared_cubit/home_products/states.dart';
import 'package:silah/shared_models/home_products_model.dart';

class HomeProductsCubit extends Cubit<HomeProductsStates> {
  HomeProductsCubit() : super(HomeProductsInitState());

  static HomeProductsCubit of(context) => BlocProvider.of(context);

  HomeProductsModel? homeProductsModel;

  String? selectedCategoryID;
  bool nearestAds = false;

  void selectCategory(String? id) {
    selectedCategoryID = id;
    _canGetMoreProducts = true;
    emit(HomeProductsInitState());
  }

  Future<void> getHomeProductsData() async {
    emit(HomeProductsLoadingState());

    try {
      Map<String, dynamic>? requestData = {
        'start': 0,
        'limit': PAGINATE_BY,
        'customer_id': AppStorage.customerID,
        'customer_group_id': AppStorage.getUserModel()?.customerGroup ?? 1,
        "location_status": nearestAds ? 1 : 0,
      };
      print('requestData:getHomeProductsData $requestData');
      final response =
          await DioHelper.post('common/home/get_latest_ads', data: requestData);
      print('getHomeProductsData$response');

      final data = response.data;
      print('getHomeProductsData$data');

      homeProductsModel = HomeProductsModel.fromJson(data);
      emit(HomeProductsInitState());
    } catch (e) {
      print('getHomeProductsData${e.toString()}');
      emit(HomeProductsErrorState(e.toString()));
    }
  }

  bool isUserBanned = false;
  Future<void> checkIfUserBanned() async {
    try {
      Map<String, dynamic>? requestData = {
        'customer_id': AppStorage.customerID,
      };
      print('requestData: _______$requestData');
      final response = await DioHelper.post('customer/account/block_status',
          data: requestData);
      print('checkIfUserBanned$response');
      print('checkIfUserBanned${AppStorage.customerID}');

      final data = response.data;
      print('checkIfUserBanned$data');

      isUserBanned = data['is_banned'] ?? false;
      emit(IsUserBannedState(isUserBanned));
    } catch (e) {
      print('checkIfUserBanned${e.toString()}');

      emit(HomeProductsErrorState(e.toString()));
    }
  }

  bool _canGetMoreProducts = true;

  Future<void> getMoreHomeProductsData(ScrollNotification notification) async {
    if (notification.metrics.extentAfter == 0 && _canGetMoreProducts) {
      emit(HomeProductsMoreLoadingState());
      try {
        final response = await DioHelper.post(
          'common/home/get_latest_ads',
          data: {
            'start': homeProductsModel?.products?.length,
            'limit': homeProductsModel!.products!.length + PAGINATE_BY,
            'customer_id': AppStorage.customerID,
            'customer_group_id': AppStorage.getUserModel()?.customerGroup ?? 1,
            'location_status': nearestAds ? 1 : 0,
          },
        );
        final data = response.data;
        final moreHomeProductsModel = HomeProductsModel.fromJson(data);
        homeProductsModel?.products?.addAll(moreHomeProductsModel.products!);
      } catch (e) {
        _canGetMoreProducts = false;
      }
      emit(HomeProductsInitState());
    }
  }
}
