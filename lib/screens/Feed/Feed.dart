import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_pack/constants/Constantcolors.dart';
import 'package:fitness_pack/screens/Feed/FeedHelpers.dart';

class Feed extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constantColors.blueGreyColor,
        drawer: Drawer(),
        appBar:
            Provider.of<FeedHelpers>(context, listen: false).appBar(context),
        body:
            Provider.of<FeedHelpers>(context, listen: false).feedBody(context));
  }
}
