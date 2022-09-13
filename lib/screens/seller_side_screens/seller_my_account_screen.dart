import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/notifications_screen.dart';
import '../../screens/contact_support_screen.dart';
import '../../settings_screens/settings_screen.dart';
import '../../screens/my_profile_screen.dart';

class SellerMyAccountScreen extends StatelessWidget {
  SellerMyAccountScreen({Key? key}) : super(key: key);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    ThemeData theme = Theme.of(context);
    TextStyle bodyTextStyle = TextStyle(
        fontFamily: theme.textTheme.bodyText1!.fontFamily, color: Colors.white);
    TextStyle bodyTextStyleBlack = TextStyle(
        fontFamily: theme.textTheme.bodyText1!.fontFamily,
        color: Colors.black54);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;

    return Column(
      children: [
        const Divider(color: Colors.white, height: 0.5),
        Container(
          width: double.infinity,
          height: bodyHeight * 0.2,
          color: theme.primaryColor,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FutureBuilder(
                  future: firebaseFirestore
                      .collection('users')
                      .doc(currentUserKey)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Text(
                          firebaseAuth.currentUser!.email
                              .toString()[0]
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!['imageUrl']),
                    );
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      firebaseAuth.currentUser!.email.toString(),
                      style: bodyTextStyle,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Current status: Active',
                      style: bodyTextStyle,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NotificationsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: Text(
            'My Profile',
            style: TextStyle(
              fontFamily: theme.textTheme.bodyText1!.fontFamily,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'View and Edit your profile',
            style: bodyTextStyleBlack,
          ),
          leading: Icon(
            Icons.person,
            color: theme.primaryColor,
          ),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyProfileScreen(),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: Text(
            'Settings',
            style: TextStyle(
              fontFamily: theme.textTheme.bodyText1!.fontFamily,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Edit your preferences and use the app in your own way!',
            style: bodyTextStyleBlack,
          ),
          leading: Icon(
            Icons.settings,
            color: theme.primaryColor,
          ),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: Text(
            'Our Support',
            style: TextStyle(
              fontFamily: theme.textTheme.bodyText1!.fontFamily,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Contact our customer support for any issue related to Bidder Buddies',
            style: bodyTextStyleBlack,
          ),
          leading: Icon(
            Icons.support,
            color: theme.primaryColor,
          ),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ContactSupportScreen(),
              ),
            );
          },
        ),
        const Divider(),
      ],
    );
  }
}
