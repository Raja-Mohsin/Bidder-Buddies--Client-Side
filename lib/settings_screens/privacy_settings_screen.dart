import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/drawer.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool statusSwitchValue = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
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
            //local notifications switch
            SwitchListTile.adaptive(
              title: const Text('Show Online Status'),
              value: statusSwitchValue,
              onChanged: (newValue) {
                setState(() {
                  statusSwitchValue = newValue;
                  changePrivacySettings(
                    context,
                    currentUserKey,
                    'showOnlineStatus',
                    newValue ? 1 : 0,
                  );
                });
              },
              activeColor: theme.primaryColor,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Future<void> changePrivacySettings(
    BuildContext context,
    String currentUserKey,
    String key,
    int value,
  ) async {
    //change value in database
    firebaseFirestore.collection('settings').doc(currentUserKey).update(
      {
        key: value,
      },
    );
    //show success msg
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings Updated'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
