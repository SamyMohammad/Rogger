import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:images_picker/images_picker.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/widgets/snack_bar.dart';
import 'package:silah/widgets/toast.dart';

import '../../../user/advertisers_on_map/map_categories_model.dart';
import 'states.dart';

class EditProfileCubit extends Cubit<EditProfileStates> {
  EditProfileCubit() : super(EditProfileInitState());

  static EditProfileCubit of(context) => BlocProvider.of(context);

  TextEditingController nameController =
      TextEditingController(text: AppStorage.getUserModel()?.name);
  TextEditingController emailController =
      TextEditingController(text: AppStorage.getUserModel()?.email);
  TextEditingController telephoneController = TextEditingController(
      text: AppStorage.getUserModel()?.modifiedTelephone ??
          AppStorage.getUserModel()?.telephone);
  TextEditingController nicknameController =
      TextEditingController(text: AppStorage.getUserModel()?.nickname);

  // String? countryID;
  String? countryName = AppStorage.getUserModel()?.address;
  final formKey = GlobalKey<FormState>();

  MapCategoriesModel? mapCategoriesModel;
  MapCategory? selectedMapCategory;

  String? image;

  Future<void> editProfile() async {
    if (!formKey.currentState!.validate()) return;
    emit(EditProfileLoadingState());
    try {
      final response = await DioHelper.post(
          AppStorage.isStore
              ? 'provider/account/edit_info'
              : 'customer/account/edit_info',
          data: {
            "logged": true,
            "customer_id": AppStorage.customerID,
            "name": nameController.text,
            if (AppStorage.isStore) "nickname": nicknameController.text,
            // if(AppStorage.isStore)
            //   "country_id" :countryID,
            "email": emailController.text,
            "telephone": telephoneController.text,
            if (AppStorage.isStore) "map_category_id": selectedMapCategory?.id,
          });
      final data = response.data;
      getUserAndCache(
          AppStorage.customerID, AppStorage.getUserModel()!.customerGroup!);
      if (data.toString().contains('success')) {
        showSnackBar("تم تحديث الحساب بنجاح!");
        if (telephoneController.text == AppStorage.getUserModel()?.telephone) {
          // RouteManager.navigateAndPopAll(NavBarView());
        } else {
          showToast("يجب تفعيل رقم الجوال");
          // RouteManager.navigateAndPopUntilFirstPage(VerifyView(
          //   customerId: AppStorage.customerID,
          //   telephone: telephoneController.text,
          //   customerGroup: AppStorage.getUserModel()!.customerGroup!,
          //   reverifying: true,
          // ));
        }
      } else if (data.toString().contains('message')) {
        showToast(data['message']);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
    emit(EditProfileInitState());
  }

  Future<File?> _getImage() async {
    List<Media> files = await ImagesPicker.pick(
            count: 1,
            pickType: PickType.image,
            cropOpt: CropOption(
              cropType: CropType.rect,
              aspectRatio: CropAspectRatio(1, 1),
            )) ??
        [];
    if (files.isEmpty) {
      return null;
    } else {
      return File(files.first.path);
    }
  }

  Future<void> updateImage() async {
    final image = await _getImage();
    if (image == null) {
      return;
    } else {
      emit(EditProfileAvatarLoadingState());
      final data = {
        'customer_id': AppStorage.customerID,
      };
      final formData = FormData.fromMap(data);
      formData.files.addAll(
          {MapEntry('file[0]', await MultipartFile.fromFile(image.path))});
      await DioHelper.post('customer/account/user_avatar', formData: formData);
      // print(response.data);
      showSnackBar("تم تحديث صورة البروفايل بنجاح");
      await getUserAndCache(
          AppStorage.customerID, AppStorage.getUserModel()!.customerGroup!);
      emit(EditProfileInitState());
    }
  }

  Future<void> updateCover() async {
    final image = await _getImage();
    if (image == null) {
      return;
    } else {
      emit(EditProfileCoverLoadingState());
      final data = {
        'customer_id': AppStorage.customerID,
        'logged': true,
      };
      final formData = FormData.fromMap(data);
      formData.files
          .addAll({MapEntry('file', await MultipartFile.fromFile(image.path))});
      await DioHelper.post('provider/account/edit_cover', formData: formData);
      // print(response.data);
      showSnackBar("تم تحديث صورة الغلاف بنجاح");
      await getUserAndCache(
          AppStorage.customerID, AppStorage.getUserModel()!.customerGroup!);
      emit(EditProfileInitState());
    }
  }

  Future<void> getMapCategories() async {
    if (!AppStorage.isStore) {
      return;
    }
    try {
      final response = await DioHelper.post('provider/account/map_categories');
      mapCategoriesModel = MapCategoriesModel.fromJson(response.data);
      selectedMapCategory = (mapCategoriesModel?.mapCategories ?? [])
          .firstWhere((element) =>
              element.id == AppStorage.getUserModel()?.mapCategoryID);
    } catch (e) {}
    emit(EditProfileInitState());
  }


  Future<void> updateMapCategory(String mapCategoryId) async {
    if (!AppStorage.isStore) {
      return;
    }
    try {
      final response = await DioHelper.post('customer/account/update_map_category',data: {
        'map_category_id': mapCategoryId,
        'customer_id': AppStorage.customerID,
      });
      print('updateMapCategory ${response.data}');
      // mapCategoriesModel = MapCategoriesModel.fromJson(response.data);
      // selectedMapCategory = (mapCategoriesModel?.mapCategories ?? [])
      //     .firstWhere((element) =>
      //         element.id == AppStorage.getUserModel()?.mapCategoryID);
    } catch (e) {}
    emit(EditProfileInitState());
  }

  bool areInputsValid = false;

  void checkInputsValidity() {
    formKey.currentState?.save();
    areInputsValid = formKey.currentState?.validate() ?? false;
    emit(EditProfileInitState());
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    nicknameController.dispose();
    return super.close();
  }
}
