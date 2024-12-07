import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared/policy/cubit/states.dart';
import 'package:silah/shared/policy/model.dart';

class PolicyCubit extends Cubit<PolicyStates> {
  PolicyCubit() : super(PolicyInitState());

  static PolicyCubit of(context) => BlocProvider.of(context);

  PolicyModel? policyModel;

  Future<void> policy() async {
    emit(PolicyLoadingState());
    try {
      final response =
          await DioHelper.post('information', data: {"information_id": 5});
      final data = response.data;

      policyModel = PolicyModel.fromJson(data);
      emit(PolicyInitState());
      //
    } catch (e) {
      emit(PolicyErrorState(e.toString()));
    }
  }
}
