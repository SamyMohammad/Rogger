import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/cities/cubit/states.dart';
import 'package:silah/core/cities/model.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';

class CitiesCubit extends Cubit<CitiesStates> {
  CitiesCubit() : super(CitiesInitState());

  static CitiesCubit of(context) => BlocProvider.of(context);
  CitiesModel? citiesModel;

  Future<void> getCities() async {
    emit(CitiesLoadingState());
    try {
      final response = await DioHelper.post('customer/account/cities');
      citiesModel = CitiesModel.fromJson(response.data);
      emit(CitiesInitState());
    } catch (e) {
      // emit(HomeErrorState(e.toString()));
    }
  }
}
