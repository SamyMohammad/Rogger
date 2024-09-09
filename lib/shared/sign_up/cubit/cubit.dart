import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/sign_up/cubit/states.dart';
import 'package:silah/shared/verify/view.dart';
import 'package:silah/widgets/toast.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitState());

  static SignUpCubit of(context) => BlocProvider.of(context);

  String? name, email, telephone, password, nickname, groupId;
  final formKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    emit(SignUpLoadingState());
    // 1 زبون - 2 معلن
      Map    params = {
        "customer_group_id": groupId,
        "name": name,
        "email": email ?? "",
        if (groupId == '2') "nickname": nickname,
        "telephone": telephone,
        "password": password,
        "agree": "1",
        // "country_id" : countryID,
      };
      print('params: $params');
    try {
      final response = await DioHelper.post('customer/account/register', data: {
        "customer_group_id": groupId,
        "name": name,
        "email": email ?? "",
        if (groupId == '2') "nickname": nickname,
        "telephone": telephone,
        "password": password,
        "agree": "1",
        // "country_id" : countryID,
      });

      final data = response.data;
      showToast(data['message']);

      if (!data.toString().contains('customer_id')) {
        showToast(data['message']);
      } else {
        showToast('برجاء قم باستكمال عملية التسجيل');
        RouteManager.navigateAndPopAll(VerifyView(
          telephone: telephone.toString(),
          customerId: int.parse(data
              .toString()
              .substring(data.toString().lastIndexOf(":") + 1)
              .toString()
              .replaceAll('}', '')),
          customerGroup: int.parse(groupId!),
        ));
      }
    } catch (e, s) {
      print(e);
      print(s);
      showToast(e.toString());

      // emit(HomeErrorState(e.toString()));
    }
    emit(SignUpInitState());
  }

  void changeGroup(String v) {
    groupId = v == 'زبون' ? '1' : '2';
    // countryID = null;
    emit(SignUpChangeGroupState());
  }

  bool areInputsValid = false;

  void checkInputsValidity() {
    formKey.currentState?.save();
    areInputsValid = formKey.currentState?.validate() ?? false;
    emit(SignUpInitState());
  }
}
