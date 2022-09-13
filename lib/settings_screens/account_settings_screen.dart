import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/drawer.dart';
import '../screens/my_profile_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  AccountSettingsScreen({Key? key}) : super(key: key);

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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
            //account status tile
            ListTile(
              title: const Text('Account Status'),
              subtitle: const Text('Check the current status of your account'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () async {
                await showAccountStatus(currentUserKey, context);
              },
            ),
            const Divider(),
            //personal info tile
            ListTile(
              title: const Text('Personal Information'),
              subtitle:
                  const Text('Check or Edit your personal account information'),
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
          ],
        ),
      ),
    );
  }

  Future<void> showAccountStatus(
      String currentUserKey, BuildContext context) async {
    String text = '';
    await firebaseFirestore.collection('users').doc(currentUserKey).get().then(
      (snapshot) {
        if (snapshot.data()!['status'].toString() == 'approved') {
          text = 'Your account is approved';
        } else {
          text = 'Your account is not in approved state';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }
}
