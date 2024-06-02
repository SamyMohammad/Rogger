import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared/black_list/cubit/states.dart';
import 'package:silah/shared/black_list/model.dart';
import 'package:silah/widgets/snack_bar.dart';

class BlackListCubit extends Cubit<BlackListStates> {
  BlackListCubit() : super(BlackListInitState());

  static BlackListCubit of(context) => BlocProvider.of(context);

  BlackListModel? blackListModel;

  Future<void> getBlackedList() async {
    emit(BlackListLoadingState());
    try {
      blackListModel = null;
      final response = await DioHelper.post(
        'common/banned/get_banned_list',
        data: {
          'provider_id': AppStorage.customerID,
          'start': '0',
          'limit': '10000',
        },
      );
      final data = response.data;
      blackListModel = BlackListModel.fromJson(data);
      emit(BlackListInitState());
    } catch (e) {
      emit(BlackListErrorState(e.toString()));
    }
  }

  bool isUserBlocked(String userId) {
    if (blackListModel != null && blackListModel?.bannedList != null)
      for (var user in blackListModel!.bannedList!) {
        if (user.customerId == userId) return true;
      }
    return false;
  }

  Future<void> blocUser(String id) async {
    final response = await DioHelper.post(
      'common/banned/ban_customer',
      data: {
        'provider_id': AppStorage.customerID,
        'customer_id': id,
      },
    );
    if (response.data['success']) {
      showSnackBar("تم حظر المستخدم !");
    } else {
      showSnackBar("حدث خطأ اثناء حظر العضو !", errorMessage: true);
    }
  }

  Future<void> unBlockUser(String id) async {
    final response = await DioHelper.post(
      'common/banned/unban_customer',
      data: {
        'provider_id': AppStorage.customerID,
        'customer_id': id,
      },
    );
    if (response.data['success']) {
      showSnackBar("تم فك حظر المستخدم !");
    } else {
      showSnackBar("حدث خطأ اثناء فك حظر العضو !", errorMessage: true);
    }
  }
}
