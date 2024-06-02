// import 'dart:async';
//
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:drag_down_to_pop/drag_down_to_pop.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:media_cache_manager/media_cache_manager.dart';
// import 'package:silah/widgets/video_view.dart';
//
// import '../../constants.dart';
// import '../../core/router/router.dart';
// import 'model.dart';
//
// class StatusDetailsView extends StatefulWidget {
//   StatusDetailsView({Key? key, required this.status, this.initialIndex = 0})
//       : super(key: key);
//
//   final List<Status> status;
//   final int initialIndex;
//
//   @override
//   State<StatusDetailsView> createState() => _StatusDetailsViewState();
// }
//
// class _StatusDetailsViewState extends State<StatusDetailsView> {
//   final CarouselController _controller = CarouselController();
//
//   double progress = 0;
//   int currentIndex = 0;
//   Timer? timer;
//   bool pauseStatus = false;
//
//   @override
//   void initState() {
//     currentIndex = widget.initialIndex;
//     restartTimer();
//     super.initState();
//   }
//
//   void restartTimer([int? index]) {
//     timer?.cancel();
//     progress = 0;
//     currentIndex = index ?? currentIndex;
//     setState(() {});
//     timer = Timer.periodic(Duration(milliseconds: 200), (_) {
//       if (pauseStatus) {
//         return;
//       }
//       progress += (0.05);
//       setState(() {});
//       if (progress > 1.0) {
//         progress = 0;
//         currentIndex++;
//         if (currentIndex >= widget.status.length) {
//           RouteManager.pop();
//         } else {
//           _controller.animateToPage(currentIndex);
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onVerticalDragUpdate: (details) {
//         Navigator.pop(context);
//       },
//       onLongPress: () => pauseStatus = true,
//       onLongPressEnd: (_) => pauseStatus = false,
//       onTapDown: (TapDownDetails details) {
//         double screenWidth = MediaQuery.of(context).size.width;
//         double tapPosition = details.globalPosition.dx;
//         if (tapPosition < screenWidth / 2) {
//           if (currentIndex + 1 == widget.status.length) {
//             Navigator.pushReplacement(
//                 context,
//                 SwipeablePageRoute(
//                   onlySwipeFromEdge: true,
//                   builder: (BuildContext context) =>
//                       MyHorizontallyScrollablePageContent(),
//                 ));
//             return;
//           }
//           final index = currentIndex + 1;
//           restartTimer(index);
//           _controller.animateToPage(index);
//         } else {
//           final index = currentIndex - 1 > 0 ? currentIndex - 1 : 0;
//           restartTimer(index);
//           _controller.animateToPage(index);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: kAccentColor,
//         body: Stack(
//           children: [
//             CarouselSlider(
//               carouselController: _controller,
//               items: widget.status.map((e) {
//                 if (e.attachmentType == 'video') {
//                   return DownloadMediaBuilder(
//                     url: e.attachment!,
//                     builder: (context, snapshot) {
//                       if (snapshot.status == DownloadMediaStatus.loading) {
//                         return CircularProgressIndicator(
//                           value: snapshot.progress,
//                           color: kAccentColor,
//                           valueColor: AlwaysStoppedAnimation(kPrimaryColor),
//                         );
//                       }
//                       if (snapshot.status == DownloadMediaStatus.success) {
//                         return Padding(
//                           padding: EdgeInsets.only(
//                             top: topDevicePadding,
//                             bottom: bottomDevicePadding,
//                           ),
//                           // child: VideoBubble(
//                           //   file: snapshot.filePath,
//                           //   aspectRatio: sizeFromWidth(1) /
//                           //       sizeFromHeight(1, removeAppBarSize: false),
//                           //   onVideoFinished: () => restartTimer(currentIndex + 1),
//                           // ),
//                           child: VideoPlayerThumbnail(
//                             url: snapshot.filePath!,
//                             network: false,
//                           ),
//                         );
//                       }
//                       return null;
//                     },
//                   );
//                 }
//                 return ClipRRect(
//                   borderRadius: BorderRadius.circular(0),
//                   child: Stack(
//                     children: <Widget>[
//                       Image.network(
//                         e.attachment.toString(),
//                         height: double.infinity,
//                         width: double.infinity,
//                         fit: BoxFit.fill,
//                       ),
//                       Container(
//                         height: double.infinity,
//                         width: double.infinity,
//                         color: Colors.black.withOpacity(0.8),
//                       ),
//                       Positioned.fill(
//                           bottom: 20,
//                           child: Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "24",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(width: 5),
//                                 SvgPicture.asset(
//                                   getIcon("view"),
//                                   color: Colors.white,
//                                 )
//                               ],
//                             ),
//                           )),
//                       Align(
//                         alignment: Alignment.center,
//                         child: Image.network(
//                           e.attachment.toString(),
//                           height: MediaQuery.of(context).size.height * .8,
//                           width: double.infinity,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               options: CarouselOptions(
//                 autoPlay: false,
//                 enableInfiniteScroll: false,
//                 autoPlayInterval: Duration(seconds: 5),
//                 reverse: false,
//                 height: MediaQuery.of(context).size.height,
//                 initialPage: currentIndex,
//                 viewportFraction: 1,
//                 enlargeCenterPage: false,
//                 onPageChanged: (index, reason) {
//                   currentIndex = index;
//                   restartTimer();
//                 },
//               ),
//             ),
//             Positioned(
//               top: topDevicePadding + 20,
//               left: 0,
//               right: 0,
//               child: Container(
//                 color: kAccentColor.withOpacity(0.2),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: widget.status.map((e) {
//                         int index = widget.status.indexOf(e);
//                         if (currentIndex != index) {
//                           return Expanded(
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 2),
//                               height: 4,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(6),
//                                 color: Colors.white.withOpacity(
//                                     currentIndex > index ? 1 : 0.2),
//                               ),
//                             ),
//                           );
//                         }
//                         return Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 2),
//                             child: TweenAnimationBuilder<double>(
//                               duration: Duration(milliseconds: 500),
//                               curve: Curves.linearToEaseOut,
//                               tween: Tween<double>(
//                                 begin: 0,
//                                 end: progress,
//                               ),
//                               builder: (context, value, _) => ClipRRect(
//                                 borderRadius: BorderRadius.circular(6),
//                                 child: LinearProgressIndicator(
//                                   value: value,
//                                   color: Colors.white,
//                                   backgroundColor:
//                                       Colors.white.withOpacity(0.2),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     SizedBox(height: 12),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Builder(builder: (context) {
//                             String time = '';
//                             try {
//                               final jiffy = Jiffy.parseFromDateTime(
//                                   widget.status[currentIndex].dateAdded!);
//                               time = jiffy.fromNow();
//                             } catch (_) {}
//                             return Text(
//                               time,
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             );
//                           }),
//                           InkWell(
//                             onTap: RouteManager.pop,
//                             child: Icon(
//                               FontAwesomeIcons.xmark,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ImageViewerPageRoute extends MaterialPageRoute {
//   ImageViewerPageRoute({required WidgetBuilder builder})
//       : super(builder: builder, maintainState: false);
//
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return const DragDownToPopPageTransitionsBuilder()
//         .buildTransitions(this, context, animation, secondaryAnimation, child);
//   }
//
//   @override
//   bool canTransitionFrom(TransitionRoute previousRoute) {
//     return false;
//   }
//
//   @override
//   bool canTransitionTo(TransitionRoute nextRoute) {
//     return false;
//   }
// }
