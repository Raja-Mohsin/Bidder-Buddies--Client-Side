import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bid.dart';

class ProductInfoCard extends StatelessWidget {
  final String auctionId;
  final String name;
  final List<String> bidsListString;
  final String remainingDays, remainingHours, remainingMinutes;
  String maxPrice, currentBid;
  final Function updateHighestBidAmount;
  final String startingPrice;
  String wonUserId;

  ProductInfoCard(
    this.auctionId,
    this.name,
    this.bidsListString,
    this.remainingDays,
    this.remainingHours,
    this.remainingMinutes,
    this.updateHighestBidAmount,
    this.maxPrice,
    this.currentBid,
    this.startingPrice,
    this.wonUserId,
  );

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //name heading
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(height: 15),
            //current bid
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'Current Bid',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder(
                    future: firebaseFirestore
                        .collection('bids')
                        .where('auctionId', isEqualTo: auctionId)
                        .get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                      if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return const Text('fetching data...');
                      }
                      //check if there are no bids
                      if (snapshot2.data == null ||
                          snapshot2.data!.docs.isEmpty) {
                        updateHighestBidAmount(startingPrice, '');
                        return const Text('No bids on this auction currently');
                      }
                      if (bidsListString.isEmpty) {
                        updateHighestBidAmount(startingPrice, '');
                        return const Text('No bids on this auction currently');
                      }
                      List<Bid> bidsList = [];
                      String highestBidAmount = '';
                      snapshot2.data!.docs.forEach(
                        (bid) {
                          if (bidsListString.contains(bid['id'])) {
                            bidsList.add(
                              Bid(
                                bid['id'],
                                bid['auctionId'],
                                bid['userId'],
                                bid['sellerId'],
                                bid['amount'],
                                bid['date'],
                                bid['time'],
                              ),
                            );
                          }
                        },
                      );
                      //sort the list w.r.t amount
                      bidsList.sort(
                        (a, b) => a.amount.compareTo(b.amount),
                      );
                      highestBidAmount = bidsList.last.amount.toString();
                      wonUserId = bidsList.last.userId.toString();
                      currentBid = highestBidAmount;
                      updateHighestBidAmount(highestBidAmount, wonUserId);
                      return Text('Rs. ' + highestBidAmount);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(height: 15),
            //bar and time
            FutureBuilder(
              future: firebaseFirestore.collection('bids').get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: theme.primaryColor),
                  );
                }
                //check if there are no bids
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Text('No bids on this auction currently');
                }
                if (bidsListString.isEmpty) {
                  return const Text('No bids on this auction currently');
                }
                //get the data
                List<Bid> bidsList = [];
                String highestBidAmount = '';
                snapshot.data!.docs.forEach(
                  (bid) {
                    if (bidsListString.contains(bid['id'].toString())) {
                      bidsList.add(
                        Bid(
                          bid['id'],
                          bid['auctionId'],
                          bid['userId'],
                          bid['sellerId'],
                          bid['amount'],
                          bid['date'],
                          bid['time'],
                        ),
                      );
                    }
                  },
                );
                //sort the list w.r.t amount
                bidsList.sort(
                  (a, b) => a.amount.compareTo(b.amount),
                );
                highestBidAmount = bidsList.last.amount.toString();
                currentBid = highestBidAmount;
                double percentAge =
                    (double.parse(currentBid) / double.parse(maxPrice)) * 100;
                String finalValue = percentAge.toStringAsFixed(0);
                //build the ui
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        //estimate amount
                        SizedBox(
                          width: bodyWidth * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Auction Progress',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('$finalValue%'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        //bar
                        SizedBox(
                          width: bodyWidth * 0.6,
                          child: LinearProgressIndicator(
                            value: double.parse(currentBid) /
                                double.parse(maxPrice),
                            backgroundColor: Colors.grey[400],
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 15),
            const Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(height: 15),
            //time
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.watch_later,
                  color: theme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Time Remaining',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      remainingDays.toString() +
                          'day' +
                          ', ' +
                          remainingHours.toString() +
                          'h' +
                          ', ' +
                          remainingMinutes.toString() +
                          'min',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
