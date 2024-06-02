import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/store/add_status/cubit.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../constants.dart';

class AddStatusView extends StatelessWidget {
  const AddStatusView({Key? key}) : super(key: key);

  static const double imageHeight = 90;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddStatusCubit()..init(),
      child: BlocBuilder<AddStatusCubit, AddStatusStates>(
        builder: (context, state) {
          final cubit = AddStatusCubit.of(context);
          return Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Builder(
                    builder: (context) {
                      if (cubit.cameraController == null) {
                        return Container(
                          color: Colors.white,
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: LoadingIndicator(),
                        );
                      }
                      return SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: CameraPreview(cubit.cameraController!),
                      );
                    },
                  ),
                  Positioned(
                    bottom: bottomDevicePadding + 16,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state is AddStatusInit)
                          SizedBox(
                            height: imageHeight,
                            width: sizeFromWidth(1),
                            child: ListView.builder(
                                itemCount: cubit.recentImages.length,
                                padding: EdgeInsets.only(right: 16),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final i = cubit.recentImages[index];
                                  return InkWell(
                                    onTap: () => cubit.addStatus(
                                        file: i.file!, isImage: true),
                                    child: Container(
                                      width: imageHeight,
                                      height: imageHeight,
                                      margin: EdgeInsets.only(left: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: DecorationImage(
                                            image: FileImage(i.file!),
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                  );
                                }),
                          ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Visibility(
                            visible: state is AddStatusInit,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _icon(
                                  icon: FontAwesomeIcons.image,
                                  onTap: cubit.getImageFromGallery,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final image = await cubit.cameraController
                                        ?.takePicture();
                                    if (image != null) {
                                      cubit.addStatus(
                                          file: File(image.path),
                                          isImage: true);
                                    }
                                  },
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 6,
                                      ),
                                    ),
                                  ),
                                ),
                                _icon(
                                  visible: true,
                                  icon: FontAwesomeIcons.video,
                                  onTap: cubit.getVideoFromGallery,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: topDevicePadding + 32,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _icon(
                          icon: FontAwesomeIcons.xmark,
                          onTap: RouteManager.pop,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _icon({
    bool visible = true,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        child: Icon(
          icon,
          color: visible ? Colors.white : Colors.transparent,
          size: 20,
        ),
        backgroundColor:
            visible ? Colors.black.withOpacity(0.4) : Colors.transparent,
      ),
    );
  }
}
