import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared/stores/units/get_advertisers_model.dart';
import 'package:silah/shared_models/home_products_model.dart';
import 'package:silah/shared_models/sub_categories_model.dart';

import '../category_details/category_products_model.dart';
part 'states.dart';

class StoresCubit extends Cubit<StoresStates> {
  StoresCubit() : super(StoresInit());

  static StoresCubit of(context) => BlocProvider.of(context);
  bool isStoresSelected = true;
  Ads? ads;
  GetAdvertisersModel? getAdvertisersModel;
  GetSubCategory? getSubCategory;
  List<Categories> subCategories = [];
  Future<void> init() async {
    if (subCategories.isNotEmpty) {
      await getCategoryProducts(id: subCategories.first.id);
    }
    print(
        'getSubCategory!.categories!.first.id${getSubCategory?.categories?.length}');
  }
  Future<void> getSubCategories(String? id) async {
    emit(GetSubCategoriesLoadingState());
    try {
      final data = <String, dynamic>{
        'category_id': id,
      };
      final response =
          await DioHelper.post('common/category/sub_categories', data: data);
      print('GetSubCategoriesLoadingState  : ${response.data}');
      getSubCategory = GetSubCategory.fromJson(response.data);
      subCategories = getSubCategory?.categories ?? [];
      print('subCategories : $subCategories');
      await init();

      emit(GetSubCategoriesSuccessState());
    } catch (e) {
      print('GetSubCategoriesErrorState: ${e.toString()}');
    }
  }

  toggleSelection(bool state) {
    isStoresSelected = state;
    emit(StoresInit());
  }

  Future<void> getAds() async {
    emit(GetAdsLoadingState());
    try {
      final response = await DioHelper.post(
        'customer/account/vaild_ads_slider',
      );
      print('GetSubCategoriesLoadingState  : ${response.data}');
      ads = Ads.fromJson(response.data);
      // subCategories = getSubCategory?.categories??[];
      // print('subCategories : $subCategories');
      print('ads ${ads?.data}');
      emit(GetAdsSuccessState());
    } catch (e) {
      print('GetSubCategoriesErrorState  : ${e.toString()}');
      emit(GetAdsErrorState(e.toString()));
    }
  }

  Future<void> filterStores(String term, int page,
      PagingController<int, Advertisers> pagingController,
      {bool? verfied, String? type}) async {
    emit(GetAdvertisersLoadingState());
    try {
      final Map<String, dynamic> requestData = {
        'page': page,
        'limit': 10,
        'trem': term,
      };

      // Add 'verfied' to requestData if it's not null
      if (verfied != null) {
        requestData['verfied'] = verfied;
      }
      if (type != null) {
        requestData['type'] = verfied;
      }
      final response = await DioHelper.post('customer/account/advertisers',
          data: requestData);

      print('filterStores  : ${response.data}');
      getAdvertisersModel = GetAdvertisersModel.fromJson(response.data);
      // subCategories = getSubCategory?.categories??[];
      // print('subCategories : $subCategories');
      print('ads ${getAdvertisersModel?.advertisers}');
      final newItems = getAdvertisersModel?.advertisers ?? [];
      
      print('advertiser pagination ${getAdvertisersModel?.advertisers}');
      bool isLastPage = newItems.length < 10;

      if (isLastPage) {
        // 3
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = page + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
      emit(GetAdvertisersSuccessState(newItems));
    } catch (e) {
      print('filterStoresErrorState  : ${e.toString()}');
      emit(GetAdvertisersErrorState(e.toString()));
    }
  }

  HomeProductsModel? homeProductsModel;

  String? selectedCategoryID;
  bool nearestAds = false;
  CategoryProductsModel? categoryProductsModel;

  void selectCategory(String? id) {
    selectedCategoryID = id;
    emit(StoresInit());
  }

  Future<void> getCategoryProducts({
    String? id,
  } ) async {
    if (id == null) {
      id = subCategories[0].id;
    }
    try {
      final data = {
        'start': 0,
        'limit': PAGINATE_BY,
        'customer_id': AppStorage.getUserModel()?.customerId,
        'customer_group_id': AppStorage.getUserModel()?.customerGroup,
        'category_id': id,
        "location_status": "0",
      };
      final response = await DioHelper.post('common/category', data: data);
      print('common/category  : ${response.data}');
      categoryProductsModel = CategoryProductsModel.fromJson(response.data);
      emit(StoresInit());
    } catch (e) {
      print(e);
      // throw Exception(e);
    }
  }
}

class Ads {
  bool? success;
  List<Data>? data;

  Ads({this.success, this.data});

  Ads.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? adId;
  String? name;
  String? url;
  String? period;
  String? createdAt;
  String? fullImage;

  Data(
      {this.adId,
      this.name,
      this.url,
      this.period,
      this.createdAt,
      this.fullImage});

  Data.fromJson(Map<String, dynamic> json) {
    adId = json['ad_id'];
    name = json['name'];
    url = json['url'];
    period = json['period'];
    createdAt = json['created_at'];
    fullImage = json['full_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ad_id'] = this.adId;
    data['name'] = this.name;
    data['url'] = this.url;
    data['period'] = this.period;
    data['created_at'] = this.createdAt;
    data['full_image'] = this.fullImage;
    return data;
  }
}
