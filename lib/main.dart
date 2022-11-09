import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_pack/screens/Chatroom/ChatroomHelper.dart';
import 'package:fitness_pack/screens/Messaging/GroupMessageHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_pack/constants/Constantcolors.dart';
import 'package:fitness_pack/screens/Altprofile/AltProfileHelper.dart';
import 'package:fitness_pack/screens/Feed/FeedHelpers.dart';
import 'package:fitness_pack/screens/Homepage/HomepageHelpers.dart';
import 'package:fitness_pack/screens/LandingPage/landingHelpers.dart';
import 'package:fitness_pack/screens/LandingPage/landingServices.dart';
import 'package:fitness_pack/screens/LandingPage/landingUtils.dart';
import 'package:fitness_pack/screens/Profile/ProfileHelpers.dart';
import 'package:fitness_pack/screens/Splashscreen/splashScreen.dart';
import 'package:fitness_pack/services/Authentication.dart';
import 'package:fitness_pack/services/FirebaseOperations.dart';
import 'package:fitness_pack/utils/PostOptions.dart';
import 'package:fitness_pack/utils/UploadPost.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
        child: MaterialApp(
          home: Splashscreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              accentColor: constantColors.blueColor,
              fontFamily: 'Poppins',
              canvasColor: Colors.transparent),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => GroupMessagingHelper()),
          ChangeNotifierProvider(create: (_) => ChatroomHelper()),
          ChangeNotifierProvider(create: (_) => AltProfieHelper()),
          ChangeNotifierProvider(create: (_) => PostFunctions()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => UploadPost()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => HomepageHelpers()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => LandingService()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingHelpers())
        ]);
  }
}
