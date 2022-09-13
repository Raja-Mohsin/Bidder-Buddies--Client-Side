import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/auction.dart';

class AuctionProvider with ChangeNotifier {
  List<Auction> featuredAuctions = [];
  List<Auction> latestAuctions = [];

  List<Auction> get getFeaturedAuctionsList {
    return [...featuredAuctions];
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Uuid uuid = const Uuid();
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<void> uploadAuction(
    String name,
    String description,
    List<String> downloadUrls,
    String category,
    String city,
    String minIncrement,
    String terminationDate,
    String startingPrice,
    String maxPrice,
    String status,
  ) async {
    //create id and timestamp
    String id = uuid.v4().toString();
    String sellerId = firebaseAuth.currentUser!.uid.toString();
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";

    //upload data
    await firebaseFirestore.collection('auctions').doc(id).set(
      {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "imageUrls": downloadUrls,
        "sellerId": sellerId,
        "date": date,
        "time": time,
        "category": category,
        "minIncrement": minIncrement,
        "terminationDate": terminationDate,
        "startingPrice": startingPrice,
        "maxPrice": maxPrice,
        "status": status,
        "featured": "0",
        "bids": [],
      },
    );
  }
}
