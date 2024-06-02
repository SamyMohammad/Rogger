import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:silah/store/add_product/cubit/cubit.dart';
import 'package:silah/store/add_product/widgets/image_widget.dart';

class ImagesListWidget extends StatefulWidget {
  const ImagesListWidget({
    super.key,
    required this.cubit,
  });

  final AddProductCubit cubit;

  @override
  State<ImagesListWidget> createState() => _ImagesListWidgetState();
}

class _ImagesListWidgetState extends State<ImagesListWidget> {
  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Material(
            elevation: elevation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      proxyDecorator: proxyDecorator,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
        });
      },
      children: [
        ...widget.cubit.images.map((e) {
          final index = widget.cubit.images.indexOf(e);
          return ImageWidget(
            index: index,
            image: e,
            onEdit: () => widget.cubit.editImage(index),
            onDelete: () => widget.cubit.removeImage(e),
          );
        }).toList(),
      ],
    );
  }
}
