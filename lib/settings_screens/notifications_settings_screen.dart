import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_settings/app_settings.dart';

import '../widgets/drawer.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool localNotificationsSwitchValue = false;
  bool globalNotificationsSwitchValue = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    ThemeData theme = Theme.of(context);
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
              title: const Text('Local Notifications'),
              value: localNotificationsSwitchValue,
              onChanged: (newValue) {
                setState(() {
                  localNotificationsSwitchValue = newValue;
                  changeNotificationsSettings(
                    context,
                    currentUserKey,
                    'localNotifications',
                    newValue ? 1 : 0,
                  );
                });
              },
              activeColor: theme.primaryColor,
            ),
            const Divider(),
            //global notifications switch
            SwitchListTile.adaptive(
              title: const Text('Global Notifications'),
              value: globalNotificationsSwitchValue,
              onChanged: (newValue) {
                setState(() {
                  globalNotificationsSwitchValue = newValue;
                  changeNotificationsSettings(
                    context,
                    currentUserKey,
                    'globalNotifications',
                    newValue ? 1 : 0,
                  );
                });
              },
              activeColor: theme.primaryColor,
            ),
            const Divider(),
            //other notifications button
            ListTile(
              title: const Text('Other Notifications Settings'),
              subtitle:
                  const Text('Open system notifications settings for this app'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                AppSettings.openAppSettings();
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Future<void> changeNotificationsSettings(
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
