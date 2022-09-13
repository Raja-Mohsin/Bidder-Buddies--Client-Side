import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/drawer.dart';
import '../models/notification.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    return Scaffold(
      drawer: UserDrawer('user'),
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontFamily: theme.textTheme.bodyText1!.fontFamily,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.primaryColor,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: firebaseFirestore
            .collection('notifications')
            .where('to', isEqualTo: currentUserKey)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            );
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('There are no notifications for you currently'),
            );
          }
          notifications.clear();
          snapshot.data!.docs.forEach(
            (notification) {
              notifications.add(
                NotificationModel(
                  notification['title'],
                  notification['subTitle'],
                  notification['id'],
                  notification['from'],
                  notification['to'],
                  notification['isSeen'],
                  notification['imageUrl'],
                  notification['date'],
                  notification['time'],
                ),
              );
            },
          );
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider();
            },
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(notifications[index].imageUrl),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      notifications[index].title.toString(),
                      style: TextStyle(
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    notifications[index].subTitle.toString(),
                    style: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                    ),
                  ),
                  onTap: () {},
                ),
              );
            },
            itemCount: notifications.length,
          );
        },
      ),
    );
  }
}
