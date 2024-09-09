import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/snack_bar.dart';
import 'package:silah/widgets/starter_divider.dart';
import 'package:silah/widgets/text_form_field.dart';

import '../../../core/router/router.dart';
import '../../../widgets/rate_widget.dart';

showRateDialog(
    {required storeId,
    required String storeName,
    double? rate,
    String? rateId}) {
  showCupertinoDialog(
  
      context: RouteManager.currentContext,
      barrierDismissible: true,
      builder: (_) => _Dialog(
            storeId: storeId,
            storeName: storeName,
            rating: rate,
            rateId: rateId,
          ));
}

class _Dialog extends StatefulWidget {
  final String storeId;
  final String storeName;
  final double? rating;
  final String? rateId;
  // final
  const _Dialog(
      {Key? key,
      required this.storeId,
      this.rating,
      required this.storeName,
      this.rateId})
      : super(key: key);

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  double rating = 0;
  String comment = 'asdasdasd';
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.rating${widget.rating}');
    if (widget.rating!= null) {
      rating = widget.rating!;
    }
  }
  void rate() async {
    setState(() => isLoading = true);
    try {
      final response = await DioHelper.post(
        'customer/account/rating_add',
        data: {
          'customer_id': AppStorage.getUserModel()?.customerId,
          'advertizer_id': widget.storeId,
          'rating': rating,
          'comment': comment,
        },
      );
    print( 'customer/account/rating_add${response.data}');
      if (response.data['success'] == true) {
        showSnackBar('تم ارسال تقييمكم بنجاح!');
      } else {
        showSnackBar(response.data['message'], errorMessage: true);
      }
    } catch (e) {
      showSnackBar('فشل التقييم!', errorMessage: true);
    }
    RouteManager.pop();
    setState(() => isLoading = false);
  }

  void updateRate() async {
    setState(() => isLoading = true);
    try {
      final response = await DioHelper.post(
        'customer/account/update_rating',
        data: {
          'customer_id': AppStorage.getUserModel()?.customerId,
          // 'advertizer_id': widget.storeId,
          'rating_id': widget.rateId,
          'rating': rating,
          'comment': comment,
        },
      );
          print('update_rating${response.data}');

      if (response.data['success'] == true) {
        showSnackBar('تم ارسال تقييمكم بنجاح!');
      } else {
        showSnackBar(response.data['message'], errorMessage: true);
      }
    } catch (e) {
      showSnackBar('فشل التقييم!', errorMessage: true);
    }
    RouteManager.pop();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          StarterDivider(width: 50),
          const SizedBox(height: 10),
          Text("اضغط على النجوم للتقييم"),
          RateWidget(
            
            rate: rating,
            hItemPadding: 0,
            itemSize: 20,
            onRate: (v) => rating = v,

          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: InputFormField(
              hint: "كتابة التعليقات ..",
              // controller: ,
              fillColor: Theme.of(context).appBarTheme.backgroundColor,
              onChanged: (newComment) {
                comment = newComment;
                print(comment);
              },
              hasBorder: true,
              multiLine: true,
              maxLines: 6,
            ),
          ),
          isLoading
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: LoadingIndicator(),
                )
              : ConfirmButton(
                  title: "إرسال",
                  onPressed: widget.rating != null ? updateRate : rate,
                  color: activeButtonColor,
                ),
          const SizedBox(height: 10),
        ],
      ),
      //Text('تقييم المعلن\n${widget.storeName}'),
    );
  }
}
