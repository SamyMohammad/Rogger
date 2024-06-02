import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/widgets/snack_bar.dart';

part 'states.dart';

class EditPasswordCubit extends Cubit<EditPasswordStates> {
  EditPasswordCubit() : super(EditPasswordInit());

  static EditPasswordCubit of(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();

  String? newPassword, confirmNewPassword;

  Future<void> editPassword() async {
    emit(EditPasswordLoading());
    formKey.currentState!.save();
    if (!formKey.currentState!.validate()) return;
    try {
      final response = await DioHelper.post(
        'customer/account/edit_password',
        data: {
          'logged': 'true',
          'customer_id': AppStorage.customerID,
          'password': newPassword,
          'confirm': confirmNewPassword,
        },
      );
      if (response.data['success'] != null) {
        showSnackBar(response.data['success']);
        RouteManager.pop();
      } else {
        showSnackBar(response.data['message']);
      }
    } catch (e) {
      showInternetErrorMessage();
    }
    emit(EditPasswordInit());
  }

  bool areInputsValid = false;

  void checkInputsValidity() {
    formKey.currentState?.save();
    areInputsValid = formKey.currentState?.validate() ?? false;
    emit(EditPasswordInit());
  }
}
