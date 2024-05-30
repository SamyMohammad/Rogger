import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/router/router.dart';

import 'message_bubble.dart';

class InfoBottomSheet extends StatelessWidget {
  const InfoBottomSheet({
    Key? key,
    required this.title,
    required this.info,
  }) : super(key: key);

  final String title;
  final String info;

  static void show({
    required String title,
    required String info,
  }) {
    print('InfoBottomSheetinfo$info');
    showModalBottomSheet(
      context: RouteManager.currentContext,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InfoBottomSheet(
        title: title,
        info: info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.63,
      child: Column(
        children: [
          SizedBox(height: 8),
          Container(
            width: 50,
            height: 0,
            decoration: BoxDecoration(
              color: kGreyColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).appBarTheme.backgroundColor,
            thickness: 0,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                HtmlEncodedText(
                  encodedText: info,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                // Text(
                //   info,
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: kPrimaryColor,
                //     fontWeight: FontWeight.bold,
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
    );
  }
}
