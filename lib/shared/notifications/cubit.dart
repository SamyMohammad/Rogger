import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared/notifications/model.dart';
import 'package:silah/widgets/snack_bar.dart';

import '../../constants.dart';

part 'states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsCubit() : super(NotificationsInit());

  static NotificationsCubit of(context) => BlocProvider.of(context);

  NotificationsModel? notificationsModel;

  Future<void> getNotifications() async {
    emit(NotificationsLoading());
    try {
      final response = await DioHelper.post(
        'account/notifications',
        data: {'logged': true, 'customer_id': AppStorage.customerID},
      );
      notificationsModel = NotificationsModel.fromJson(response.data);
    } catch (e) {
      showSnackBar(DefaultErrorMessage, errorMessage: true);
    }
    emit(NotificationsInit());
  }

  /// 0: صلة - 1: استفسار - 2: البلاغات - 3: الاقتراحات
  Future<void> markAsRead({required int purpose}) async {
    try {
      await DioHelper.post(
        'account/set_notifications_status',
        data: {
          'logged': 'true',
          'customer_id': AppStorage.customerID,
          'purpose': purpose,
        },
      );
    } catch (e) {}
  }
}
