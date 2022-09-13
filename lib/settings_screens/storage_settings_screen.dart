import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/drawer.dart';

class StorageSettingsScreen extends StatefulWidget {
  int mediaValueInt;
  StorageSettingsScreen(this.mediaValueInt);

  @override
  State<StorageSettingsScreen> createState() => _StorageSettingsScreenState();
}

class _StorageSettingsScreenState extends State<StorageSettingsScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  int radioValueLow = 0;
  int radioValueMed = 1;
  int radioValueHigh = 2;
  int groupValue = 1;
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
            //heading
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 60,
                top: 10,
                bottom: 20,
              ),
              child: const Text(
                'This setting can help you to control the media that you upload or download in/from the app. Select a quality that best suits the specs of your device and your internet.',
              ),
            ),
            //radio buttons
            //Low media quality radio button
            RadioListTile<int>(
              title: const Text('Low Quality'),
              subtitle:
                  const Text('Upload and Download all media in low quality'),
              value: radioValueLow,
              groupValue: groupValue,
              activeColor: theme.primaryColor,
              onChanged: (newValue) {
                setState(() {
                  groupValue = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),
            //Medium media quality radio button
            RadioListTile<int>(
              title: const Text('Medium Quality (Default)'),
              subtitle:
                  const Text('Upload and Download all media in medium quality'),
              value: radioValueMed,
              groupValue: groupValue,
              activeColor: theme.primaryColor,
              onChanged: (newValue) {
                setState(() {
                  groupValue = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),
            //High media quality radio button
            RadioListTile<int>(
              title: const Text('High Quality'),
              subtitle:
                  const Text('Upload and Download all media in high quality'),
              value: radioValueHigh,
              groupValue: groupValue,
              activeColor: theme.primaryColor,
              onChanged: (newValue) {
                setState(() {
                  groupValue = newValue!;
                });
              },
            ),
            //update button
            const SizedBox(height: 50),
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
                        await updateValue(
                            currentUserKey, context, widget.mediaValueInt);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text(
                        'Update',
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

  Future<void> updateValue(
    String currentUserKey,
    BuildContext context,
    int newValue,
  ) async {
    firebaseFirestore.collection('settings').doc(currentUserKey).update(
      {
        'mediaQuality': newValue,
      },
    );
  }
}
