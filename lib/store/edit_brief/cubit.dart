import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';

import '../../widgets/snack_bar.dart';

part 'states.dart';

class EditBriefCubit extends Cubit<EditBriefStates> {
  EditBriefCubit() : super(EditBriefInit());

  static EditBriefCubit of(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  TextEditingController brief =
      TextEditingController(text: AppStorage.getUserModel()!.brief!);
  printBrief() {}

  Future<void> editBrief() async {
    formKey.currentState!.save();
    if (!formKey.currentState!.validate()) return;
    emit(EditBriefLoading());
    try {
      Map<String, dynamic>? editBrief = {
        'brief': brief.text,
        'logged': 'true',
        'customer_id': AppStorage.customerID,
      };

      final response = await DioHelper.post(
        'provider/account/edit_brief',
        data: editBrief,
      );

      showSnackBar(response.data['success']);
      AppStorage.cacheUser(AppStorage.getUserModel()!..brief = brief.text);
      RouteManager.pop();
    } catch (_) {}
    emit(EditBriefInit());
  }

  // static String utf8Converter(String text) {
  //   List<int> bytes = text.toString().codeUnits;
  //   return utf8.decode(bytes);
  // }

  bool areInputsValid = false;

  void checkInputsValidity() {
    formKey.currentState?.save();
    areInputsValid = formKey.currentState?.validate() ?? false;

    emit(EditBriefInit());
  }

  @override
  Future<void> close() {
    brief.dispose();
    return super.close();
  }
}
