import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/login/cubit/states.dart';
import 'package:silah/shared/nav_bar/view.dart';
import 'package:silah/shared/verify/view.dart';
import 'package:silah/widgets/snack_bar.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit of(context) => BlocProvider.of(context);

  String? telephone, password;
  final formKey = GlobalKey<FormState>();
  int? customerId;
  int? customerGroup;
  bool rememberMe = false;

  toggleRememberMe() {
    rememberMe = !rememberMe;
    emit(LoginInitState());
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    emit(LoginLoadingState());
    // print({
    //   "telephone" : telephone,
    //   "password" : password,
    // });
    try {
      final response = await DioHelper.post('customer/account/login', data: {
        "telephone": telephone,
        "password": password,
      });
      final data = response.data;
      if (data['message'] != null) {
        showSnackBar(data['message']);
      } else if (data['customer_status'].toString() == "0") {
        // activation
        RouteManager.navigateAndPopAll(VerifyView(
          customerId: data['customer_id'],
          telephone: telephone!,
          customerGroup: data['customer_group'],
        ));
        showSnackBar('برجاء تفعيل رقم الجوال');
      } else if (data['logged'] == true) {
        // Home
        await getUserAndCache(data['customer_id'], data['customer_group']);
        RouteManager.navigateAndPopAll(NavBarView());
      }
    } catch (e) {
      print(e);
      emit(LoginErroeState(e.toString()));
    }
    emit(LoginInitState());
  }

  bool areInputsValid = false;

  void checkInputsValidity() {
    formKey.currentState?.save();
    areInputsValid = formKey.currentState?.validate() ?? false;
    emit(LoginInitState());
  }
}
