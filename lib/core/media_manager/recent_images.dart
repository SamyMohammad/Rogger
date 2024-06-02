import 'dart:developer';
import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class RecentImagesManager {
  static RecentImagesManager instance = RecentImagesManager();

  /// Get the recent 20 image from storage
  Future<List<RecentImageModel>> getRecentImages() async {
    final recentAssetEntity = await getRecentAssetEntity();
    int length = recentAssetEntity.length;
    List<RecentImageModel> images = [];
    for (int i = 0; i < length; i++) {
      final assetEntity = recentAssetEntity[i];
      final file = await assetEntity.file;
      images.add(RecentImageModel(type: Type.image, file: file!));
    }
    return images;
  }

  /// TO get File from AssetEntity
  /// Iterate on the result then call [await element.file]
  /// element is every item in result
  Future<List<AssetEntity>> getRecentAssetEntity() async {
    try {
      final isGranted = await checkForPermission();
      if (!isGranted) {
        log("Permission is not granted!");
        throw UnimplementedError("Permission is not granted!");
      }
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
      if (paths.isEmpty) {
        return [];
      }
      final List<AssetEntity> entities =
          await paths.first.getAssetListPaged(page: 0, size: 20);
      return entities;
    } catch (e) {
      return [];
    }
  }

  Future<bool> checkForPermission() async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    return _ps.isAuth;
  }
}

enum Type { image, gallery }

class RecentImageModel {
  final Type? type;
  final File? file;
  const RecentImageModel({this.type, this.file});
}
