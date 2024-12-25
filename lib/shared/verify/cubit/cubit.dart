import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/nav_bar/view.dart';
import 'package:silah/shared/register_completed/view.dart';
import 'package:silah/shared/verify/cubit/states.dart';
import 'package:silah/widgets/toast.dart';

class VerifyCubit extends Cubit<VerifyStates> {
  VerifyCubit(
      this.telephone, this.customerId, this.customerGroup, this.reverifying)
      : super(VerifyInitState());
  static VerifyCubit of(context) => BlocProvider.of(context);

  final int customerId;
  final int customerGroup;
  final bool reverifying;
  final formKey = GlobalKey<FormState>();
  String? code;
  String telephone;

  Future<void> activate() async {
    emit(VerifyLoadingState());
    try {
      final response = await DioHelper.post(
        reverifying
            ? 'customer/account/phone_activation'
            : 'customer/account/register_activation',
        data: {"customer_id": customerId, 'code': code},
      );
      final data = response.data;
      if (data.toString().contains('success')) {
        await getUserAndCache(customerId, customerGroup);
        if (reverifying) {
          RouteManager.navigateAndPopAll(NavBarView());
        } else {
          RouteManager.navigateAndPopAll(RegisterCompletedView());
        }
      } else {
        showToast('كود خاطئ');
      }
    } catch (e) {
      // emit(HomeErrorState(e.toString()));
    }
    emit(VerifyInitState());
  }

  Future<void> changeTelephone(String telephone) async {
    this.telephone = telephone;
    emit(VerifyInitState());
  }

  Future<void> resendCode() async {
    try {
      final response =
          await DioHelper.post('customer/account/resend_code', data: {
        "telephone": telephone,
      });
      final data = response.data;
      showToast(data['success'] ? 'تم ارسال الكود!' : 'فشل ارسال الكود!');
    } catch (e) {
      showToast('فشل ارسال الكود!');
      rethrow;
    }
  }
}
