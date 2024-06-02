import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:silah/core/app_storage/app_storage.dart';

import '../../constants.dart';

class OnlineStatusTile extends StatelessWidget {
  const OnlineStatusTile({Key? key, required this.userID, this.chatID})
      : super(key: key);

  final String userID;
  final String? chatID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref('users/$userID').onValue,
        builder: (context, snapshot) {
          final data = snapshot.data?.snapshot.value as Map?;
          bool isOnline = data?['online'] as bool? ?? false;
          DateTime? lastSeen;
          if (data?['last_seen'] != null) {
            lastSeen = DateTime.fromMillisecondsSinceEpoch(data!['last_seen']);
          }
          String status = 'نشط الان';
          if (isOnline) {
            if (lastSeen != null &&
                DateTime.now().difference(lastSeen).inMinutes >=
                    ONLINE_MINUTES_COUNT_CHECKER) {
              isOnline = false;
              status =
                  'اخر ظهور ' + Jiffy.parseFromDateTime(lastSeen).fromNow();
            }
          } else {
            if (lastSeen != null) {
              status =
                  'اخر ظهور ' + Jiffy.parseFromDateTime(lastSeen).fromNow();
            } else {
              status = '';
            }
          }
          if (chatID == null) {
            return _tile(
              status: status,
              isOnline: isOnline,
            );
          }
          return StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref('chats/${AppStorage.customerID}/$chatID')
                  .onValue,
              builder: (context, snapshot) {
                final isTyping = (snapshot.data?.snapshot.value
                        as Map?)?['typing'] as bool? ??
                    false;
                return _tile(
                  status: isTyping ? 'يكتب الان...' : status,
                  isOnline: isOnline,
                );
              });
        });
  }

  Widget _tile({required bool isOnline, required String status}) {
    return Builder(
      builder: (context) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOnline)
              CircleAvatar(
                radius: 3,
                backgroundColor: Colors.green,
              ),
            if (isOnline) SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                status,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 10,
                  height: 0.75,
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
