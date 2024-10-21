import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/store/store_profile/view.dart';
import 'package:silah/widgets/snack_bar.dart';

import '../../core/media_manager/recent_images.dart';

part 'states.dart';

class AddStatusCubit extends Cubit<AddStatusStates> {
  AddStatusCubit() : super(AddStatusInit());

  static AddStatusCubit of(context) => BlocProvider.of(context);

  CameraController? cameraController;
  List<RecentImageModel> recentImages = [];

  void init() async {
    emit(AddStatusLoading());
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      cameraController = CameraController(_cameras[0], ResolutionPreset.max);
      await cameraController?.initialize();
      await cameraController?.resumePreview();
    } else {
      // Handle the case where no cameras are available.
      // You might want to show an error message or take appropriate action.
    }

    await cameraController?.initialize();
    await cameraController?.resumePreview();
    await getRecentImages();
    emit(AddStatusInit());
  }

  Future<void> addStatus({required File file, required bool isImage}) async {
    if (state is AddStatusLoading) {
      return;
    }
    cameraController = null;
    emit(AddStatusLoading());
    try {
      FormData formData = FormData.fromMap({
        'attachment_type': isImage ? 'image' : 'video',
        'provider_id': AppStorage.customerID,
      });
      formData.files
          .add(MapEntry('attachment', await MultipartFile.fromFile(file.path)));
      final response = await DioHelper.post(
        'provider/story/add',
        formData: formData,
      );
      if (response.data['success']) {
        showSnackBar('تمت الإضافة');
        RouteManager.navigateAndPopUntilFirstPage(
            StoreProfileView(storeId: AppStorage.customerID.toString()));
      } else {
        throw Exception();
      }
    } catch (e) {
      showSnackBar('فشلت اضافة الحالة', errorMessage: true);
      RouteManager.pop();
    }
    emit(AddStatusInit());
  }

  Future<void> getRecentImages() async {
    final images = await RecentImagesManager.instance.getRecentImages();
    images.retainWhere((element) => element.type == Type.image);
    recentImages = images;
  }

  Future<File?> getImageFromGallery() async {
    final permission = await Permission.photos.request();
    if (permission.isGranted) {
      final files = await ImagePicker().pickMultiImage(
        limit: 1,
      );
      if (files.isEmpty) {
        return null;
      } else {
        final file = File(files.first.path);
        addStatus(file: file, isImage: true);
        return file;
      }
    }
    return null;
  }

  Future<File?> getVideoFromGallery() async {
    final permission = await Permission.videos.request();
    if (permission.isGranted) {
      XFile? file;
      ImagePicker()
          .pickVideo(
            source: ImageSource.gallery,
          )
          .then((value) => file = value);
      if (file == null) {
        return null;
      } else {
        // final file = File(file.path);
        addStatus(file: File(file!.path), isImage: false);
        return File(file!.path);
      }
    }
    return null;
  }

  @override
  Future<void> close() {
    cameraController?.dispose();
    return super.close();
  }
}
