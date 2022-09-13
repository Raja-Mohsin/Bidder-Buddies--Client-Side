import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class UserProvider with ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Uuid uuid = const Uuid();
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<void> createUserInFirestore(
      String name, String email, String phone, String address) async {
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    List<String> favorites = [];
    await firebaseFirestore.collection('users').doc(currentUserKey).set(
      {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'status': 'approved',
        'id': currentUserKey,
        'date': date,
        'time': time,
        'favorites': favorites,
        //default avatar
        'imageUrl':
            'https://firebasestorage.googleapis.com/v0/b/oac-fyp.appspot.com/o/defaultAvatar%2FdefaultAvatar.png?alt=media&token=39af8eae-fe65-4c96-9959-5dae1225c963',
      },
    );
    await createSettingsDocumentInFirestore(currentUserKey, date, time);
    await sendWelcomeNotification(currentUserKey, date, time);
  }

  Future<void> createSettingsDocumentInFirestore(
      String currentUserKey, String date, String time) async {
    await firebaseFirestore.collection('settings').doc(currentUserKey).set(
      {
        'userId': currentUserKey,
        'localNotifications': '1',
        'globalNotifications': '1',
        'showOnlineStatus': '1',
        'sensitiveContentControl': '2',
        'mediaQuality': '2',
        'date': date,
        'time': time,
      },
    );
  }

  Future<void> sendWelcomeNotification(
    String currentUserKey,
    String date,
    String time,
  ) async {
    String id = uuid.v4().toString();
    await firebaseFirestore.collection('notifications').doc(id).set(
      {
        'title': 'Welcome to Bidder Buddies',
        'subTitle':
            'You have successfully created your account, welcome to the world of bidding',
        'id': id,
        'from': 'Admin',
        'to': currentUserKey,
        'isSeen': 0,
        'imageUrl': 'assets/images/app-icon.png',
        'date': date,
        'time': time,
      },
    );
  }
}
