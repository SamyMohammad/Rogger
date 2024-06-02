import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/user/followers/cubit/states.dart';
import 'package:silah/user/followers/model.dart';

import '../../../widgets/snack_bar.dart';

class FollowersCubit extends Cubit<FollowersStates> {
  FollowersCubit() : super(FollowersInitState());
  static FollowersCubit of(context) => BlocProvider.of(context);

  FollowersModel? followersModel;

  Future<void> getAllFollowers() async {
    emit(FollowersLoadingState());
    try {
      final response =
          await DioHelper.post('customer/account/following_list', data: {
        "customer_id": AppStorage.customerID,
      });
      final data = response.data;
      followersModel = FollowersModel.fromJson(data);
      emit(FollowersInitState());
    } catch (e) {
      emit(FollowersErrorState(e.toString()));
    }
  }

  Future<void> followStore(FollowingList follow) async {
    final response = await DioHelper.post(
      'customer/account/following_add',
      data: {
        'customer_id': AppStorage.getUserModel()?.customerId,
        'advertizer_id': follow.advertizerId,
      },
    );
    if (response.data['success'] == true) {
      showSnackBar('تم متابعة ${follow.advertizerName} بنجاح!');
    } else {
      showSnackBar(response.data['message'], errorMessage: true);
    }
  }

  Future<void> unfollowStore(FollowingList follow) async {
    try {
      final response = await DioHelper.post(
        'customer/account/following_remove',
        data: {
          'customer_id': AppStorage.getUserModel()?.customerId,
          'advertizer_id': follow.advertizerId,
        },
      );
      if (response.data['success'] == true) {
        showSnackBar('تم الغاء المتابعة!');
      } else {
        showSnackBar(response.data['message'], errorMessage: true);
      }
    } catch (e) {}
  }
}
