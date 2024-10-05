import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:images_picker/images_picker.dart';
import 'package:silah/constants.dart';

class ImagePickerForm extends StatefulWidget {
  ImagePickerForm({super.key, this.onChange, this.hint, this.fileFromApi});
  final Function(File? selectedImage)? onChange;
  final String? hint;
  final String? fileFromApi;

  @override
  State<ImagePickerForm> createState() => _ImagePickerFormState();
}

class _ImagePickerFormState extends State<ImagePickerForm> {
  Future _pickImage() async {
    final image = await ImagesPicker.pick(count: 1, pickType: PickType.image);
    if (image == null) return;
    setState(() {
      selectedFile = File(image.first.path);
    });
    if (widget.onChange != null) {
      widget.onChange!(selectedFile);
    }
  }

  void removeImage() {
    setState(() {
      selectedFile = null;
    });
    if (widget.onChange != null) {
      widget.onChange!(selectedFile);
    }
  }

  File? selectedFile;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.fileFromApi == null
          ? () {
              _pickImage();
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          border: Border.all(
            color: kGreyButtonColorD9,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(getIcon("gallery")),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.fileFromApi == null
                    ? selectedFile != null
                        ? selectedFile!.path
                        : widget.hint ?? 'أرفق صورة '
                    : widget.fileFromApi!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: kDarkGreyColor),
              ),
            ),
            if (selectedFile != null)
              InkWell(
                onTap: removeImage,
                child: SvgPicture.asset(
                  getIcon("close_red"),
                ),
              )
          ],
        ),
      ),
    );
  }
}
