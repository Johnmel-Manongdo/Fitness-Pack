import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:fitness_pack/constants/Constantcolors.dart';
import 'package:fitness_pack/screens/AltProfile/AltProfile.dart';
import 'package:fitness_pack/screens/LandingPage/landingPage.dart';
import 'package:fitness_pack/services/Authentication.dart';
import 'package:fitness_pack/utils/PostOptions.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget headerProfile(BuildContext context, dynamic snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: CircleAvatar(
                          backgroundColor:
                              constantColors.darkColor.withOpacity(0.5),
                          radius: 60.0,
                          backgroundImage:
                              NetworkImage(snapshot.data.data()['userimage']),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(snapshot.data.data()['username'],
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(EvaIcons.email,
                          color: constantColors.greenColor, size: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(snapshot.data.data()['useremail'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 8.0)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: constantColors.darkColor,
                            borderRadius: BorderRadius.circular(15.0)),
                        height: 60.0,
                        width: 70.0,
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(snapshot.data.data()['useruid'])
                                    .collection('followers')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return new Text(
                                        snapshot.data.docs.length.toString(),
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0));
                                  }
                                }),
                            Text('Followers',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkFollowingSheet(context, snapshot);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: constantColors.darkColor,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: 60.0,
                          width: 70.0,
                          child: Column(
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot.data.data()['useruid'])
                                      .collection('following')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      return new Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0));
                                    }
                                  }),
                              Text('Following',
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: constantColors.darkColor,
                        borderRadius: BorderRadius.circular(15.0)),
                    height: 60.0,
                    width: 70.0,
                    child: Column(
                      children: [
                        Text('1',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0)),
                        Text('Posts',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25.0,
        width: 350.0,
        child: Divider(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserUid)
                .collection('posts')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return new GridView(
                    children: snapshot.data.docs
                        .map((DocumentSnapshot documentSnapshot) {
                      return GestureDetector(
                        onTap: () {
                          showPostDetails(context, documentSnapshot);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              child: Image.network(
                                  documentSnapshot.data()['postimage']),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2));
              }
            }),
        height: MediaQuery.of(context).size.height * 0.53,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  logOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text('Log Out?',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
            actions: [
              MaterialButton(
                  child: Text('No',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          decoration: TextDecoration.underline,
                          decorationColor: constantColors.whiteColor)),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  color: constantColors.redColor,
                  child: Text('Yes',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      )),
                  onPressed: () {
                    Provider.of<Authentication>(context, listen: false)
                        .logOutViaEmail()
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: Landingpage(),
                              type: PageTransitionType.bottomToTop));
                    });
                  })
            ],
          );
        });
  }

  checkFollowingSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data.data()['useruid'])
                    .collection('following')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return new ListView(
                        children: snapshot.data.docs
                            .map((DocumentSnapshot documentSnapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return new ListTile(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                        userUid:
                                            documentSnapshot.data()['useruid'],
                                      ),
                                      type: PageTransitionType.topToBottom));
                            },
                            trailing: MaterialButton(
                              color: constantColors.blueColor,
                              child: Text('Unfollow',
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),
                              onPressed: () {},
                            ),
                            leading: CircleAvatar(
                              backgroundColor: constantColors.darkColor,
                              backgroundImage: NetworkImage(
                                documentSnapshot.data()['userimage'],
                              ),
                            ),
                            title: Text(
                              documentSnapshot.data()['username'],
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            subtitle: Text(
                              documentSnapshot.data()['useremail'],
                              style: TextStyle(
                                  color: constantColors.yellowColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ));
                      }
                    }).toList());
                  }
                }),
          );
        });
  }

  showPostDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.darkColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child:
                            Image.network(documentSnapshot.data()['postimage']),
                      )),
                  Text(documentSnapshot.data()['caption'],
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0)),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            Provider.of<PostFunctions>(context, listen: false)
                                .showLikes(context,
                                    documentSnapshot.data()['caption']);
                          },
                          onTap: () {
                            print('Adding like...');
                            Provider.of<PostFunctions>(context, listen: false)
                                .addLike(
                                    context,
                                    documentSnapshot.data()['caption'],
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid);
                          },
                          child: Icon(
                            FontAwesomeIcons.heart,
                            color: constantColors.redColor,
                            size: 22.0,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(documentSnapshot.data()['caption'])
                                .collection('likes')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)),
                                );
                              }
                            }),
                        Container(
                          width: 80.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showCommentsSheet(
                                          context,
                                          documentSnapshot,
                                          documentSnapshot.data()['caption']);
                                },
                                child: Icon(
                                  FontAwesomeIcons.comment,
                                  color: constantColors.blueColor,
                                  size: 22.0,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(documentSnapshot.data()['caption'])
                                      .collection('comments')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                            snapshot.data.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0)),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }
}
