import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/drawer.dart';
import '../../models/auction.dart';
import './completed_auctions_detail_screen.dart';

class CompletedAuctionsScreens extends StatelessWidget {
  List<Auction> myAuctions = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CompletedAuctionsScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    TextStyle bodyTextStyle =
        TextStyle(fontFamily: theme.textTheme.bodyText1!.fontFamily);

    return Scaffold(
      drawer: UserDrawer('seller'),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Completed Auctions',
          style: TextStyle(
            fontFamily: theme.textTheme.bodyText1!.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: bodyHeight * 0.04),
            //list view
            StreamBuilder(
                stream: firebaseFirestore
                    .collection('auctions')
                    .where('sellerId', isEqualTo: currentUserKey)
                    .where('status', isEqualTo: 'completed')
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
                    return const Text(
                        'You have no completed auctions currently');
                  }
                  //add fetched auctions to the list
                  myAuctions.clear();
                  snapshot.data!.docs.forEach(
                    (auction) {
                      //first convert fetched list<dynamic> to list<string>
                      List<dynamic> imageUrlsDynamic = auction['imageUrls'];
                      List<dynamic> bidsDynamic = auction['bids'];
                      List<String> imageUrls =
                          imageUrlsDynamic.map((e) => e.toString()).toList();
                      List<String> bids =
                          bidsDynamic.map((e) => e.toString()).toList();
                      myAuctions.add(
                        Auction(
                          auction['id'],
                          auction['name'],
                          auction['description'],
                          imageUrls,
                          bids,
                          auction['sellerId'],
                          auction['date'],
                          auction['time'],
                          auction['category'],
                          auction['city'],
                          auction['minIncrement'],
                          auction['terminationDate'],
                          auction['startingPrice'],
                          auction['maxPrice'],
                          auction['status'],
                          auction['featured'],
                        ),
                      );
                    },
                  );
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 12,
                          ),
                          child: Card(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      myAuctions[index].imageUrls[0],
                                      height: bodyHeight * 0.18,
                                      width: bodyWidth * 0.25,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          myAuctions[index].name,
                                          style: bodyTextStyle,
                                        ),
                                        Text(
                                          'Rs. ' +
                                              myAuctions[index]
                                                  .startingPrice
                                                  .toString(),
                                          style: bodyTextStyle,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize:
                                                Size(bodyWidth * 0.35, 36),
                                            primary: theme.primaryColor,
                                            elevation: 10,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CompletedAuctionsDetailScreen(
                                                        myAuctions[index].id),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Details',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: theme.textTheme
                                                  .bodyText1!.fontFamily,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            color: Colors.white,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      itemCount: myAuctions.length,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
