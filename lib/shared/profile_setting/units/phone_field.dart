part of '../view.dart';

class _PhoneField extends StatelessWidget {
  const _PhoneField({Key? key, required this.cubit}) : super(key: key);

  final EditProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    final modifiedTelephone = AppStorage.getUserModel()?.modifiedTelephone;
    final modificationInterval =
        AppStorage.getUserModel()?.modificationInterval;
    final isPhoneVerified = modifiedTelephone == null;
    final color = isPhoneVerified ? Colors.green : Colors.red;
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: InputFormField(
                  controller: cubit.telephoneController,
                  upperText: 'الجوال',
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  validator: Validator.phoneNumber,

                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  isNumber: true,
                  onChanged: (_) => cubit.checkInputsValidity(),
                  maxLength: 10,
                  onTap: modificationInterval == null
                      ? null
                      : () {
                          showCupertinoDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => GestureDetector(
                              onTap: RouteManager.pop,
                              child: CupertinoAlertDialog(
                                content: Text(
                                    "لا يمكنك تعديل رقم الجوال الا بعد مرور $modificationInterval أيام"),
                                actions: [],
                              ),
                            ),
                          );
                        },
                  suffixIcon: InkWell(
                    onTap: isPhoneVerified
                        ? null
                        : () {
                            RouteManager.navigateAndPopUntilFirstPage(
                                VerifyView(
                              customerId: AppStorage.customerID,
                              telephone: modifiedTelephone,
                              customerGroup:
                                  AppStorage.getUserModel()!.customerGroup!,
                              reverifying: true,
                            ));
                          },
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.only(bottom: 2, left: 15, right: 8),
                      alignment: Alignment.center,
                      child: Icon(
                        isPhoneVerified
                            ? FontAwesomeIcons.check
                            : FontAwesomeIcons.question,
                        color: color,
                        size: 10,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: activeSwitchColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: color,
                            spreadRadius: 1.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Icon(
                  //   FontAwesomeIcons.pen,
                  //   color: kGreyColor,
                  //   size: 16,
                  // ),
                ),
              ),
            ],
          ),
          if (!isPhoneVerified)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'الرجاء إدخال رمز التحقق المرسل اليك',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      );
    });
  }
}
