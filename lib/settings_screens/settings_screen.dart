import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../widgets/drawer.dart';
import '../screens/contact_support_screen.dart';

import './notifications_settings_screen.dart';
import './privacy_settings_screen.dart';
import './security_settings_screen.dart';
import './account_settings_screen.dart';
import './sensitive_content_control_settings.dart';
import './chat_history_settings.dart';
import './delete_account_screen.dart';
import './storage_settings_screen.dart';
import './default_settings_screen.dart';
import './terms_and_policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  static const List<String> tiles = [
    'Notifications',
    'Privacy',
    'Security',
    'Account',
    'Sensitive Content Control',
    'Chat History',
    'Delete Account',
    'Storage and Data',
    'Default Settings',
    'Terms and Privacy Policy',
    'Help',
    'App info',
    'Logout',
  ];

  static const List<IconData> icons = [
    Icons.notifications,
    Icons.privacy_tip,
    Icons.security,
    Icons.person,
    Icons.chat_bubble,
    Icons.chat,
    Icons.delete,
    Icons.storage,
    Icons.restore,
    Icons.policy,
    Icons.help,
    Icons.info,
    Icons.logout,
  ];

  final List<Widget> screens = [
    NotificationsSettingsScreen(),
    PrivacySettingsScreen(),
    SecuritySettingsScreen(),
    AccountSettingsScreen(),
    Container(),
    ChatHistorySettings(),
    DeleteAccountScreen(),
    StorageSettingsScreen(2),
    DefaultSettingsScreen(),
    TermsAndPolicyScreen(),
    ContactSupportScreen(),
    // AppInfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    icons[index],
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    tiles[index],
                  ),
                  onTap: () {
                    onTapFunction(tiles[index], context);
                  },
                ),
                const Divider(),
              ],
            );
          },
          itemCount: tiles.length,
        ),
      ),
    );
  }

  void onTapFunction(String selectedTile, BuildContext context) {
    switch (selectedTile) {
      case 'Notifications':
        navigateToNextScreen(0, context);
        break;
      case 'Privacy':
        navigateToNextScreen(1, context);
        break;
      case 'Security':
        navigateToNextScreen(2, context);
        break;
      case 'Account':
        navigateToNextScreen(3, context);
        break;
      case 'Sensitive Content Control':
        navigateToMediaControlScreen(context);
        break;
      case 'Chat History':
        navigateToNextScreen(5, context);
        break;
      case 'Delete Account':
        navigateToNextScreen(6, context);
        break;
      case 'Storage and Data':
        navigateToNextScreen(7, context);
        break;
      case 'Default Settings':
        navigateToNextScreen(8, context);
        break;
      case 'Terms and Privacy Policy':
        navigateToNextScreen(9, context);
        break;
      case 'Help':
        navigateToNextScreen(10, context);
        break;
      case 'App info':
        // navigateToNextScreen(11, context);
        showAboutDialog(
          context: context,
          applicationIcon: Image.asset('assets/images/app-icon.png'),
          applicationName: 'Bidder Buddies',
          applicationVersion: '1.0.2',
          applicationLegalese: 'Application Legalese',
        );
        break;
      case 'Logout':
        logout(context);
        break;
    }
  }

  void navigateToNextScreen(int index, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screens[index],
      ),
    );
  }

  void logout(BuildContext context) async {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/');
    await FirebaseAuth.instance.signOut();
  }

  Future<void> navigateToMediaControlScreen(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('settings')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (snapshot) {
        String mediaValue = snapshot.data()!['sensitiveContentControl'];
        int mediaValueInt = int.parse(mediaValue);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                SensitiveContentControlSettingsScreen(mediaValueInt),
          ),
        );
      },
    );
  }
}
