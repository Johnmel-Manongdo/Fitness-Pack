import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:fitness_pack/constants/Constantcolors.dart';
import 'package:fitness_pack/screens/AltProfile/AltProfile.dart';
import 'package:fitness_pack/screens/Homepage/Homepage.dart';
import 'package:fitness_pack/services/Authentication.dart';
import 'package:fitness_pack/services/FirebaseOperations.dart';
import 'package:fitness_pack/utils/PostOptions.dart';

class AltProfieHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: Homepage(), type: PageTransitionType.bottomToTop));
        },
      ),
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(EvaIcons.moreVertical, color: constantColors.whiteColor),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: Homepage(), type: PageTransitionType.bottomToTop));
          },
        ),
      ],
      title: RichText(
        text: TextSpan(
            text: 'The',
            style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            children: <TextSpan>[
              TextSpan(
                text: ' Social',
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              )
            ]),
      ),
    );
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 220.0,
                width: 200.0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        radius: 60.0,
                        backgroundImage:
                            NetworkImage(snapshot.data.data()['userimage']),
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
                      padding: const EdgeInsets.only(top: 8.0),
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
                                    fontSize: 12.0)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 190.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              checkFollowersSheet(context, snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: constantColors.darkColor,
                                  borderRadius: BorderRadius.circular(15.0)),
                              height: 70.0,
                              width: 80.0,
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
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          return new Text(
                                              snapshot.data.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 28.0));
                                        }
                                      }),
                                  Text('Followers',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: constantColors.darkColor,
                                borderRadius: BorderRadius.circular(15.0)),
                            height: 70.0,
                            width: 80.0,
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
                                            snapshot.data.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28.0));
                                      }
                                    }),
                                Text('Following',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0)),
                              ],
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
                        height: 70.0,
                        width: 80.0,
                        child: Column(
                          children: [
                            Text('0',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.0)),
                            Text('Posts',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                    color: constantColors.blueColor,
                    child: Text('Follow',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                    onPressed: () {
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .followUser(
                              userUid,
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              {
                                'username': Provider.of<FirebaseOperations>(
                                        context,
                                        listen: false)
                                    .getInitUserName,
                                'userimage': Provider.of<FirebaseOperations>(
                                        context,
                                        listen: false)
                                    .getInitUserImage,
                                'useruid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                'useremail': Provider.of<FirebaseOperations>(
                                        context,
                                        listen: false)
                                    .getInitUserEmail,
                                'time': Timestamp.now()
                              },
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              userUid,
                              {
                                'username': snapshot.data.data()['username'],
                                'userimage': snapshot.data.data()['userimage'],
                                'useremail': snapshot.data.data()['useremail'],
                                'useruid': snapshot.data.data()['useruid'],
                                'time': Timestamp.now()
                              })
                          .whenComplete(() {
                        followedNotification(
                            context, snapshot.data.data()['username']);
                      });
                    }),
                MaterialButton(
                    color: constantColors.blueColor,
                    child: Text('Message',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                    onPressed: () {})
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

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(FontAwesomeIcons.userAstronaut,
                    color: constantColors.yellowColor, size: 16),
                Text('Recently Added',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: constantColors.whiteColor))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.darkColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15.0)),
            ),
          )
        ],
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
                .doc(snapshot.data.data()['useruid'])
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
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Text('Followed $name',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0)),
          );
        });
  }

  checkFollowersSheet(BuildContext context, dynamic snapshot) {
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
                    .collection('followers')
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
                              if (documentSnapshot.data()['useruid'] !=
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid) {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: AltProfile(
                                          userUid: documentSnapshot
                                              .data()['useruid'],
                                        ),
                                        type: PageTransitionType.leftToRight));
                              }
                            },
                            trailing: documentSnapshot.data()['useruid'] ==
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid
                                ? Container(
                                    width: 0.0,
                                    height: 0.0,
                                  )
                                : MaterialButton(
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
