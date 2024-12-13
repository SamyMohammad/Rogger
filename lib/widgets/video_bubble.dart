import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoBubble extends StatefulWidget {
  final String? url; // URL of the video
  final String? file; // File path of the video
  final double? aspectRatio; // Aspect ratio of the video
  final Function(int duration)? onVideoLoaded; // Callback when video loads
  final Function()? onVideoFinished; // Callback when video finishes

  VideoBubble({
    this.url,
    this.file,
    this.aspectRatio,
    this.onVideoLoaded,
    this.onVideoFinished,
  });

  @override
  _VideoBubbleState createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble>
    with AutomaticKeepAliveClientMixin {
  late BetterPlayer betterPlayer;

  @override
  void initState() {
    super.initState();

    // Initialize BetterPlayer based on the provided input (file or URL)
    betterPlayer = widget.file != null
        ? _createBetterPlayerFromFile(widget.file!)
        : _createBetterPlayerFromUrl(widget.url!);

    // Attach listeners for video events
    if (widget.onVideoLoaded != null || widget.onVideoFinished != null) {
      betterPlayer.controller.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          // Notify the video duration when loaded
          if (widget.onVideoLoaded != null) {
            final duration = betterPlayer
                    .controller.videoPlayerController?.value.duration
                    ?.inSeconds ??
                0;
            widget.onVideoLoaded!(duration);
          }
        } else if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
          // Notify when video finishes
          widget.onVideoFinished?.call();
        }
      });
    }
  }

  BetterPlayer _createBetterPlayerFromFile(String filePath) {
    return BetterPlayer.file(
      filePath,
      betterPlayerConfiguration: _betterPlayerConfiguration(),
    );
  }

  BetterPlayer _createBetterPlayerFromUrl(String url) {
    return BetterPlayer.network(
      url,
      betterPlayerConfiguration: _betterPlayerConfiguration(),
    );
  }

  BetterPlayerConfiguration _betterPlayerConfiguration() {
    return BetterPlayerConfiguration(
      aspectRatio: widget.aspectRatio,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      eventListener: (event) {
        if (event.betterPlayerEventType ==
            BetterPlayerEventType.hideFullscreen) {
          // Enforce portrait orientation after fullscreen
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp]);
        }
      },
    );
  }

  @override
  void dispose() {
    betterPlayer.controller.dispose(); // Dispose the player controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return betterPlayer;
  }

  @override
  bool get wantKeepAlive => true; // Keep the widget alive
}
