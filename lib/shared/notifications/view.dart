import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/notifications/cubit.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/login_to_continue_widget.dart';

import '../notification_details/view.dart';
import 'model.dart' as notificationModel;

class NotificationsView extends StatefulWidget {
  NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final cubit = NotificationsCubit()..getNotifications();

  @override
  Widget build(BuildContext context) {
    if (!AppStorage.isLogged) {
      return LoginToContinueWidget();
    }
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        appBar: appBar(title: 'الاشعارات'),
        body: BlocBuilder<NotificationsCubit, NotificationsStates>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return LoadingIndicator();
            }
            final notificationsModel = cubit.notificationsModel;
            if (notificationsModel == null) {
              return Center(
                child: Text(
                  'لا توجد اشعارات في الوقت الحالي',
                ),
              );
            }
            final admin = notificationsModel.adminNotifications;
            final suggestion = notificationsModel.suggestionNotifications;
            final inquiry = notificationsModel.inquiryNotifications;
            final communication = notificationsModel.communicationNotifications;
            return ListView(
              padding: VIEW_PADDING,
              children: [
                if (inquiry != null)
                  _card(
                    title: "الاستفسارات",
                    notifications: inquiry,
                  ),
                if (communication != null)
                  _card(
                    title: "الشكاوي",
                    notifications: communication,
                  ),
                if (suggestion != null)
                  _card(
                    title: "الاقتراحات",
                    notifications: suggestion,
                  ),
                if (admin != null)
                  _card(
                    title: "تنبيهات",
                    notifications: admin,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required notificationModel.Notifications notifications,
  }) {
    if (notifications.list?.isEmpty == true) {
      return SizedBox.shrink();
    }
    final item = notifications.list!.first;
    return InkWell(
      onTap: () {
        cubit.markAsRead(
            purpose: title == 'صلة'
                ? 0
                : title == 'الاستفسارات'
                    ? 1
                    : title == 'الشكاوي'
                        ? 2
                        : 3);
        notifications.unread = 0;
        setState(() {});
        RouteManager.navigateTo(NotificationDetailsView(
          title: title,
          notifications: notifications,
        ));
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).appBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(notifications.icon!),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          item.text ?? '',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Text(
                        customizeDateTimeFromNow(item.dateDiff!),
                        style: TextStyle(
                          fontSize: 10,
                          color: kDarkGreyColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 3,
            left: 3,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (notifications.unread ?? 0) > 0
                      ? Colors.red
                      : Colors.transparent,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
