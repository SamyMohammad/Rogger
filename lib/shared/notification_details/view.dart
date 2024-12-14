import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/widgets/app_bar.dart';

import '../notifications/model.dart' as notificationsModel;

class NotificationDetailsView extends StatelessWidget {
  const NotificationDetailsView(
      {Key? key, required this.title, required this.notifications})
      : super(key: key);

  final String title;
  final notificationsModel.Notifications notifications;

  @override
  Widget build(BuildContext context) {
    final notifications = this.notifications.list ?? [];
    return Scaffold(
      appBar: appBar(
        title: title,
      ),
      body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: notifications.length,
                  padding: VIEW_PADDING,
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UnconstrainedBox(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: sizeFromWidth(3.5),
                              maxWidth: sizeFromWidth(1.3),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.text ?? '',
                                    style: TextStyle(color: kPrimary1Color),
                                  ),
                                  Text(
                                    customizeDateTimeFromNow(item.dateDiff!),
                                    style: TextStyle(
                                      color: kDarkGreyColor,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 199, 199, 199),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'لا يمكن الارسال للجهة',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  color: Theme.of(context).appBarTheme.backgroundColor),
            ],
          )),
    );
  }
}
