import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
    debugPrint(
        "productsDetailsModel?.categoryID${productsDetailsModel?.categoryID}");

    if (productsDetailsModel == null) {
      return;
    }

    nameController.text = productsDetailsModel!.productName!;
    final price = productsDetailsModel!.price!.replaceAll('S.R', '').trim();
    priceController.text = price == '0' ? '' : price;
    descriptionController.text = productsDetailsModel?.description ?? '';
    print(
        " productsDetailsModel?.categoryID${productsDetailsModel?.categoryID}");
    // Find and set the initial category based on categoryID
    categoryInAddProduct =
        categoriesInAddProduct?.data?.firstWhereOrNull((category) {
      return category.id == productsDetailsModel?.categoryID;
    });
    video = productsDetailsModel?.video ?? "";
    // Set categoryID value
    categoryID.value = categoryInAddProduct?.id;
    // categoryInAddProduct =
    //     (categoriesInAddProduct?.data ?? []).firstWhere((element) {
    //   return element.id == productsDetailsModel?.categoryID;
    // });
    // categoryID.value = categoryInAddProduct?.id;
    // categoryInAddProduct = CategoryInAddProduct(
    //     name: productsDetailsModel?.categoryName,
    //     id: productsDetailsModel?.categoryID);

    // categoryInAddProduct =
    //     (categoriesInAddProduct?.data ?? []).firstWhere((element) {
    //   return element.id == productsDetailsModel?.categoryID;
    // });
    // categoryID.value = categoryInAddProduct?.id;
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
  String? video;
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

      categoriesInAddProduct = CategoriesInAddProduct.fromJson(data);
      // categoriesModel.categories[0].
      emit(AddProductInitState());
    } catch (e) {}
  }

  Future<void> addProduct() async {
    if (!_validateProductData()) return;
    formKey.currentState?.save();
    emit(AddProductLoadingState());
    final formData = await _convertProductDataToFormData();

    try {
      final response =
          await DioHelper.post('provider/products/add', formData: formData);

      if (response.data['success']) {
        closeKeyboard();

        RouteManager.pop();
        makeValuesToNull();
        showSnackBar('تمت الإضافة!', duration: 100);
      } else {
        throw Exception(response.data);
      }
    } catch (e, s) {
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
      formData.files.add(MapEntry(
          'videos[0]', await MultipartFile.fromFile(File(video!).path)));
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

    final formData = FormData.fromMap(data);
    if (video != null)
      formData.files
          .add(MapEntry('videos[0]', await MultipartFile.fromFile(video!)));
    for (int i = 0; i < images.length; i++) {
      formData.files.add(
          MapEntry('files[$i]', await MultipartFile.fromFile(images[i].path)));
    }
    return formData;
  }

  void pickVideo() async {
    final permission = await Permission.videos.request();
    if (permission.isGranted) {
      final pickedFile =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        video = pickedFile.path;
        emit(AddProductInitState());
      }
    }
  }

  // void pickImages() async {
  //   final pickedFiles = await ImagesPicker.pick(
  //     count: 5,
  //     pickType: PickType.image,
  //   );
  //   if (pickedFiles != null) {
  //     int length = pickedFiles.length;
  //     if (length > (5 - images.length)) {
  //       length = 5 - images.length;
  //       showSnackBar('عفوا اقصي عدد للصور 5');
  //     }
  //     for (int i = 0; i < length; i++) {
  //       images.add(File(pickedFiles[i].path));
  //     }
  //     emit(AddProductInitState());
  //   }
  // }

  void pickImages() async {
    final permission = await Permission.photos.request();
    if (permission.isGranted) {
      final pickedFiles = await ImagePicker().pickMultiImage(

          // count: 5,
          // pickType: PickType.image,
          );
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
    final permission = await Permission.photos.request();
    if (permission.isGranted) {
      final pickedFiles = await ImagePicker().pickMultiImage(limit: 2);
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

extension ListExtensions<E> on List<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
