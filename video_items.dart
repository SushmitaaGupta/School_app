import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatefulWidget {
  VideoPlayerController? videoPlayerController;
  final bool? looping;
  final bool? autoplay;

  VideoItems({
    @required this.videoPlayerController,
    this.looping, this.autoplay,
    Key? key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      controlsSafeAreaMinimum: EdgeInsets.all(0),
      maxScale: 1,
      showControlsOnInitialize: true,
      allowFullScreen: true,
      videoPlayerController: widget.videoPlayerController!,
      aspectRatio: widget.videoPlayerController!.value.aspectRatio,
      autoInitialize: true,
      autoPlay: widget.autoplay!,
      showControls: true,
      looping: widget.looping!,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
        controller: _chewieController!,

    );
  }

}