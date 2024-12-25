import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBubble extends StatefulWidget {
  final String videoUrl;
  final bool isNetwork;

  VideoBubble({required this.videoUrl, this.isNetwork = true});

  @override
  _VideoBubbleState createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble> {
  VideoPlayerController? _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = widget.isNetwork
        ? VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        : VideoPlayerController.file(File(widget.videoUrl));
    try {
      await _controller!.initialize();
      setState(() {});
    } catch (e) {
      setState(() {
        _isError = true;
      });
      print('Error initializing video player: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isError
        ? Center(child: Text('Error loading video'))
        : _controller!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  children: [
                    VideoPlayer(_controller!),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Icon(
                            _controller!.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 50.0,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator());
  }
}
