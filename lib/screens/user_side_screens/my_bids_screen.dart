import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/user_side_screens/auction_detail_screen.dart';
import '../../models/bid.dart';
import '../../widgets/drawer.dart';
import '../../widgets/heading.dart';

class MyBidsScreen extends StatefulWidget {
  const MyBidsScreen({Key? key}) : super(key: key);

  @override
  State<MyBidsScreen> createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> {
  List<Bid> myBids = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
      drawer: UserDrawer('user'),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Your Bids',
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
            //heading
            Heading('Track your', 'interested auctions'),
            //list view
            StreamBuilder(
              stream: firebaseFirestore
                  .collection('bids')
                  .where('userId', isEqualTo: currentUserKey)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ),
                  );
                }
                //if no bids are fetched
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('You have no active bids currently'),
                  );
                }
                //add fetched bids to the list
                myBids.clear();
                snapshot.data!.docs.forEach(
                  (bid) {
                    myBids.add(
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
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/images/bid.png',
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
                                        'Date: ${myBids[index].date}',
                                        style: bodyTextStyle,
                                      ),
                                      Text(
                                        'Amount: Rs. ' +
                                            myBids[index].amount.toString(),
                                        style: bodyTextStyle,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(bodyWidth * 0.35, 36),
                                          primary: theme.primaryColor,
                                          elevation: 10,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AuctionDetailScreen(
                                                myBids[index].auctionId,
                                                'user',
                                              ),
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
                    itemCount: myBids.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
