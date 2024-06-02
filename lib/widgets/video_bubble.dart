import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoBubble extends StatefulWidget {
  final String? url;
  final String? file;
  final double? aspectRatio;
  final Function(int duration)? onVideoLoaded;
  final Function()? onVideoFinished;
  VideoBubble(
      {this.url,
      this.file,
      this.aspectRatio,
      this.onVideoLoaded,
      this.onVideoFinished});
  @override
  _VideoBubbleState createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble>
    with AutomaticKeepAliveClientMixin {
  late BetterPlayer betterPlayer;
  // VideoPlayerController? _controller;
  // FlickManager? flickManager;

  @override
  void initState() {
    betterPlayer = widget.file == null
        ? BetterPlayer.network(
            widget.url!,
            betterPlayerConfiguration: BetterPlayerConfiguration(
              deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
              eventListener: (v) {
                if (v.betterPlayerEventType ==
                    BetterPlayerEventType.hideFullscreen) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                }
              },
              aspectRatio: widget.aspectRatio,
            ),
          )
        : BetterPlayer.file(
            widget.file!,
            betterPlayerConfiguration: BetterPlayerConfiguration(
              deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
              eventListener: (v) {
                if (v.betterPlayerEventType ==
                    BetterPlayerEventType.hideFullscreen) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                }
              },
              aspectRatio: widget.aspectRatio,
            ),
          );
    if (widget.onVideoLoaded != null) {
      widget.onVideoLoaded!(
        betterPlayer
                .controller.videoPlayerController?.value.duration?.inSeconds ??
            0,
      );
      betterPlayer.controller.addEventsListener((v) {
        if (v.betterPlayerEventType == BetterPlayerEventType.finished) {
          if (widget.onVideoFinished != null) {
            widget.onVideoFinished!();
          }
        }
      });
    }
    // setState(() {});
    // _controller = (VideoPlayerController.network(widget.url))
    //   ..initialize().then((_) {
    //     if(this.mounted)
    //       setState(() {});
    //     flickManager = FlickManager(
    //       videoPlayerController: _controller!,
    //       autoPlay: false,
    //       autoInitialize: true,
    //     );
    //   });
    super.initState();
  }

  @override
  void dispose() {
    this.updateKeepAlive();
    // flickManager?.dispose();
    // _controller?.dispose();
    betterPlayer.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return betterPlayer;
    // return Stack(
    //     children: [
    //       Center(
    //         child: _controller != null && flickManager != null && _controller!.value.isInitialized ? FlickVideoPlayer(
    //           flickManager: flickManager!,
    //           preferredDeviceOrientationFullscreen: [
    //             DeviceOrientation.portraitUp,
    //           ],
    //         ) : null,
    //       ),
    //       if(_controller == null || flickManager == null || !_controller!.value.isInitialized && !_controller!.value.hasError)
    //         Positioned(
    //           top: 0,left: 0,
    //           bottom: 0,right: 0,
    //           child: LoadingIndicator(),
    //         ),
    //     ],
    // );
  }

  @override
  bool get wantKeepAlive => mounted;
}
