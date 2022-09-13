import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/drawer.dart';

class DefaultSettingsScreen extends StatefulWidget {
  const DefaultSettingsScreen({Key? key}) : super(key: key);

  @override
  State<DefaultSettingsScreen> createState() => _DefaultSettingsScreenState();
}

class _DefaultSettingsScreenState extends State<DefaultSettingsScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text('Settings'),
      ),
      drawer: UserDrawer('user'),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: const Text(
                'This will change all your settings and prefrences to default settings. You can also change them later from the settings section.',
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ),
                  )
                : Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(bodyWidth * 0.75, 48),
                        primary: theme.primaryColor,
                        elevation: 10,
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await changeToDefaultSettings(currentUserKey, context);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text(
                        'Change to Default',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: theme.textTheme.bodyText1!.fontFamily,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> changeToDefaultSettings(
      String userKey, BuildContext context) async {
    //change settings in database
    await firebaseFirestore.collection('settings').doc(userKey).update(
      {
        'userId': userKey,
        'localNotifications': '1',
        'globalNotifications': '1',
        'showOnlineStatus': '1',
        'sensitiveContentControl': '2',
        'mediaQuality': '2',
      },
    );
    //show success msg
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Default settings applied.'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
