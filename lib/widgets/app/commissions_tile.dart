import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';

class CommissionTile extends StatelessWidget {
  const CommissionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kGreyColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.moneyBill1,
                size: 14,
              ),
              SizedBox(width: 10),
              Text(
                '11/10/2020',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kDarkGreyColor,
                    fontSize: 12),
              )
            ],
          ),
          Row(
            children: [
              Text(
                ' سعر البيع ',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kDarkGreyColor,
                    fontSize: 12),
              ),
              SizedBox(width: 5),
              Text(
                '150',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                    fontSize: 16),
              ),
              SizedBox(width: 5),
              Text(
                'SAR',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                    fontSize: 12),
              ),
              SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Material(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Icon(
                        FontAwesomeIcons.circleMinus,
                        size: 12,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
