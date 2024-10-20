import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared/product_details/model.dart';
import 'package:silah/store/add_product/cubit/states.dart';
import 'package:silah/widgets/snack_bar.dart';

import '../../../constants.dart';
import '../../../core/router/router.dart';
import '../categories_in_add_product.dart';

class AddProductCubit extends Cubit<AddProductStates> {
  AddProductCubit(this.productsDetailsModel) : super(AddProductInitState());

  static AddProductCubit of(context) => BlocProvider.of(context);
  final BaseModel? productsDetailsModel;
  void init() async {
    await getCategoriesInAddPage();

    if (productsDetailsModel == null) {
      return;
    }

    nameController.text = productsDetailsModel!.productName!;
    final price = productsDetailsModel!.price!.replaceAll('S.R', '').trim();
    priceController.text = price == '0' ? '' : price;
    descriptionController.text = productsDetailsModel?.description ?? '';
    categoryID = productsDetailsModel?.categoryID as ValueNotifier<String?>;

    emit(AddProductImagesLoadingState());
    for (var i in productsDetailsModel?.productImages ?? []) {
      final file = await getFileFromImageUrl(i);
      images.add(file!);
    }

    emit(AddProductInitState());
  }

  ValueNotifier<String?> categoryID = ValueNotifier<String?>(null);
  CategoryInAddProduct? categoryInAddProduct;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? video;
  List<File> images = [];
  makeValuesToNull() {
    categoryID.value = null;
    nameController.text = '';
    priceController.text = '';
    descriptionController.text = '';
    categoryInAddProduct = null;
    video = null;
    images = [];
    emit(AddProductInitState());
  }

  final formKey = GlobalKey<FormState>();
  void validateForm() {
    final isFormValid = formKey.currentState?.validate() ?? false;
    emit(FormValidityState(isValid: isFormValid));
  }

  CategoriesInAddProduct? categoriesInAddProduct;
  Future<void> getCategoriesInAddPage() async {
    emit(AddProductLoadingState());
    try {
      // final data = {
      //   'customer_id': AppStorage.customerID,
      // };
      final response =
          await DioHelper.post('common/category/product_categories', data: {
        'customer_id': AppStorage.customerID,
      });
      final data = response.data;
      print('common/category/product_categories${response.data}');

      categoriesInAddProduct = CategoriesInAddProduct.fromJson(data);
      // categoriesModel.categories[0].
      emit(AddProductInitState());
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProduct() async {
    if (!_validateProductData()) return;
    formKey.currentState?.save();
    emit(AddProductLoadingState());
    final formData = await _convertProductDataToFormData();

    try {
      final response =
          await DioHelper.post('provider/products/add', formData: formData);
      debugPrint('provider/products/add${response.data}', wrapWidth: 1024);
      if (response.data['success']) {
        closeKeyboard();
        print(response.data);
        RouteManager.pop();
        makeValuesToNull();
        showSnackBar('تمت الإضافة!', duration: 100);
      } else {
        throw Exception(response.data);
      }
    } catch (e, s) {
      print(e);
      print(s);
      showSnackBar('فشلت اضافة المنتج!', errorMessage: true);
    }
    emit(AddProductInitState());
  }

  bool _validateProductData() {
    if (images.length < 1) {
      showSnackBar('يجب اختيار صورة للمنتج!', errorMessage: true);
      return false;
    }
    if (categoryID.value == null) {
      showSnackBar('يجب اختيار قسم للمنتج!', errorMessage: true);
      return false;
    }

    if (nameController.text.isEmpty) {
      showSnackBar('يجب ادخال اسم المنتج!', errorMessage: true);
      return false;
    }

    return formKey.currentState!.validate();
  }

  Future<void> updateProduct() async {
    if (!formKey.currentState!.validate()) return;
    emit(AddProductLoadingState());
    final formData = FormData.fromMap({
      'customer_id': AppStorage.customerID,
      'product_description[2][name]': nameController.text,
      'product_category[]': categoryID.value,
      'price': priceController.text,
      'product_id': productsDetailsModel!.productId,
      'product_description[2][description]': descriptionController.text,
    });
    if (video != null)
      formData.files.add(
          MapEntry('videos[0]', await MultipartFile.fromFile(video!.path)));
    if (images.isNotEmpty)
      for (int i = 0; i < images.length; i++) {
        formData.files.add(MapEntry(
            'files[$i]', await MultipartFile.fromFile(images[i].path)));
      }
    try {
      final response =
          await DioHelper.post('provider/products/edit', formData: formData);
      if (response.data.toString().contains('success')) {
        // Pop to ProductDetails
        RouteManager.pop();
        showSnackBar('تم التعديل!');
      } else {
        throw Exception(response.data);
      }
    } catch (e) {
      print(e);
      showSnackBar('فشل تعديل المنتج!', errorMessage: true);
    }
    emit(AddProductInitState());
  }

  Future<FormData> _convertProductDataToFormData() async {
    final data = {
      'customer_id': AppStorage.customerID,
      'product_description[2][name]': nameController.text,
      'product_category[]': categoryID.value,
      'price': priceController.text,
      'product_description[2][description]': descriptionController.text,
    };
    print('_convertProductDataToFormData$data');
    final formData = FormData.fromMap(data);
    if (video != null)
      formData.files.add(
          MapEntry('videos[0]', await MultipartFile.fromFile(video!.path)));
    for (int i = 0; i < images.length; i++) {
      formData.files.add(
          MapEntry('files[$i]', await MultipartFile.fromFile(images[i].path)));
    }
    return formData;
  }

  void pickVideo() async {
    final pickedFile =
        await ImagesPicker.pick(count: 1, pickType: PickType.video);
    if (pickedFile != null && pickedFile.isNotEmpty) {
      video = File(pickedFile.first.path);
      emit(AddProductInitState());
    }
  }

  void pickImages() async {
    final pickedFiles =
        await ImagesPicker.pick(count: 5, pickType: PickType.image);
    if (pickedFiles != null) {
      int length = pickedFiles.length;
      if (length > (5 - images.length)) {
        length = 5 - images.length;
        showSnackBar('عفوا اقصي عدد للصور 5');
      }
      for (int i = 0; i < length; i++) {
        images.add(File(pickedFiles[i].path));
      }
      emit(AddProductInitState());
    }
  }
  void editImage(int index) async {
    final pickedFiles =
        await ImagesPicker.pick(count: 1, pickType: PickType.image);
    if (pickedFiles != null) {
      images[index] = File(pickedFiles.first.path);
      emit(AddProductInitState());
    }
  }

  void removeVideo() {
    video = null;
    emit(AddProductInitState());
  }

  void removeImage(File file) {
    images.remove(file);
    emit(AddProductInitState());
  }

  bool areInputsValid = false;

  void checkInputsValidity() {
    formKey.currentState?.save();
    areInputsValid = formKey.currentState?.validate() ?? false;
    emit(AddProductInitState());
  }

  @override
  Future<void> close() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    categoryID.dispose();
    return super.close();
  }
}
