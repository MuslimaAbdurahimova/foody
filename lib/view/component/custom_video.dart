import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideo extends StatefulWidget {
  final String videoUrl;

  const CustomVideo({Key? key, required this.videoUrl}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomVideoState createState() => _CustomVideoState();
}

class _CustomVideoState extends State<CustomVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  top: 0,
                  right: 0,
                  child: IconButton(
                      onPressed: () {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                        setState(() {});
                      },
                      icon: _controller.value.isPlaying
                          ? Icon(
                              Icons.pause,
                              color: Colors.red,
                              size: 32,
                            )
                          : Icon(
                              Icons.play_arrow,
                              color: Colors.red,
                              size: 32,
                            )),
                )
              ],
            ),
        )
        : Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.pinkAccent),
              color: Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
          );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
