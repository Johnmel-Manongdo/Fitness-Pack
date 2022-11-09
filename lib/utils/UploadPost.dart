import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fitness_pack/constants/Constantcolors.dart';
import 'package:fitness_pack/services/Authentication.dart';
import 'package:fitness_pack/services/FirebaseOperations.dart';
import 'package:fitness_pack/services/Video.dart';
import 'package:video_player/video_player.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  File uploadPostImage, uploadPostVideo;
  File get getUploadPostImage => uploadPostImage;
  File get getUploadPostVideo => uploadPostVideo;
  String uploadPostImageUrl, uploadVideoUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  String get getUploadVideoUrl => uploadVideoUrl;
  final picker = ImagePicker();
  UploadTask imagePostUploadTask, videoUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.getImage(source: source);
    uploadPostImageVal == null
        ? print('Select image')
        : uploadPostImage = File(uploadPostImageVal.path);
    print(uploadPostImageVal.path);

    uploadPostImage != null
        ? showPostImage(context)
        : print('Image upload error');

    notifyListeners();
  }

  Future pickVideo(BuildContext context) async {
    PickedFile pickedVideo = await picker.getVideo(source: ImageSource.gallery);
    uploadPostVideo = File(pickedVideo.path);
    print(uploadPostVideo.path);
    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print('Post image uploaded to storage');
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
    });
    notifyListeners();
  }

  Future uploadVideoToFirebase() async {
    Reference videoReference = FirebaseStorage.instance
        .ref()
        .child('videos/${uploadPostVideo.path}/${Timestamp.now()}');
    videoUploadTask = videoReference.putFile(uploadPostVideo);
    videoReference.getDownloadURL().then((url) {
      uploadVideoUrl = url.toString();
      print(getUploadVideoUrl);
    });
    notifyListeners();
  }

  selectPostType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton.icon(
                        color: constantColors.blueColor,
                        onPressed: () {
                          Navigator.pop(context);
                          selectPostImageType(context);
                        },
                        icon: Icon(FontAwesomeIcons.image,
                            color: constantColors.whiteColor),
                        label: Text('Photo',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0))),
                    FlatButton.icon(
                        color: constantColors.blueColor,
                        onPressed: () {
                          //   Navigator.pop(context);
                          pickVideo(context).whenComplete(() {
                            previewVideo(context);
                          });
                        },
                        icon: Icon(FontAwesomeIcons.video,
                            color: constantColors.whiteColor),
                        label: Text('Video',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0))),
                  ],
                )
              ],
            ),
          );
        });
  }

  previewVideo(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
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
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      child: Video(
                        loop: true,
                        videoPlayerController:
                            VideoPlayerController.file(getUploadPostVideo),
                      ),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          child: Text('Reselect',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: constantColors.whiteColor)),
                          onPressed: () {
                            Provider.of<UploadPost>(context, listen: false)
                                .pickVideo(context);
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text('Upload Video',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            Provider.of<UploadPost>(context, listen: false)
                                .uploadVideoToFirebase()
                                .whenComplete(() {
                              //Navigator.pop(context);
                            });
                          })
                    ],
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  showEditVideoSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text('Gallery',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0)),
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.gallery);
                        }),
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text('Camera',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0)),
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.camera);
                        })
                  ],
                )
              ],
            ),
          );
        });
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Container(
                    height: 200.0,
                    width: 400.0,
                    child: Image.file(uploadPostImage, fit: BoxFit.contain),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          child: Text('Reselect',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: constantColors.whiteColor)),
                          onPressed: () {
                            selectPostImageType(context);
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text('Confirm Image',
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            uploadPostImageToFirebase().whenComplete(() {
                              editPostSheet(context);
                              print('Image uploaded!');
                            });
                          })
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            IconButton(
                                icon: Icon(Icons.image_aspect_ratio,
                                    color: constantColors.greenColor),
                                onPressed: () {}),
                            IconButton(
                                icon: Icon(Icons.fit_screen,
                                    color: constantColors.yellowColor),
                                onPressed: () {})
                          ],
                        ),
                      ),
                      Container(
                        height: 200.0,
                        width: 300.0,
                        child: Image.file(uploadPostImage, fit: BoxFit.contain),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                      Container(
                        height: 110.0,
                        width: 5.0,
                        color: constantColors.blueColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          height: 120.0,
                          width: 310.0,
                          child: TextField(
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLengthEnforced: true,
                            maxLength: 100,
                            controller: captionController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Add A Caption...',
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  child: Text(
                    'Share',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  onPressed: () async {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .uploadPostData(captionController.text, {
                      'postimage': getUploadPostImageUrl,
                      'caption': captionController.text,
                      'username': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserName,
                      'userimage': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserImage,
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'time': Timestamp.now(),
                      'useremail': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserEmail,
                    }).whenComplete(() async {
                      // Add Data Under User Profile
                      return FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .collection('posts')
                          .add({
                        'postimage': getUploadPostImageUrl,
                        'caption': captionController.text,
                        'username': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserName,
                        'userimage': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserImage,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now(),
                        'useremail': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserEmail
                      });
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  color: constantColors.blueColor,
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
          );
        });
  }
}
