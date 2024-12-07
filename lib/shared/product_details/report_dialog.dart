import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/snack_bar.dart';
import 'package:silah/widgets/starter_divider.dart';
import 'package:silah/widgets/text_form_field.dart';

import '../../shared_cubit/theme_cubit/cubit.dart';

showReportDialog(int productID) => showDialog(
      context: RouteManager.currentContext,
      builder: (context) => _Dialog(productID: productID),
    );
showReportDialogChat({required int chatId, required int reportedCustomerId}) =>
    showDialog(
      context: RouteManager.currentContext,
      builder: (context) => _Dialog(
        chatId: chatId,
        reportedCustomerId: reportedCustomerId,
      ),
    );

class _Dialog extends StatefulWidget {
  final int? productID;
  final int? chatId;
  final int? reportedCustomerId;
  const _Dialog(
      {Key? key, this.productID, this.chatId, this.reportedCustomerId})
      : super(key: key);

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  bool _isLoading = false;
  String message = '';

  void sendReport() async {
    setState(() => _isLoading = true);
    try {
      final response = await DioHelper.post(
        'common/product/report',
        data: {
          'product_id': widget.productID,
          'customer_id': AppStorage.customerID,
          'message': message
        },
      );

      RouteManager.pop();
      if (response.data.containsKey('success')) {
        showReportDialogs(response);
        // showSnackBar(response.data['success']);
      } else {
        throw Exception();
      }
    } catch (e) {
      showSnackBar('فشل ارسال الابلاغ!', errorMessage: true);
    }

    setState(() => _isLoading = false);
  }

  void sendReportChat() async {
    setState(() => _isLoading = true);
    try {
      final response = await DioHelper.post(
        'customer/account/reportChat',
        data: {
          'chat_id': widget.productID,
          'customer_id': AppStorage.customerID,
          'reported_customer_id': widget.reportedCustomerId,
          'message': message
        },
      );

      ResponseChatReport responseChatReport =
          ResponseChatReport.fromJson(response.data);

      RouteManager.pop();
      if (responseChatReport.data!.id != null) {
        showReportDialogs(response, isChat: true);
        // showSnackBar(response.data['success']);
      } else {
        throw Exception();
      }
    } catch (e) {
      showSnackBar('فشل ارسال الابلاغ!', errorMessage: true);
    }

    setState(() => _isLoading = false);
  }

  Future<dynamic> showReportDialogs(Response<dynamic> response,
      {bool isChat = false}) {
    ResponseChatReport? responseChatReport;
    if (isChat) {
      responseChatReport = ResponseChatReport.fromJson(response.data);
    }

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                StarterDivider(),
                const SizedBox(height: 10),
                Image.asset(getAsset("success"), height: 85, width: 85),
                const SizedBox(height: 10),
                Text(
                  "تم إرسال البلاغ",
                  style: TextStyle(
                      color: kLightGreyColor,
                      fontSize: 20,
                      fontFamily: 'IBMPlexSansArabic',
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
                Text(
                    isChat
                        ? 'RD-${responseChatReport?.data?.id}'
                        : 'RD-${response.data['report_id']}',
                    style: TextStyle(
                        color: kLightGreyColor,
                        fontSize: 14,
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 20),
                Text("الرجاء حفظ رقم التذكرة",
                    style: TextStyle(
                        color: kLightGreyColor,
                        fontSize: 14,
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 5),
                Text("والذي سيتم معالجته في غضون يومي عمل",
                    style: TextStyle(
                        color: kLightGreyColor,
                        fontSize: 14,
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 30),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const StarterDivider(),
            const SizedBox(height: 15),
            SvgPicture.asset(getIcon("report")),
            InputFormField(
              verticalMargin: 20,
              fillColor: Colors.transparent,
              hasBorder: true,
              hint: "اكتب بلاغك ..",
              isNext: false,
              onChanged: (v) {
                setState(() {
                  message = v;
                });
              },
            ),
            _isLoading
                ? LoadingIndicator()
                : ConfirmButton(
                    title: 'إرسـال',
                    fontColor:
                        message.isNotEmpty ? Colors.white : Color(0xFFA1A1A1),
                    color: message.isNotEmpty
                        ? activeButtonColor
                        : ThemeCubit.of(context).isDark
                            ? Color(0xFF1E1E26)
                            : Color(0xffFAFAFF),
                    // color: message.isEmpty ? kGreyButtonColorD9 : activeButtonColor,
                    onPressed: message.isEmpty
                        ? null
                        : widget.chatId != null
                            ? sendReportChat
                            : sendReport,
                  ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

class ResponseChatReport {
  Data? data;

  ResponseChatReport({this.data});

  ResponseChatReport.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;

  Data({this.id});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
