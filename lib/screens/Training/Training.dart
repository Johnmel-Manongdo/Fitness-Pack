import 'package:fitness_pack/screens/Training/widget/exercises_widget.dart';
import 'package:fitness_pack/constants/Constantcolors.dart';
import 'package:flutter/material.dart';

class Training extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            buildAppBar(context),
            ExercisesWidget(),
          ],
        ),
      );

  SliverAppBar buildAppBar(BuildContext context) => SliverAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: constantColors.darkColor,
        stretch: true,
        title: RichText(
          text: TextSpan(
              text: 'My ',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              children: <TextSpan>[
                TextSpan(
                    text: "Exercises",
                    style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ))
              ]),
        ),
        centerTitle: true,
        pinned: true,
      );
}
