import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/user/favourite/cubit/states.dart';
import 'package:silah/user/favourite/model.dart';

class FavouriteCubit extends Cubit<FavouriteStates> {
  FavouriteCubit() : super(FavouriteInitStates());

  static FavouriteCubit of(context) => BlocProvider.of(context);

  FavouriteModel? favouriteModel;

  Future<void> getFavourites() async {
    emit(FavouriteLoadingStates());
    try {
      final response = await DioHelper.post('common/product/wishlist', data: {
        "logged": true,
        "customer_id": AppStorage.customerID,
        "start": 0,
        "limit": 1000,
      });
      final data = response.data;
      favouriteModel = FavouriteModel.fromJson(data);
      // print(data);
      emit(FavouriteInitStates());
    } catch (e) {
      emit(FavouriteErrorStates(e.toString()));
    }
  }
}
