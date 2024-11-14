import 'package:drag_down_to_pop/drag_down_to_pop.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/store/add_status/view.dart';

import '../../constants.dart';
import '../../core/app_storage/app_storage.dart';
import '../../store/manage_my_status/view.dart';
import '../../store/status_details/model.dart';
import '../../store/status_details/view.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    Key? key,
    required this.userID,
    required this.image,
    required this.width,
    required this.height,
    this.onTap,
    this.onlineDotRadius = 8,
  }) : super(key: key);

  final String userID;
  final String image;
  final double width;
  final double height;
  final double onlineDotRadius;
  final VoidCallback? onTap;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  StatusModel? statusModel;

  @override
  void initState() {
    getStatus();
    super.initState();
  }

  void getStatus() {
    if (AppStorage.isLogged) {
      print('widget.userID ${widget.userID}');
      DioHelper.post(
        'provider/story/story_list',
        data: {
          'provider_id': widget.userID,
        },
      ).then((value) {
        try {
          statusModel = StatusModel.fromJson(value.data);
          print('value.data ${value.data}');
          statusModel?.stories = statusModel?.stories?.reversed.toList();
          print('value.data ${value.data}');

          if (mounted) setState(() {});
        } catch (e) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ??
          () async {
            getStatus();

            if (widget.userID == AppStorage.customerID.toString()) {
              if (statusModel?.stories?.isNotEmpty == true) {
                RouteManager.navigateTo(
                    ManageMyStatusView(statusModel: statusModel!));
              } else {
                RouteManager.navigateTo(AddStatusView());
              }
            } else if (statusModel?.stories?.isNotEmpty == true) {
              print('statusModel?.stories ${widget.userID}');
              Navigator.push(
                context,
                ImageViewerPageRoute(
                    builder: (context) =>
                        StatusDetailsView(status: statusModel!.stories!)),
              );
              // Navigator.push(
              //   context,
              //   _createRoute(),
              // );
              // RouteManager.navigateTo(
              //     StatusDetailsView(status: statusModel!.stories!));
            }
          },
      child: Container(
        width: widget.width + 6,
        height: widget.height + 6,
        child: UnconstrainedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.width,
                height: widget.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.height / 2),
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      getAsset('person'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
              if (AppStorage.customerID.toString() != widget.userID)
                StreamBuilder<DatabaseEvent>(
                    stream: FirebaseDatabase.instance
                        .ref('users/${widget.userID}')
                        .onValue,
                    builder: (context, snapshot) {
                      final data = snapshot.data?.snapshot.value as Map?;
                      bool online = data?['online'] as bool? ?? false;
                      DateTime? lastSeen;
                      if (data?['last_seen'] != null) {
                        lastSeen = DateTime.fromMillisecondsSinceEpoch(
                            data!['last_seen']);
                      }
                      if (lastSeen != null &&
                          DateTime.now().difference(lastSeen).inMinutes >=
                              ONLINE_MINUTES_COUNT_CHECKER) {
                        online = false;
                      }
                      return online
                          ? Positioned(
                              left: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 8,
                                child: CircleAvatar(
                                    backgroundColor: activeSwitchColor,
                                    radius: 6),
                              ),
                            )
                          : SizedBox();
                      //  Positioned(
                      //   bottom: 0,
                      //   left: 0,
                      //   child: CircleAvatar(
                      //     backgroundColor:
                      //         online ? Colors.green : Colors.transparent,
                      //     radius: widget.onlineDotRadius,
                      //   ),
                      // );
                    }),
            ],
          ),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: statusModel?.stories?.isNotEmpty == true
                ? Colors.blue
                : Colors.white,
            width: 3,
          ),
        ),
      ),
    );
  }
}

class ImageViewerPageRoute extends MaterialPageRoute {
  ImageViewerPageRoute({required WidgetBuilder builder})
      : super(builder: builder, maintainState: false);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return const DragDownToPopPageTransitionsBuilder()
        .buildTransitions(this, context, animation, secondaryAnimation, child);
  }

  @override
  bool canTransitionFrom(TransitionRoute previousRoute) {
    return false;
  }

  @override
  bool canTransitionTo(TransitionRoute nextRoute) {
    return false;
  }
}

class _DragDownUpToPopTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const _DragDownUpToPopTransition({
    Key? key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.0),
            end: const Offset(0.0, 1.0),
          ).animate(animation),
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null && details.primaryDelta! > 100) {
                Navigator.of(context).pop();
              }
            },
            child: child,
          ),
        ),
      ],
    );
  }
}
