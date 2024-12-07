import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/customer_groups/cubit/states.dart';
import 'package:silah/core/customer_groups/model.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';

class CustomerGroupsCubit extends Cubit<CustomerGroupsState> {
  CustomerGroupsCubit() : super(CustomerGroupsInitState());

  static CustomerGroupsCubit of(context) => BlocProvider.of(context);

  CustomerGroupsModel? customerGroupsModel;

  Future<void> getCustomGroup() async {
    emit(CustomerGroupsInitState());
    try {
      final response = await DioHelper.post('customer/account/customer_groups');
      customerGroupsModel = CustomerGroupsModel.fromJson(response.data);
      emit(CustomerGroupsInitState());
    } catch (e, s) {
      // emit(HomeErrorState(e.toString()));
    }
  }
}
