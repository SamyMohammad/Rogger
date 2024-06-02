import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/core/validator/validation.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/snack_bar.dart';
import 'package:silah/widgets/text_form_field.dart';
import 'package:silah/widgets/toast.dart';

class ChangeTelephoneDialog extends StatefulWidget {
  const ChangeTelephoneDialog(
      {Key? key,
      required this.telephone,
      required this.userID,
      required this.onTelephoneChanged})
      : super(key: key);

  final String telephone;
  final String userID;
  final Function(String) onTelephoneChanged;

  static void show({
    required String telephone,
    required String userID,
    required Function(String) onTelephoneChanged,
  }) =>
      showDialog(
        context: RouteManager.currentContext,
        builder: (context) => ChangeTelephoneDialog(
          onTelephoneChanged: onTelephoneChanged,
          telephone: telephone,
          userID: userID,
        ),
      );

  @override
  State<ChangeTelephoneDialog> createState() => _ChangeTelephoneDialogState();
}

class _ChangeTelephoneDialogState extends State<ChangeTelephoneDialog> {
  bool isLoading = false;
  TextEditingController? telephone;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    telephone = TextEditingController(text: widget.telephone);
    super.initState();
  }

  @override
  void dispose() {
    telephone?.dispose();
    super.dispose();
  }

  void changeTelephone() async {
    if (!formKey.currentState!.validate() ||
        telephone?.text == widget.telephone) return;
    closeKeyboard();
    setState(() => isLoading = true);
    try {
      final response = await DioHelper.post('common/home/check_phone', data: {
        'customer_id': widget.userID,
        'telephone': telephone?.text,
      });
      if (response.data['success']) {
        Navigator.pop(context);
        widget.onTelephoneChanged(telephone!.text);
        showSnackBar('تم تغيير رقم الجوال');
      } else {
        showToast('لم يتم تغيير رقم الجوال', color: Colors.red);
      }
    } catch (e) {}
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('تغيير رقم الجوال'),
      content: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: Form(
              key: formKey,
              child: InputFormField(
                upperText: "رقم الجوال",
                controller: telephone,
                validator: Validator.phoneNumber,
              ),
            ),
          ),
        ],
      ),
      actions: [
        Visibility(
          visible: !isLoading,
          replacement: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: LoadingIndicator(),
          ),
          child: Column(
            children: [
              CupertinoButton(
                child: Text('تأكيد', style: TextStyle(color: kPrimaryColor)),
                onPressed: changeTelephone,
              ),
              CupertinoButton(
                child:
                    Text('الغاء', style: TextStyle(color: Colors.red.shade700)),
                onPressed: RouteManager.pop,
              ),
            ],
          ),
        )
      ],
    );
  }
}
