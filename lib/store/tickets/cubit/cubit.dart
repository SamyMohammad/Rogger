import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/store/tickets/ErrorModel.dart';
import 'package:silah/store/tickets/cubit/states.dart';
import 'package:silah/store/tickets/get_status_verification/get_status_verification.dart';

import '../../../core/app_storage/app_storage.dart';
import '../../../core/dio_manager/dio_manager.dart';
import '../../../widgets/snack_bar.dart';

class TicketsCubit extends Cubit<TicketsStates> {
  TicketsCubit() : super(TicketsInitState());
  static TicketsCubit of(context) => BlocProvider.of(context);
  bool isFirstSelected = true;
  int indexOfVerification = 0;
  bool firstCheckbox = false;
  bool secondCheckbox = false;
  GetStatusVerification? getStatusVerification;

  Request? request;
  bool? accountIsVerified;
  // File? categoryRecordImage;
  // File? copyOfTransferImage;
  // String? commercialRegisterNumberController;
  final formKey = GlobalKey<FormState>();
  bool isValidate = false;
  final categoryRecordImageNotifier = ValueNotifier<File?>(null);
  final copyOfTransferImageNotifier = ValueNotifier<File?>(null);
  final registerNumberControllerNotifier = ValueNotifier<String?>(null);
  final verifiedNotifier = ValueNotifier<bool?>(false);
  final guaranteedNotifier = ValueNotifier<bool?>(false);

  int? veirificationMethodSelectedIndex;
  // File? categoryRecordImage;
  // File? copyOfTransferImage;
  // String? commercialRegisterNumberController;
// final _isValid = ValueNotifier<bool>(false); // Initialize to false

  bool get isValid =>
      categoryRecordImageNotifier.value != null &&
      copyOfTransferImageNotifier.value != null &&
      (registerNumberControllerNotifier.value != "" &&
          registerNumberControllerNotifier.value != null) &&
      verifiedNotifier.value == true;
  bool validateVerificationRequest() {
    if (categoryRecordImageNotifier.value == null) {
      showSnackBar('يجب اختيار صورة ${categories[indexOfVerification]}!',
          errorMessage: true);
      return false;
    }
    if (copyOfTransferImageNotifier.value == null) {
      showSnackBar('يجب اختيار صورة من التحويل!', errorMessage: true);
      return false;
    }
    if (registerNumberControllerNotifier.value == null ||
        registerNumberControllerNotifier.value!.isEmpty) {
      showSnackBar('يجب ادخال رقم السجل التجاري!', errorMessage: true);
      return false;
    }
    isValidate = true;
    emit(ValidateState(isValidate));

    return formKey.currentState!.validate();
  }

  bool validateUpdateVerificationRequest() {
    if (copyOfTransferImageNotifier.value == null) {
      showSnackBar('يجب اختيار صورة من التحويل!', errorMessage: true);
      return false;
    }

    isValidate = true;
    emit(ValidateState(isValidate));

    return formKey.currentState!.validate();
  }

  Future<FormData> _convertVerificationRequestDataToFormData() async {
    final data = {
      'customer_id': AppStorage.customerID,
      'verification_type': handleCategory(indexOfVerification),
      'verification_type_number': registerNumberControllerNotifier.value,
      'verification_required': firstCheckbox ? '1' : '0',
    };

    final formData = FormData.fromMap(data);
    if (categoryRecordImageNotifier.value != null)
      formData.files.add(MapEntry(
          'verification_type_image',
          await MultipartFile.fromFile(
              categoryRecordImageNotifier.value!.path)));
    if (copyOfTransferImageNotifier.value != null) {
      formData.files.add(MapEntry(
          'transaction_image',
          await MultipartFile.fromFile(
              copyOfTransferImageNotifier.value!.path)));
    }

    return formData;
  }

  Future<FormData> _convertUpdateVerificationRequestDataToFormData() async {
    final data = {
      'verification_required': firstCheckbox == true ? '1' : '0',
      'verification_id':
          getStatusVerification?.requests?[0].verificationRequestId,
    };
    final formData = FormData.fromMap(data);
    // if (categoryRecordImageNotifier.value != null)
    //   formData.files.add(MapEntry(
    //       'verification_type_image',
    //       await MultipartFile.fromFile(
    //           copyOfTransferImageNotifier.value!.path)));
    if (copyOfTransferImageNotifier.value != null)
      formData.files.add(MapEntry(
          'transaction_image',
          await MultipartFile.fromFile(
              copyOfTransferImageNotifier.value!.path)));
    return formData;
  }

  Future<void> updaterequestVerification() async {
    if (!validateUpdateVerificationRequest()) return;
    formKey.currentState?.save();
    emit(UpdateRequestVerificationLoadingState());
    final formData = await _convertUpdateVerificationRequestDataToFormData();
    try {
      final response = await DioHelper.post(
          'customer/account/update_verficiation',
          formData: formData);

      if (response.data.containsKey('success')) {
        emit(UpdateRequestVerificationSuccessState(response.data));
      } else {
        emit(UpdateRequestVerificationErrorState(
            ErrorModel.fromJson(response.data['error'])));
        throw Exception(response.data);
      }
      // if (response.data['success']) {
      //   closeKeyboard();
      //   RouteManager.pop();
      //   showSnackBar('تمت الإضافة!', duration: 7);
      // } else {
      //   throw Exception(response.data);
      // }
    } catch (e) {}
    emit(TicketsInitState());
  }

  Future<void> requestVerification() async {
    if (!validateVerificationRequest()) return;
    formKey.currentState?.save();
    emit(RequestVerificationLoadingState());
    final formData = await _convertVerificationRequestDataToFormData();
    try {
      final response = await DioHelper.post(
          'customer/account/create_verifiy_request',
          formData: formData);

      if (response.data.containsKey('success')) {
        emit(RequestVerificationSuccessState(response.data));
      } else {
        emit(RequestVerificationErrorState(
            ErrorModel.fromJson(response.data['error'])));
        throw Exception(response.data);
      }
      // if (response.data['success']) {
      //   closeKeyboard();
      //   RouteManager.pop();
      //   showSnackBar('تمت الإضافة!', duration: 7);
      // } else {
      //   throw Exception(response.data);
      // }
    } catch (e) {}
    emit(TicketsInitState());
  }

  Future<void> getStatusTicketsVerification() async {
    emit(GetStatusVerificationLoadingState());
    try {
      final response = await DioHelper.post(
          'customer/account/get_customer_verfication',
          data: {
            'customer_id': AppStorage.customerID,
          });

      if (response.data.containsKey('success')) {
        print(
            'getStatusVerificationPPPP ${response.data["requests"][0].toString()}');
        accountIsVerified = response.data["requests"].any((request) {
          return request['STATUS'] == "approved";
        });

        getStatusVerification = GetStatusVerification.fromJson(response.data);
        // getStatusVerification?.requests?.any((request) {
        //
        //   return request.verificationRequired == 1 &&
        //       request.sTATUS == "approved";
        // });

        emit(GetStatusVerificationSuccessState(getStatusVerification));
      } else {
        emit(GetStatusVerificationErrorState());
        // ErrorModel.fromJson(response.data['error'])));
        throw Exception(response.data);
      }
      // if (response.data['success']) {
      //   closeKeyboard();
      //   RouteManager.pop();
      //   showSnackBar('تمت الإضافة!', duration: 7);
      // } else {
      //   throw Exception(response.data);
      // }
    } catch (e) {}
    // emit(TicketsInitState());
  }

  String? totalFee;
  getTotalFee() {
    String? commercialRegisterFee =
        settings?['data']['commercial_register_fee'];
    String? identityDocumentFee = settings?['data']['identity_document_fee'];
    String? freelancerDocumentFee =
        settings?['data']['freelancer_document_fee'];
    String? subscriptionFee = settings?['data']['subscription_fee'];
    String? verificationFee = settings?['data']['verification_fee'];
    if (indexOfVerification == 0) {
      if (firstCheckbox) {
        totalFee = (double.parse(commercialRegisterFee ?? '0') +
                double.parse(verificationFee ?? '0'))
            .toString();
      } else {
        totalFee = commercialRegisterFee;
      }
    } else if (indexOfVerification == 1) {
      if (firstCheckbox) {
        totalFee = (double.parse(identityDocumentFee ?? '0') +
                double.parse(verificationFee ?? '0'))
            .toString();
      } else {
        totalFee = identityDocumentFee;
      }
    } else if (indexOfVerification == 2) {
      if (firstCheckbox) {
        totalFee = (double.parse(freelancerDocumentFee ?? '0') +
                double.parse(verificationFee ?? '0'))
            .toString();
      } else {
        totalFee = freelancerDocumentFee;
      }
    }
  }

  Map<String, dynamic>? settings;

  Future<void> getSettings() async {
    try {
      final response = await DioHelper.post('customer/account/get_settings');

      if (response.data.containsKey('success')) {
        settings = response.data;
        getTotalFee();
      } else {
        emit(GetStatusVerificationErrorState());
        // ErrorModel.fromJson(response.data['error'])));
        throw Exception(response.data);
      }
    } catch (e) {}
    return null;
    // emit(TicketsInitState());
  }

  bool isNavigateToContinueVerifyMethodForm = false;
  bool isNavigateToContinueGuaranteeForm = false;

  navigateToVerifyMethodForm() {
    isNavigateToContinueVerifyMethodForm =
        !isNavigateToContinueVerifyMethodForm;
    emit(NavigateToVerifyMethodFormState());
  }

  navigateToGuaranteeForm() {
    isNavigateToContinueGuaranteeForm = true;
    emit(NavigateToVerifyMethodFormState());
  }

  String handleCategory(int index) {
    List<String> verificationTypesList = [
      "Commercial Register",
      "Identity Document",
      "Freelancer Document"
    ];
    return verificationTypesList[index];
  }

  toggleFirstCheckbox() {
    firstCheckbox = !firstCheckbox;
    guaranteedNotifier.value = firstCheckbox;
    emit(TicketsInitState());
  }

  toggleSecondCheckbox() {
    secondCheckbox = !secondCheckbox;
    verifiedNotifier.value = secondCheckbox;
    emit(TicketsInitState());
  }

  List<String> categories = [
    "حساب مضمون",
    "السجل التجاري",
    "وثيقة معروف",
    "وثيقة العمل الحر"
  ];
  // List<String> icons = [
  //   "verified",
  //   "ministry",
  //   "wasika",
  //   "freelancing",
  // ];
  List<String> icons = [
    "verified",
    "tegara",
    "doc",
    "free",
  ];
  setIndex(int index) {
    indexOfVerification = index;
    emit(TicketsInitState());
  }

  toggleIsFirstSelected(bool isFirstSelected) {
    this.isFirstSelected = isFirstSelected;
    isNavigateToContinueVerifyMethodForm = false;
    isNavigateToContinueGuaranteeForm = false;
    emit(TicketsInitState());
  }

  bool isVisible = false;

  isValidateToVisible() {
    isVisible = (categoryRecordImageNotifier.value != null &&
        copyOfTransferImageNotifier.value != null &&
        registerNumberControllerNotifier.value != '' &&
        verifiedNotifier.value != null);
  }

  Request? getModelIndexOfVerificatio(String verificationType) {
    Request? item = getStatusVerification?.requests?.firstWhere(
        (request) => request.verificationType == verificationType,
        orElse: () => Request());
    if (item?.isExpired == true) {
      request = Request();
    } else {
      request = item;
    }

    if (item?.verificationTypeNumber != null) {
      return item;
    }
    return null;
  }

  bool isAnyRequestExists = false;
  bool isAnyRequestInTypeVerification(String verificationType) {
    bool isAnyRequest = getStatusVerification?.requests
            ?.any((request) => request.verificationType == verificationType) ??
        false;
    isAnyRequestExists = isAnyRequest;

    if (isAnyRequest) {
      return isAnyRequest;
    }
    return isAnyRequest;
  }

  bool buttonStatus = false;
  getFormStatus() {
    if ((isAnyRequestExists == true && request?.sTATUS == 'rejected') ||
        request?.isExpired == true ||
        true) {
      categoryRecordImageNotifier.value = null;
      copyOfTransferImageNotifier.value = null;
      registerNumberControllerNotifier.value = null;
      verifiedNotifier.value = null;
      guaranteedNotifier.value = null;
      buttonStatus = false;
    }
  }

  bool isValidGuaranteedStatus = false;
  isValidGuaranteed() {
    bool value = copyOfTransferImageNotifier.value != null &&
        verifiedNotifier.value == true &&
        guaranteedNotifier.value == true;
    isValidGuaranteedStatus = value;

    print(
        'printStatus${copyOfTransferImageNotifier.value} ${verifiedNotifier.value} ${guaranteedNotifier.value}');
  }
}

enum VerificationType {
  CommercialRegister,
  KnownDocument,
  FreelanceWorkDocument
}

extension MyVerificationTypeExtension on int {
  String get name {
    switch (this) {
      case 0:
        return 'Commercial Register';
      case 2:
        return 'Freelancer Document';
      case 1:
        return 'Identity Document';
      default:
        return 'null Document';
    }
  }
}

extension StringStatusExtension on String {
  IconData? get icon {
    switch (this) {
      case 'approved':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel;
      case 'processing':
        return Icons.access_time;
      default:
        return null;
    }
  }
}

extension ColorStatusExtension on String {
  Color? get color {
    switch (this) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'processing':
        return Colors.grey;
      default:
        return null;
    }
  }
}
