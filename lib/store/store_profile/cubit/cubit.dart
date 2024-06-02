import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared_models/categories_assigned_model.dart';
import 'package:silah/shared_models/products_model.dart';
import 'package:silah/store/store_profile/comments_model.dart';
import 'package:silah/store/store_profile/cubit/states.dart';
import 'package:silah/store/store_profile/get_rate/get_rate.dart';
import 'package:silah/store/store_profile/store_info_model.dart';
import 'package:silah/widgets/snack_bar.dart';

import '../../../user/followers/cubit/cubit.dart';
import '../../../user/followers/model.dart';

class StoreProfileCubit extends Cubit<StoreProfileStates> {
  StoreProfileCubit({required this.storeId}) : super(StoreProfileInitState());

  final String storeId;
  static StoreProfileCubit of(context) => BlocProvider.of(context);

  ProductsModel? productsModel;
  CategoryAssignedModel? categories;
  String? selectedCategory;
  StoreInfoModel? storeInfoModel;
  bool isFollowing = false;
  CommentsModel? commentsModel;
  GetRate? getRateModel;
  Future<void> init() async {
    emit(StoreProfileLoadingState());
    await getStoreInfo();
    await getOverAllRate();

    await getCategories();
    await getComments();
    await getRate();
    await getOverAllRate();
    await getStatusVerified();
    await getCategoryProducts(
        categories?.categories?.first.categoryId ?? '', false);
    if (categories != null && categories!.categories!.isNotEmpty) {
      await getCategoryProducts(
          categories!.categories!.first.categoryId!, false);
    }
    await getFollowingStatus();
    emit(StoreProfileInitState());
  }

  Future<void> getStoreInfo() async {
    final response = await DioHelper.post(
      'provider/account/account',
      data: {
        "logged": true,
        "customer_id": storeId,
      },
    );
    final data = response.data;
    print('getStoreInfo $data');
    storeInfoModel = StoreInfoModel.fromJson(data);
  }

  Future<void> getStatusVerified() async {
    final response = await DioHelper.post(
      'customer/account/get_customer_verfication',
      data: {
        'customer_id': storeId,
      },
    );
    final data = response.data;
    print('getStatusVerified $data');
    // storeInfoModel = StoreInfoModel.fromJson(data);
  }

  Future<void> getCategoryProducts(String categoryId,
      [bool rebuild = true]) async {
    if (rebuild) emit(StoreProfileLoadingState());
    selectedCategory = categoryId;
    try {
      final response =
          await DioHelper.post('provider/products/product_list', data: {
        "customer_id": storeId,
        "category_id": categoryId,
        "start": 0,
        "limit": 1000,
      });
      final data = response.data;
      log(data.toString());
      productsModel = ProductsModel.fromJson(data);
    } catch (e) {
      emit(StoreProfileErrorState(e.toString()));
    }
    if (rebuild) emit(StoreProfileInitState());
  }

  Future<void> getCategories() async {
    emit(StoreProfileLoadingState());
    try {
      final response =
          await DioHelper.post('provider/products/assigned_categories', data: {
        "customer_id": storeId,
      });
      final data = response.data;
      categories = CategoryAssignedModel.fromJson(data);
      if (categories!.categories!.isEmpty) {
        throw Exception();
      }
      // print(data['categories']);
    } catch (e) {}
    emit(StoreProfileInitState());
  }

  Future<void> getComments() async {
    emit(StoreProfileLoadingState());
    try {
      final response =
          await DioHelper.post('customer/account/customer_comments', data: {
        "customer_id": AppStorage.getUserModel()?.customerId,
        'advertizer_id': storeId,
      });
      final data = response.data;
      commentsModel = CommentsModel.fromJson(data);
      print('customer/account/customer_comments$data');
      if (commentsModel!.data!.isEmpty) {
        throw Exception();
      }
      // print(data['categories']);
    } catch (e) {}
    emit(StoreProfileInitState());
  }

  String? getOverAllRating;
  Future<void> getOverAllRate() async {
    // emit(GetRateLoadingState());
    try {
      final response =
          await DioHelper.post('customer/account/advretiser_rating', data: {
        "customer_id": storeId,
      });
      final data = response.data;
      print('getOverAllRating$data');
      if (data.containsKey('success')) {
        getOverAllRating = data['rating'];
        print('getOverAllRating$data');
      } else {
        print('getOverAllRatingError $data');

        throw Exception();
      }
      // print(data['categories']);
    } catch (e) {}
    emit(StoreProfileInitState());
  }

  Future<void> getRate() async {
    emit(GetRateLoadingState());
    try {
      final response =
          await DioHelper.post('customer/account/fetch_rating', data: {
        "customer_id": AppStorage.getUserModel()?.customerId,
        'advertizer_id': storeId,
      });

      final data = response.data;

      if (data['success'] == true) {
        print('getRateModelInGetRateSuccess$data');

        getRateModel = GetRate.fromJson(data);
      }
      print('getRateModelInGetRate${getRateModel?.rating?.rating.toString()}');
      if (getRateModel?.rating?.rating == null) {
        throw Exception();
      }
      // print(data['categories']);
    } catch (e) {}
    // emit(GetRateInitState());
  }

  Future<void> addRate() async {
    emit(StoreProfileLoadingState());
    try {
      final response =
          await DioHelper.post('customer/account/fetch_rating', data: {
        "customer_id": AppStorage.getUserModel()?.customerId,
        'advertizer_id': storeId,
      });
      final data = response.data;
      getRateModel = GetRate.fromJson(data);
      print(data.toString());
      if (getRateModel?.rating?.rating == null) {
        throw Exception();
      }
      // print(data['categories']);
    } catch (e) {}
    emit(StoreProfileInitState());
  }

  Future<void> updateRate() async {
    emit(StoreProfileLoadingState());
    try {
      final response =
          await DioHelper.post('customer/account/fetch_rating', data: {
        "customer_id": AppStorage.getUserModel()?.customerId,
        'advertizer_id': storeId,
      });
      final data = response.data;
      getRateModel = GetRate.fromJson(data);
      print(data.toString());
      if (getRateModel?.rating?.rating == null) {
        throw Exception();
      }
      // print(data['categories']);
    } catch (e) {}
    emit(StoreProfileInitState());
  }

  Future<void> followStore() async {
    isFollowing = !isFollowing;
    storeInfoModel?.totalFollowerCount =
        (int.parse(storeInfoModel!.totalFollowerCount!) +
                (isFollowing ? 1 : -1))
            .toString();
    emit(StoreProfileInitState());
    if (!isFollowing) {
      FollowersCubit().unfollowStore(FollowingList(advertizerId: storeId));
    } else {
      final response = await DioHelper.post(
        'customer/account/following_add',
        data: {
          'customer_id': AppStorage.getUserModel()?.customerId,
          'advertizer_id': storeId,
        },
      );
      if (response.data['success'] == true) {
        showSnackBar('تم متابعة ${storeInfoModel?.name} بنجاح!');
      } else {
        showSnackBar(response.data['message'], errorMessage: true);
      }
    }
  }

  Future<bool> getFollowingStatus() async {
    final response = await DioHelper.post(
      'customer/account/following_check',
      data: {
        'customer_id': AppStorage.customerID,
        'advertizer_id': storeId,
      },
    );
    isFollowing = response.data['follower'];
    return isFollowing;
  }
}
