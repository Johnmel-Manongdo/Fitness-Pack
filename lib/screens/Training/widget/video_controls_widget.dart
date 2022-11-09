import 'package:fitness_pack/screens/Training/model/exercise.dart';
import 'package:flutter/material.dart';

class VideoControlsWidget extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onRewindVideo;
  final VoidCallback onNextVideo;
  final ValueChanged<bool> onTogglePlaying;

  const VideoControlsWidget({
    @required this.exercise,
    @required this.onRewindVideo,
    @required this.onNextVideo,
    @required this.onTogglePlaying,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.95),
        ),
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildText(
                  title: 'Duration',
                  value: '${exercise.duration.inSeconds} Seconds',
                ),
                buildText(
                  title: 'Reps',
                  value: '${exercise.noOfReps} times',
                ),
              ],
            ),
            buildButtons(context),
          ],
        ),
      );

  Widget buildText({
    @required String title,
    @required String value,
  }) =>
      Column(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      );

  Widget buildButtons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.fast_rewind,
              color: Colors.black87,
              size: 35,
            ),
            onPressed: onRewindVideo,
          ),
          buildPlayButton(context),
          IconButton(
            icon: Icon(
              Icons.fast_forward,
              color: Colors.black87,
              size: 35,
            ),
            onPressed: onNextVideo,
          ),
        ],
      );

  Widget buildPlayButton(BuildContext context) {
    final isLoading =
        exercise.controller == null || !exercise.controller.value.initialized;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (exercise.controller.value.isPlaying) {
      return buildButton(
        context,
        icon: Icon(Icons.pause, size: 40, color: Colors.white),
        onClicked: () => onTogglePlaying(false),
      );
    } else {
      return buildButton(
        context,
        icon: Icon(Icons.play_arrow, size: 40, color: Colors.white),
        onClicked: () => onTogglePlaying(true),
      );
    }
  }

  Widget buildButton(
    BuildContext context, {
    @required Widget icon,
    @required VoidCallback onClicked,
  }) =>
      GestureDetector(
        onTap: onClicked,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.blueAccent,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 34,
            backgroundColor: Colors.blueAccent,
            child: icon,
          ),
        ),
      );
}
