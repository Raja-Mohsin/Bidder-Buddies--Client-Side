import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class BidAddedSuccessScreen extends StatefulWidget {
  final String sellerId;
  BidAddedSuccessScreen(this.sellerId);
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  State<BidAddedSuccessScreen> createState() => _BidAddedSuccessScreenState();
}

class _BidAddedSuccessScreenState extends State<BidAddedSuccessScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    var scaffold2 = Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 10,
            width: bodyWidth,
            child: Row(
              children: [
                Text(
                  'username',
                ),
                Text('last bid'),
                Text('time')
              ],
            ),
          ),
        ],
      ),
    );
    //login button
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
                await sendNotificationToUser();
                await sendNotificationToSeller();
                setState(() {
                  isLoading = false;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Great!',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: theme.textTheme.bodyText1!.fontFamily,
                ),
              ),
            ),
          );
    var scaffold = scaffold2;
    return scaffold;
  }

  Future<void> sendNotificationToUser() async {
    String id = const Uuid().v4().toString();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    String currentUserKey = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('notifications').doc(id).set(
      {
        'title': 'Bid Submission Successfull',
        'subTitle':
            'You have successfully submitted your bid, we will notifiy you if you win this auction',
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

  Future<void> sendNotificationToSeller() async {
    String id = const Uuid().v4().toString();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    String currentUserKey = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('notifications').doc(id).set(
      {
        'title': 'Bid Received on your Auction',
        'subTitle': 'You have a new bid on your auction',
        'id': id,
        'from': currentUserKey,
        'to': widget.sellerId,
        'isSeen': 0,
        'imageUrl': 'assets/images/app-icon.png',
        'date': date,
        'time': time,
      },
    );
  }
}
