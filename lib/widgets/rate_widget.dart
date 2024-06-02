import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';

class RateWidget extends StatelessWidget {
  final double rate;
  final void Function(double)? onRate;
  final double itemSize;
  final double hItemPadding;
  final double vItemPadding;
final bool? ignoreGestures;
  RateWidget({
    required this.rate,
    this.ignoreGestures ,
    this.onRate,
    this.itemSize = 15,
    this.hItemPadding = 4.0,
    this.vItemPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: rate,
      direction: Axis.horizontal,
      allowHalfRating: false,
      textDirection: TextDirection.rtl,
      itemCount: 5,
      itemSize: itemSize,
      ignoreGestures: ignoreGestures??false,
      ratingWidget: RatingWidget(
        full: _buildImage("full_star"),
        empty: _buildImage(ThemeCubit.of(context).isDark?"empty_star_dark":"empty_star",),
        half: _buildImage("empty_star"),
      ),
      itemPadding: EdgeInsets.symmetric(
          horizontal: hItemPadding, vertical: vItemPadding),
      onRatingUpdate: onRate == null ? (_) {} : onRate!,
    );
  }

  Widget _buildImage(String icon,) => Image.asset(
        getAsset(icon),
        fit: BoxFit.scaleDown,
        // color: color,
        height: 15,
        width: 15,
      );
}
