import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class OrderProvider with ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Uuid uuid = const Uuid();
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<void> uploadOrder(
    String auctionId,
    String buyerId,
    String sellerId,
    String title,
    String price,
    String imageUrl,
  ) async {
    String id = uuid.v4().toString();
    String chatId = uuid.v4().toString();
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    const String status = 'pending';
    await firebaseFirestore.collection('orders').doc(id).set(
      {
        'id': id,
        'auctionId': auctionId,
        'sellerId': sellerId,
        'buyerId': buyerId,
        'chatId': chatId,
        'title': title,
        'price': price,
        'imageUrl': imageUrl,
        'date': date,
        'time': time,
        'status': status,
      },
    );
  }
}
