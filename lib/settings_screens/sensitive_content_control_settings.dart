import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/drawer.dart';

class SensitiveContentControlSettingsScreen extends StatefulWidget {
  int mediaValueInt;

  SensitiveContentControlSettingsScreen(this.mediaValueInt);

  @override
  State<SensitiveContentControlSettingsScreen> createState() =>
      _SensitiveContentControlSettingsScreenState();
}

class _SensitiveContentControlSettingsScreenState
    extends State<SensitiveContentControlSettingsScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  int radioValueAllow = 0;
  int radioValueLimit = 1;
  int radioValueLimitMore = 2;
  // int groupValue = 1;
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
                  'This setting can help you to control the amount of content that you may find upsetting or offensive.'),
            ),
            //radio buttons
            //Allow radio button
            RadioListTile<int>(
              title: const Text('Allow'),
              subtitle: const Text(
                  'You may see the content that may be upsetting or offensive'),
              value: radioValueAllow,
              groupValue: widget.mediaValueInt,
              activeColor: theme.primaryColor,
              onChanged: (newValue) {
                setState(() {
                  widget.mediaValueInt = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),
            //Limit radio button
            RadioListTile<int>(
              title: const Text('Limit (Default)'),
              subtitle:
                  const Text('Upsetting or offensive content will be filtered'),
              value: radioValueLimit,
              groupValue: widget.mediaValueInt,
              activeColor: theme.primaryColor,
              onChanged: (newValue) {
                setState(() {
                  widget.mediaValueInt = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),
            //Allow radio button
            RadioListTile<int>(
              title: const Text('Limit Even More'),
              subtitle: const Text(
                  'You will not see any upsetting or offensive content'),
              value: radioValueLimitMore,
              groupValue: widget.mediaValueInt,
              activeColor: theme.primaryColor,
              onChanged: (newValue) {
                setState(() {
                  widget.mediaValueInt = newValue!;
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
        'sensitiveContentControl': newValue,
      },
    );
  }
}
