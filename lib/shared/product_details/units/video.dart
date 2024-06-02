part of '../view.dart';

class _VideoBubble extends StatefulWidget {
  const _VideoBubble({required this.filePath});

  final String filePath;

  @override
  State<_VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<_VideoBubble> {
  double get aspectRatio => sizeFromWidth(1) / sizeFromHeight(1.5);

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        _controller.setVolume(1.0);
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return InkWell(
        onTap: () {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        },
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: VideoPlayer(_controller),
        ),
      );
    }
    return UnconstrainedBox(child: LoadingIndicator());
  }
}
