// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:silah/core/app_storage/app_storage.dart';
// import 'package:silah/core/dio_manager/dio_manager.dart';
// import 'package:silah/shared_cubit/categories_assigned_cubit/states.dart';
// import 'package:silah/shared_cubit/product_cubit/states.dart';
// import 'package:silah/shared_models/categories_assigned_model.dart';
// import 'package:silah/shared_models/products_model.dart';
//
// class ProductCubit extends Cubit<ProductStates> {
//   ProductCubit() : super(ProductInitState());
//
//   static ProductCubit of(context) => BlocProvider.of(context);
//
//   ProductsModel? productsModel;
//   CategoryAssignedModel? categoryAssignedModel;
//
//
//   Future<void> getCategoryProducts(String categoryId) async {
//     emit(ProductLoadingState());
//     try{
//       final response = await DioHelper.post('provider/products/product_list',
//           data: {
//             "customer_id" : AppStorage.getUserModel()!.customerId,
//             "category_id" : categoryId,
//             "start" :0,
//             "limit" : 10,
//           });
//       final data = response.data;
//       productsModel = ProductsModel.fromJson(data);
//       // print(categoryId);
//       // print(productsModel!.toJson());
//       print(productsModel!.productsCount);
//       emit(ProductInitState());
//     }catch(e){
//       emit(ProductErrorState(e.toString()));
//     }
//   }
//
//   Future<void> getCategoryAssignedData() async {
//     emit(ProductLoadingState());
//     try{
//       final response = await DioHelper.post('provider/products/assigned_categories',
//           data: {
//             "customer_id" : AppStorage.getUserModel()!.customerId,
//           });
//       final data = response.data;
//       categoryAssignedModel = CategoryAssignedModel.fromJson(data);
//       // print(data['categories']);
//       emit(ProductInitState());
//     }catch(e){
//       emit(ProductErrorState(e.toString()));
//     }
//   }
//
// }
