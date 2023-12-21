import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class videoBox extends StatefulWidget {
  String Video;
  videoBox(this.Video);
  @override
  State<videoBox> createState() => _videoBoxState(Video);

}

class _videoBoxState extends State<videoBox> {
  String? Video;
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  _videoBoxState(this.Video);

  @override
  void initState(){
    super.initState();
    videoPlayerController = VideoPlayerController.network(Video!);
    videoPlayerController.initialize().then((value) =>
        setState((){

        }));

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: videoPlayerController.value.aspectRatio,
      autoPlay: false,
      looping: false,
      // autoInitialize:true
    );

  }
  @override
  Widget build(BuildContext context) {
    return
      videoPlayerController.value.isInitialized == true ? AspectRatio(
        aspectRatio: videoPlayerController.value.aspectRatio,
        child : Stack(
          children:[
            videoPlayerController.value.isInitialized == true ?
            VideoPlayer(videoPlayerController):Container(),

            Chewie(
              controller:ChewieController(
                videoPlayerController: videoPlayerController,
                aspectRatio: videoPlayerController.value.aspectRatio,
                autoPlay: false,
                looping: false,
                autoInitialize:true
              ),
            ),

          ],
        ),

      ) :const CircularProgressIndicator();
  }
}