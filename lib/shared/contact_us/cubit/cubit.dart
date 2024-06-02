import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/contact_us/cubit/states.dart';
import 'package:silah/widgets/toast.dart';

class ContactUsCubit extends Cubit<ContactUsStates> {
  ContactUsCubit() : super(ContactUsInitState());

  static ContactUsCubit of(context) => BlocProvider.of(context);
  String? subject = 'inquiry';
  String? enquiry;
  int? customerId = AppStorage.customerID;
  final formKey = GlobalKey<FormState>();

  Future<void> contactUs() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    emit(ContactUsLoadingState());
    try {
      final response = await DioHelper.post('contact', data: {
        "customer_id": customerId,
        "subject": subject,
        "enquiry": enquiry
      });
      final data = response.data;
      print(response.data);
      if (data.containsKey('success')) {
        showToast(data['success']);
        RouteManager.pop();
      } else {
        showToast('حدث خطأ');
      }
      emit(ContactUsInitState());
    } catch (e) {
      emit(ContactUsErrorState(e.toString()));
    }
  }

  bool areInputsValid = false;

  void checkInputsValidity(String? value) {
    enquiry = value;
    formKey.currentState?.save();
    areInputsValid = formKey.currentState?.validate() ?? false;
    emit(ContactUsInitState());
  }
}
