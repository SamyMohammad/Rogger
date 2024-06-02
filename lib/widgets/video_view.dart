import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/constants.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/snack_bar.dart';
import 'package:video_player/video_player.dart';

import '../core/router/router.dart';

class VideoView extends StatefulWidget {
  const VideoView({Key? key, required this.url, required this.network})
      : super(key: key);

  final String url;
  final bool network;

  static void show({required String url, bool network = true}) =>
      RouteManager.navigateTo(VideoView(
        network: network,
        url: url,
      ));

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _controller;

  bool showActions = true;
  bool fullscreenMode = false;
  bool replaying = false;

  @override
  void initState() {
    super.initState();
    _controller = (widget.network
        ? VideoPlayerController.networkUrl(Uri.parse(widget.url))
        : VideoPlayerController.file(File(widget.url)));
    _controller.initialize().then((_) {
      _controller.play();
      toggleActions();
    }).catchError((e) {
      RouteManager.pop();
      showSnackBar(
          _controller.value.errorDescription ?? 'Something went wrong');
    });
    _controller.addListener(() {
      rebuild;
      if (replaying) {
        replaying = false;
        Future.delayed(Duration(milliseconds: 150), () {
          _controller.pause().then((value) => _controller.play());
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleActions() {
    if (showActions) {
      showActions = false;
      rebuild;
      return;
    }
    showActions = true;
    rebuild;
    Future.delayed(Duration(seconds: 10), () {
      showActions = false;
      rebuild;
    });
  }

  void get rebuild {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: fullscreenMode ? 1 : 0,
      child: Scaffold(
        backgroundColor: kAccentColor,
        body: _controller.value.isInitialized
            ? Stack(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: toggleActions,
                      child: RotatedBox(
                        quarterTurns: 0, //rotated ? 1 : 0,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                  ),
                  if (showActions)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: appBar(
                        title: "Video Player",
                        // titleColor: kWhiteColor,
                        // backgroundColor: kBlackColor.withOpacity(0.5),
                        leading: BackButton(),
                        actions: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    fullscreenMode ? topDevicePadding : 0),
                            child: IconButton(
                              icon: Icon(fullscreenMode
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen),
                              onPressed: () {
                                fullscreenMode = !fullscreenMode;
                                rebuild;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (showActions)
                    Center(
                      child: InkWell(
                        onTap: () {
                          replaying = _controller.value.position.inSeconds ==
                              _controller.value.duration.inSeconds;
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: kAccentColor,
                          child: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (showActions)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: null,
                      child: Container(
                        color: kAccentColor.withOpacity(0.5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    convertSecondsIntoTime(
                                        _controller.value.position.inSeconds),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    convertSecondsIntoTime(
                                        _controller.value.duration.inSeconds),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Slider(
                              min: 0.0,
                              max: _controller.value.duration.inMicroseconds +
                                  0.0,
                              value: _controller.value.position.inMicroseconds +
                                  0.0,
                              thumbColor: kAccentColor,
                              activeColor: kAccentColor,
                              inactiveColor: kAccentColor.withOpacity(0.25),
                              onChanged: (value) => _controller.seekTo(
                                  Duration(microseconds: value.toInt())),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 1)),
      ),
    );
  }
}

class VideoPlayerThumbnail extends StatefulWidget {
  const VideoPlayerThumbnail(
      {Key? key, required this.url, required this.network})
      : super(key: key);

  final String url;
  final bool network;

  @override
  State<VideoPlayerThumbnail> createState() => _VideoPlayerThumbnailState();
}

class _VideoPlayerThumbnailState extends State<VideoPlayerThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = (widget.network
        ? VideoPlayerController.networkUrl(Uri.parse(widget.url))
        : VideoPlayerController.file(File(widget.url)));
    _controller.initialize().then((_) {
      Future.delayed(
        Duration(milliseconds: 200),
        () => setState(() {}),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => VideoView.show(url: widget.url, network: widget.network),
      child: Container(
        height: 185,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: VideoPlayer(_controller),
            ),
            Center(
              child:
                  Icon(FontAwesomeIcons.solidCirclePlay, color: Colors.white),
            ),
            // Center(child: Image.asset(getAsset('video_play_button'))),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
