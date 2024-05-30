import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/widgets/snack_bar.dart';

class BankAccountDetails extends StatelessWidget {
  const BankAccountDetails(
      {Key? key, this.accountNumber, this.iban, this.name, this.image})
      : super(key: key);
  final String? accountNumber;
  final String? image;
  final String? iban;
  final String? name;

  copyText(String text) {
    Clipboard.setData(
        ClipboardData(text: iban.toString())); // Copy the text to the clipboard
    showSnackBar("نسخ");
  }

  String addSpaceAfter4Chars(String input) {
    // Use regular expression to split the string into chunks of 4 characters
    // and then join them with a space between each chunk
    return input.splitMapJoin(
      RegExp('.{1,4}'),
      onMatch: (match) => '${match.group(0)} ',
      onNonMatch: (nonMatch) => '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.fromLTRB(24, 20, 14, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        boxShadow: ThemeCubit.of(context).isDark ? null : primaryBoxShadow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.network(
              image.toString(),
              width: 75,
              errorBuilder: (context, o, s) => SizedBox.shrink(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'رقم الحساب',
                style: TextStyle(fontSize: 12),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accountNumber.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF248DD1)),
                  ),
                  SizedBox(width: 14),
                  GestureDetector(
                      onTap: () {
                        copyText(accountNumber.toString());
                      },
                      child: SvgPicture.asset(
                        getIcon("copy"),
                        color: Theme.of(context).primaryColor,
                      ))
                ],
              )
            ],
          ),
          Text(
            'الايبان',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: kDarkGreyColor),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addSpaceAfter4Chars(iban.toString()),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: kLightGreyColorB4),
              ),
              SizedBox(width: 14),
              GestureDetector(
                  onTap: () {
                    copyText(iban.toString());
                  },
                  child: SvgPicture.asset(
                    getIcon("copy"),
                    color: Theme.of(context).primaryColor,
                  ))
            ],
          ),
          SizedBox(height: 8),
          Center(
              child: Text(
            name.toString(),
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            textAlign: TextAlign.center,
          )),
        ],
      ),
    );
  }
}
