import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/nav_bar/view.dart';
import 'package:silah/shared/product_details/cubit/states.dart';
import 'package:silah/shared/product_details/model.dart';
import 'package:silah/widgets/snack_bar.dart';

class ProductsDetailsCubit extends Cubit<ProductsDetailsStates> {
  ProductsDetailsCubit(this.productId) : super(ProductsDetailsInitState());

  final String? productId;
  static ProductsDetailsCubit of(context) => BlocProvider.of(context);
  ProductsDetailsModel? productsDetailsModel;
  Future<void> getProductsDetails() async {
    emit(ProductsDetailsLoadingState());
    try {
      final response = await DioHelper.post('common/product', data: {
        "product_id": productId,
        "customer_id": AppStorage.customerID
      });
      final data = response.data;
      print(data);
      productsDetailsModel = ProductsDetailsModel.fromJson(data);
      if (productsDetailsModel?.video != null &&
          productsDetailsModel!.video!.isNotEmpty) {
        productsDetailsModel!.productImages!.add("VIDEO");
      }
      emit(ProductsDetailsInitState());
    } catch (e) {
      emit(ProductsDetailsErrorState(e.toString()));
    }
  }

  Future<void> toggleFavorite(
      {bool inWishlist = false,
      BaseModel? baseModel,
      String? productId}) async {
    try {
      final response = await DioHelper.post(
          baseModel?.inWishlist ?? inWishlist
              ? 'common/product/wishlist_add'
              : 'common/product/wishlist_delete',
          data: {
            'logged': 'true',
            'customer_id': AppStorage.customerID,
            'product_id': productId ?? this.productId,
          });
      // showSnackBar(response.data['message']);
    } catch (e) {
      print(e);
      showSnackBar(e.toString());
    }
  }

  Future<void> deleteProduct() async {
    try {
      final response = await DioHelper.post(
        'provider/products/delete',
        data: {
          "customer_id": AppStorage.customerID,
          "product_id": productId,
        },
      );
      final data = response.data;
      if (data.containsKey('success')) {
        showSnackBar('تم حذف المنتج بنجاح!');
        RouteManager.navigateTo(NavBarView());
        emit(ProductsDetailsInitState());
      }
    } catch (e) {
      print(e.toString());
      emit(ProductsDetailsErrorState(e.toString()));
    }
    emit(ProductsDetailsInitState());
  }

  Future<void> refreshProduct() async {
    final response = await DioHelper.post(
      'provider/products/renew_product',
      data: {
        "customer_id": AppStorage.customerID,
        "product_id": productId,
      },
    );
    if (response.data['message'] != null) {
      showSnackBar(
        response.data['message'],
        errorMessage: true,
      );
    } else {
      showSnackBar('تم تحديث الاعلان');
    }
  }
}
