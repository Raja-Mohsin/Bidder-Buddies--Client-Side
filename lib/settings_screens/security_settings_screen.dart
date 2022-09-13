import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/my_profile_screen.dart';
import '../widgets/drawer.dart';

class SecuritySettingsScreen extends StatelessWidget {
  SecuritySettingsScreen({Key? key}) : super(key: key);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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
        child: Column(
          children: [
            const SizedBox(height: 10),
            //change password tile
            ListTile(
              title: const Text('Change password'),
              subtitle: const Text(
                  'Change your account password to make it more secure'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyProfileScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            //check email verification tile
            ListTile(
              title: const Text('Check Email verification'),
              subtitle: const Text(
                  'Check that your account email is verified or not'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                String text = '';
                if (firebaseAuth.currentUser!.emailVerified) {
                  text = 'Your email address is verified';
                } else {
                  text = 'Your email address is not verified';
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(text),
                    backgroundColor: theme.primaryColor,
                  ),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
