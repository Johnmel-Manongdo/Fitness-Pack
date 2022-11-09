import 'package:fitness_pack/screens/Training/model/exercise.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onInitialized;

  const VideoPlayerWidget({
    @required this.exercise,
    @required this.onInitialized,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset(widget.exercise.videoUrl)
      ..initialize().then((value) {
        controller.setLooping(false);
        controller.play();
        controller.pause();

        widget.exercise.controller = controller;
        widget.onInitialized();
      });
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Color(0xFF100E20),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 100,
              bottom: 200,
            ),
            child: controller.value.initialized
                ? VideoPlayer(controller)
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      );
}
