import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/user_side_screens/user_home_screen.dart';
import '../screens/user_side_screens/about_us_screen.dart';
import '../screens/contact_us_screen.dart';
import '../screens/seller_side_screens/seller_home_screen.dart';
import '../settings_screens/settings_screen.dart';

class UserDrawer extends StatefulWidget {
  final String userType;

  UserDrawer(this.userType); //user or seller

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    ThemeData theme = Theme.of(context);
    TextStyle bodyTextStyle =
        TextStyle(fontFamily: theme.textTheme.bodyText1!.fontFamily);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    return Drawer(
      child: Column(
        children: [
          //header
          DrawerHeader(
            child: Column(
              children: [
                //back button
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: firebaseFirestore
                      .collection('users')
                      .doc(currentUserKey)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    //if loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          //avatar
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage('assets/images/user.png'),
                          ),
                          //user name
                          const SizedBox(height: 8),
                          Text(
                            'fetching name..',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: theme.textTheme.bodyText1!.fontFamily,
                            ),
                          ),
                        ],
                      );
                    }
                    //when loading is complete
                    return Column(
                      children: [
                        //avatar
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              NetworkImage(snapshot.data!['imageUrl']),
                        ),
                        //user name
                        const SizedBox(height: 8),
                        Text(
                          snapshot.data!['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: theme.textTheme.bodyText1!.fontFamily,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
          ),
          //items
          SwitchListTile.adaptive(
            activeColor: theme.primaryColor,
            title: Text(
              widget.userType == 'user'
                  ? 'Switch to Selling'
                  : 'Switch to Buying',
              style: bodyTextStyle,
            ),
            value: switchValue,
            onChanged: (bool newValue) {
              setState(() {
                switchValue = newValue;
              });
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) =>
                        widget.userType == 'seller'
                            ? UserHomeScreen()
                            : SellerHomeScreen()),

                (route) =>
                    false, //if you want to disable back feature set to false
              );
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Home',
              style: bodyTextStyle,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.userType == 'user'
                      ? UserHomeScreen()
                      : SellerHomeScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Settings',
              style: bodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Rate Us',
              style: bodyTextStyle,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Contact Us',
              style: bodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ContactUsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'About Us',
              style: bodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AboutUsScreen(),
                ),
              );
            },
          ),
          const Divider(),
          //logout button
          Container(
            margin: EdgeInsets.only(top: bodyHeight * 0.12),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(bodyWidth * 0.6, 45),
                  primary: theme.primaryColor,
                  elevation: 10,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  await firebaseAuth.signOut();
                },
                child: Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: theme.textTheme.bodyText1!.fontFamily,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
