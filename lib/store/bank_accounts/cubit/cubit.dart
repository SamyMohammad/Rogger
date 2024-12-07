import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/store/bank_accounts/cubit/states.dart';
import 'package:silah/store/bank_accounts/model.dart';
import 'package:silah/widgets/snack_bar.dart';

class BankCubit extends Cubit<BankStates> {
  BankCubit() : super(BankInitState());

  static BankCubit of(context) => BlocProvider.of(context);

  int? customerId = AppStorage.customerID;
  BankModel? bankModel;

  Future<void> getBankData() async {
    emit(BankLoadingState());
    try {
      final response = await DioHelper.post('provider/banks/banks_list', data: {
        "customer_id": customerId,
      });
      final data = response.data;
      bankModel = BankModel.fromJson(data);
      //
      //
    } catch (e) {
      emit(BankErrorState(e.toString()));
    }
    emit(BankInitState());
  }

  Future<void> deleteBank(int index) async {
    final bank = bankModel!.banks![index];
    try {
      final response = await DioHelper.post('family/banks/delete',
          data: {"customer_id": customerId, "bank_id": bank.bankId});
      if (response.data.containsKey('success')) {
        showSnackBar('تم الحذف!');
        bankModel!.banks!.remove(bank);
        emit(BankInitState());
      }
    } catch (e) {
      emit(BankErrorState(e.toString()));
    }
    emit(BankInitState());
  }
}
