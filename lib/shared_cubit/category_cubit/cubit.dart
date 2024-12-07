import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared/category_details/category_products_model.dart';
import 'package:silah/shared_cubit/category_cubit/states.dart';
import 'package:silah/shared_models/categories_model.dart';
import 'package:silah/shared_models/sub_categories_model.dart';

import '../../constants.dart';

class CategoryCubit extends Cubit<CategoryStates> {
  CategoryCubit() : super(CategoryInitState());

  static CategoryCubit of(context) => BlocProvider.of(context);

  CategoriesModel? categoriesModel;
  CategoriesModel? paidCategoriesModel;
  CategoryProductsModel? categoryProductsModel;
  GetSubCategory? getSubCategory;
  List<Categories> subCategories = [];
  Category? selectedCategory;
  Categories? selectedSubCategory;
  File? selectedCopyOfTransferImage;
  bool isSubCategoryShow = false;

  void init(String categoryId, bool nearestAds) async {
    await getCategories();
    // await getSubCategories(categoryId);
    await getCategoryProducts(categoryId, nearestAds);
  }

  bool isValid = false;
  void checkInputsValidity() {
    print('selectedCategory : ${selectedCategory?.name}' +
        ' selectedSubCategory : ${selectedSubCategory?.name}' +
        ' selectedCopyOfTransferImage : $selectedCopyOfTransferImage');
    if (selectedCategory != null &&
        selectedSubCategory != null &&
        selectedCopyOfTransferImage != null) {
      emit(ValidateState(state: true));
      return;
    }
    emit(ValidateState(state: false));
  }

  Future<FormData> _convertVerificationRequestDataToFormData() async {
    final data = {
      'customer_id': AppStorage.customerID,
      'oc_category_id': selectedCategory?.id,
      'oc_sub_category_id': selectedSubCategory?.id,
    };
    FormData formData = FormData.fromMap(data);
    if (selectedCopyOfTransferImage != null)
      formData.files.add(MapEntry('transaction_image',
          await MultipartFile.fromFile(selectedCopyOfTransferImage!.path)));

    return formData;
  }

  Future<void> requestVerificationCategory() async {
    emit(RequestVerificationLoadingState());
    final formData = await _convertVerificationRequestDataToFormData();
    try {
      final response = await DioHelper.post(
          'customer/account/create_categort_subscription',
          formData: formData);

      if (response.data.containsKey('success')) {
        emit(RequestVerificationSucessState(response.data));
      } else {
        emit(RequestVerificationErrorState(response.data));
        throw Exception(response.data);
      }
      // if (response.data['success']) {
      //   closeKeyboard();
      //   RouteManager.pop();
      //   showSnackBar('تمت الإضافة!', duration: 7);
      // } else {
      //   throw Exception(response.data);
      // }
    } catch (e, s) {}
    // emit(TicketsInitState());
  }

  Future<void> getCategories() async {
    emit(CategoryLoadingState());
    try {
      final response = await DioHelper.post('common/category/main_categories');
      final data = response.data;

      categoriesModel = CategoriesModel.fromJson(data);
      // categoriesModel.categories[0].
      emit(CategoryInitState());
    } catch (e) {
      emit(CategoryErrorState(e.toString()));
    }
  }

  Future<void> getPaidCategories() async {
    emit(CategoryLoadingState());
    try {
      final response = await DioHelper.post('common/category/paid_categories');
      final data = response.data;

      paidCategoriesModel = CategoriesModel.fromJson(data);
      // categoriesModel.categories[0].
      emit(CategoryInitState());
    } catch (e) {
      emit(CategoryErrorState(e.toString()));
    }
  }

  Future<void> getSubCategories(String? id) async {
    emit(GetSubCategoriesLoadingState());
    try {
      final data = <String, dynamic>{
        'category_id': id,
      };
      final response =
          await DioHelper.post('common/category/sub_categories', data: data);

      getSubCategory = GetSubCategory.fromJson(response.data);
      subCategories = getSubCategory?.categories ?? [];

      isSubCategoryShow = subCategories.isNotEmpty;
      emit(GetSubCategoriesSuccessState());
    } catch (e) {
      emit(GetSubCategoriesErrorState(e.toString()));
    }
  }

  Future<void> getCategoryProducts(String id, bool nearestAds) async {
    _canGetMoreProducts = true;
    emit(CategoryLoadingState());

    try {
      final data = {
        'start': 0,
        'limit': PAGINATE_BY,
        'customer_id': AppStorage.getUserModel()?.customerId,
        'customer_group_id': AppStorage.getUserModel()?.customerGroup,
        'category_id': id,
        "location_status": nearestAds ? "1" : "0",
      };

      final response = await DioHelper.post('common/category', data: data);

      categoryProductsModel = CategoryProductsModel.fromJson(response.data);
      emit(CategoryInitState());
    } catch (e) {
      emit(CategoryErrorState(e.toString()));
    }
  }

  bool _canGetMoreProducts = true;

  Future<void> getMoreProductsData(ScrollNotification notification,
      String categoryID, bool nearestAds) async {
    if (notification.metrics.extentAfter == 0 && _canGetMoreProducts) {
      emit(CategoryMoreLoadingState());
      try {
        final response = await DioHelper.post(
          'common/category',
          data: {
            'start': categoryProductsModel?.products?.length,
            'limit': categoryProductsModel!.products!.length + PAGINATE_BY,
            'customer_id': AppStorage.customerID,
            'customer_group_id': AppStorage.getUserModel()?.customerGroup ?? 1,
            "location_status": nearestAds ? "1" : "0",
            "category_id": categoryID,
          },
        );
        final data = response.data;
        final moreHomeProductsModel = CategoryProductsModel.fromJson(data);
        categoryProductsModel?.products
            ?.addAll(moreHomeProductsModel.products!);
      } catch (e) {
        _canGetMoreProducts = false;
      }
      emit(CategoryInitState());
    }
  }
}
