import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_pack/constants/Constantcolors.dart';
import 'package:fitness_pack/screens/Messaging/GroupMessage.dart';
import 'package:fitness_pack/services/Authentication.dart';
import 'package:fitness_pack/services/FireBaseOperations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ChatroomHelper with ChangeNotifier {
  String chatroomID;
  String get getChatroomID => chatroomID;
  ConstantColors constantColors = ConstantColors();
  final TextEditingController chatroomNameController = TextEditingController();

  showChatroomDetails(BuildContext context, DocumentSnapshot documentSnapshot){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height * 0.27,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.blueGreyColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0)
          )
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150.0),
              child: Divider(
                color: constantColors.whiteColor,
                thickness: 4.0,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: constantColors.blueColor),
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Members',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              )
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: constantColors.yellowColor),
                  borderRadius: BorderRadius.circular(12.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Admin',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              )
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: constantColors.transparent,
                    backgroundImage: NetworkImage(documentSnapshot.data()['userimage']),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(documentSnapshot.data()['username'],
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                      ),),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  showCreateChatroomSheet(BuildContext context){

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context){
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  color: constantColors.whiteColor,
                  thickness: 4.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: chatroomNameController,
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                          hintText: "Enter Chatroom Name",
                          hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          )
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: constantColors.blueGreyColor,
                    child: Icon(FontAwesomeIcons.plus,
                      color: constantColors.yellowColor,),
                    onPressed: () async{
                      Provider.of<FirebaseOperations>(context, listen: false).submitChatroomData(
                          chatroomNameController.text,
                          {
                            'time': Timestamp.now(),
                            'roomname': chatroomNameController.text,
                            'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
                            'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
                            'useremail': Provider.of<FirebaseOperations>(context, listen: false).getInitUserEmail,
                            'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
                          }).whenComplete((){
                            Navigator.pop(context);
                      });
                    },
                  )
                ],
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              )
          ),
        ),
      );
    });
  }

  showChatrooms(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: SizedBox(
              height: 200.0,
              width: 200.0,
              child: Lottie.asset('assets/animations/loading.json'),
            ),
          );
        } else {
          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot){
              return ListTile(
                onTap: (){
                  Navigator.pushReplacement(context, PageTransition(
                      child: GroupMessage(
                        documentSnapshot: documentSnapshot,
                      ), type: PageTransitionType.leftToRight));
                },
                onLongPress: (){
                  showChatroomDetails(context, documentSnapshot);
                },
                title: Text(documentSnapshot.data()['roomname'],
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),),
                trailing: Text('2 hours ago',
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 10.0
                  ),),
                subtitle: Text('Last message',
                  style: TextStyle(
                      color: constantColors.greenColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                  ),),
                // leading: CircleAvatar(
                //   backgroundColor: constantColors.transparent,
                //   backgroundImage: NetworkImage(
                //     documentSnapshot.data()['roomavatar']
                //   ),
                // ),
              );
            }).toList()
          );
        }
      },
    );
  }
}