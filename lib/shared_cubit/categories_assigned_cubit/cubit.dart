// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:silah/core/app_storage/app_storage.dart';
// import 'package:silah/core/dio_manager/dio_manager.dart';
// import 'package:silah/shared_cubit/categories_assigned_cubit/states.dart';
// import 'package:silah/shared_models/categories_assigned_model.dart';
//
// class CategoryAssignedCubit extends Cubit<CategoryAssignedStates> {
//   CategoryAssignedCubit() : super(CategoryAssignedInitState());
//
//   static CategoryAssignedCubit of(context) => BlocProvider.of(context);
//
//   CategoryAssignedModel? categoryAssignedModel;
//
//   Future<void> getCategoryAssignedData() async {
//     emit(CategoryAssignedLoadingState());
//     try{
//       final response = await DioHelper.post('provider/products/product_list',
//           data: {
//             "customer_id" : AppStorage.getUserModel()!.customerId,
//           });
//       final data = response.data;
//       categoryAssignedModel = CategoryAssignedModel.fromJson(data);
//       // print(data);
//       emit(CategoryAssignedInitState());
//     }catch(e){
//       emit(CategoryAssignedErrorState(e.toString()));
//     }
//   }
//
//
// }
