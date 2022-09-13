import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  XFile? pickedImage;
  Uuid uuid = const Uuid();
  ImagePicker imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    ListTile buildListTile(String title, String subTitle, Function onTap) {
      return ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: theme.textTheme.bodyText1!.fontFamily,
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(
            fontFamily: theme.textTheme.bodyText1!.fontFamily,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            onTap();
          },
          icon: Icon(
            Icons.edit,
            color: theme.primaryColor,
          ),
        ),
        onTap: () {},
      );
    }

    return Scaffold(
      body: StreamBuilder(
        stream: firebaseFirestore
            .collection('users')
            .doc(currentUserKey)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            );
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //header
                  Container(
                    color: theme.primaryColor,
                    width: double.infinity,
                    height: bodyHeight * 0.25,
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        bottom: 20,
                      ),
                      child: Container(
                        margin: EdgeInsets.only(right: bodyWidth * 0.15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showBottomSheet(context);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      snapshot.data!['imageUrl'],
                                    ),
                                    backgroundColor: Colors.blue,
                                    radius: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Change Avatar',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!['name'],
                                    style: TextStyle(
                                      fontFamily:
                                          theme.textTheme.bodyText1!.fontFamily,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Created: ' +
                                        snapshot.data!['date'].toString(),
                                    style: TextStyle(
                                      fontFamily:
                                          theme.textTheme.bodyText1!.fontFamily,
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //list tiles
                  //name list tile
                  buildListTile(
                    'Name',
                    snapshot.data!['name'],
                    () {
                      showEditDialogBox(context, 'Name');
                    },
                  ),
                  const Divider(),
                  //email list tile
                  buildListTile(
                    'Email',
                    snapshot.data!['email'],
                    () {
                      showEditDialogBox(context, 'Email');
                    },
                  ),
                  const Divider(),
                  //password list tile
                  buildListTile(
                    'Password',
                    '**********',
                    () {
                      showEditDialogBox(context, 'Password');
                    },
                  ),
                  const Divider(),
                  //phone list tile
                  buildListTile(
                    'Phone',
                    snapshot.data!['phone'],
                    () {
                      showEditDialogBox(context, 'Phone');
                    },
                  ),
                  const Divider(),
                  //address list tile
                  buildListTile(
                    'Address',
                    snapshot.data!['address'],
                    () {
                      showEditDialogBox(context, 'Address');
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> showEditDialogBox(BuildContext context, String key) async {
    ThemeData theme = Theme.of(context);
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter new $key',
            style: TextStyle(
              fontFamily: theme.textTheme.headline1!.fontFamily,
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'New $key'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: theme.textTheme.bodyText1!.fontFamily,
                  color: Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // fixedSize: Size(bodyWidth * 0.75, 48),
                primary: theme.primaryColor,
                elevation: 8,
              ),
              onPressed: () async {
                String enteredValue = controller.text.toString();
                if (enteredValue.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Fill out the field before saving'),
                      backgroundColor: theme.primaryColor,
                    ),
                  );
                  return;
                }
                //email change code in firebase authentication
                if (key.toLowerCase() == 'email') {
                  try {
                    await firebaseAuth.currentUser!.updateEmail(enteredValue);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'invalid-email') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.message.toString()),
                          backgroundColor: theme.primaryColor,
                        ),
                      );
                      return;
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: theme.primaryColor,
                      ),
                    );
                    return;
                  }
                }
                if (key.toLowerCase() != 'password') {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update(
                    {
                      key.toLowerCase(): controller.text.toString(),
                    },
                  );
                }
                //password change code
                if (key.toLowerCase() == 'password') {
                  try {
                    await firebaseAuth.currentUser!
                        .updatePassword(controller.text.toString());
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: theme.primaryColor,
                        ),
                      );
                      return;
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: theme.primaryColor,
                      ),
                    );
                  }
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Profile Updated Successfully'),
                    backgroundColor: theme.primaryColor,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: theme.textTheme.bodyText1!.fontFamily,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      builder: (ctx) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Divider(
                indent: 150,
                endIndent: 150,
                thickness: 3,
                color: Colors.amber,
              ),
              const SizedBox(height: 70),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //take photo from camera
                    GestureDetector(
                      onTap: () async {
                        pickedImage = await imagePicker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 60,
                        );
                        setState(() {
                          isLoading = true;
                        });
                        await changeImageUrlInDatabase('change');
                        setState(() {
                          isLoading = true;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/camera.png',
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Take a photo',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    //take photo from gallery
                    GestureDetector(
                      onTap: () async {
                        pickedImage = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 60,
                        );
                        setState(() {
                          isLoading = true;
                        });
                        await changeImageUrlInDatabase('change');
                        setState(() {
                          isLoading = true;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/gallery.png',
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Pick from gallery',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    //remove photo
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await changeImageUrlInDatabase('remove');
                        setState(() {
                          isLoading = true;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/remove.png',
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Remove photo',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        );
      },
    );
  }

  Future<void> changeImageUrlInDatabase(String mode) async {
    if (pickedImage != null) {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      String currentUserKey = firebaseAuth.currentUser!.uid.toString();
      if (mode == 'change') {
        File pickedImageFile = File(pickedImage!.path);
        String imageId = uuid.v4().toString();
        Reference reference =
            firebaseStorage.ref().child('userAvatars').child(imageId);
        final UploadTask uploadTask = reference.putFile(pickedImageFile);
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        final String imageUrl = await taskSnapshot.ref.getDownloadURL();
        await firebaseFirestore.collection('users').doc(currentUserKey).update(
          {'imageUrl': imageUrl},
        );
      } else if (mode == 'remove') {
        String defaultAvatarUrl =
            'https://firebasestorage.googleapis.com/v0/b/oac-fyp.appspot.com/o/defaultAvatar%2FdefaultAvatar.png?alt=media&token=39af8eae-fe65-4c96-9959-5dae1225c963';
        await firebaseFirestore.collection('users').doc(currentUserKey).update(
          {'imageUrl': defaultAvatarUrl},
        );
      }
    }
  }
}
