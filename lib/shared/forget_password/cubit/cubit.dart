import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/forget_password/cubit/states.dart';
import 'package:silah/shared/login/view.dart';
import 'package:silah/widgets/snack_bar.dart';

class ForgetPassCubit extends Cubit<ForgetPassStates> {
  ForgetPassCubit() : super(ForgetPassInitState());

  static ForgetPassCubit of(context) => BlocProvider.of(context);

  String? telephone;
  final formKey = GlobalKey<FormState>();
  bool isPhone = true;

  toggleIsPhone(bool state) {
    isPhone = state;
    emit(ForgetPassInitState());
  }

  Future<void> forgetPass() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    emit(ForgetPassLoadingState());
    try {
      final response =
          await DioHelper.post('customer/account/send_new_password', data: {
        "telephone": telephone,
      });
      final data = response.data;
      // print(data);
      // print(telephone);
      if (data.containsKey('success')) {
        showSnackBar(data['success']);
        RouteManager.navigateAndPopAll(LoginView());
      } else {
        showSnackBar(data.toString());
      }
    } catch (e) {
      emit(ForgetPassErrorState(e.toString()));
    }
    emit(ForgetPassInitState());
  }

  bool areInputsValid = false;

  void checkInputsValidity() {
    formKey.currentState?.save();
    areInputsValid = formKey.currentState?.validate() ?? false;
    emit(ForgetPassInitState());
  }
}
