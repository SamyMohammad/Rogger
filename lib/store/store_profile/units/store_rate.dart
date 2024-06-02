import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/widgets/rate_widget.dart';

class StoreRate extends StatelessWidget {
  const StoreRate({Key? key, this.rating, this.totalRatingCount})
      : super(key: key);
  final int? rating;
  final String? totalRatingCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                rating == null ? '' : '( $rating )',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              RateWidget(
                rate: rating?.toDouble() ?? 0,
                itemSize: 15,
                hItemPadding: 0,
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            totalRatingCount == null ? '' : '( $totalRatingCount )',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
