import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/heading.dart';
import '../../widgets/drawer.dart';
import '../../models/auction.dart';
import '../../screens/user_side_screens/auction_detail_screen.dart';

class FavouriteAuctionsScreen extends StatefulWidget {
  const FavouriteAuctionsScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteAuctionsScreen> createState() =>
      _FavouriteAuctionsScreenState();
}

class _FavouriteAuctionsScreenState extends State<FavouriteAuctionsScreen> {
  List<Auction> favouriteAuctions = [];
  List<String> favAuctionsIds = [];
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
          'Your Favourites',
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
            Heading('Browse your', 'favourite auctions'),
            //list view
            StreamBuilder(
              stream: firebaseFirestore
                  .collection('users')
                  .doc(currentUserKey)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ),
                  );
                }
                //prepare the list of only ids
                favAuctionsIds.clear();
                List<dynamic> favAuctionsIdsDynamic =
                    snapshot.data!['favorites'];
                favAuctionsIds =
                    favAuctionsIdsDynamic.map((e) => e.toString()).toList();
                //if favorites list is empty
                if (favAuctionsIds.isEmpty) {
                  return const Text('You have no favorite auction for now');
                }
                //another stream builder who will fetch auctions by their ids
                return StreamBuilder(
                  stream: firebaseFirestore.collection('auctions').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: theme.primaryColor,
                        ),
                      );
                    }
                    //add auctions to the list
                    favouriteAuctions.clear();
                    snapshot.data!.docs.forEach(
                      (auction) {
                        if (favAuctionsIds.contains(auction['id'])) {
                          //convert list of dynamic to list of string
                          List<dynamic> dynamicBidsList = auction['bids'];
                          List<dynamic> dynamicImageUrlsList =
                              auction['imageUrls'];
                          List<String> bidsList =
                              dynamicBidsList.map((e) => e.toString()).toList();
                          List<String> imageUrls = dynamicImageUrlsList
                              .map((e) => e.toString())
                              .toList();
                          //add to the favorite aucitons list
                          favouriteAuctions.add(
                            Auction(
                              auction['id'],
                              auction['name'],
                              auction['description'],
                              imageUrls,
                              bidsList,
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
                        }
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      favouriteAuctions[index].imageUrls[0],
                                      height: bodyHeight * 0.18,
                                      width: bodyWidth * 0.3,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              favouriteAuctions[index].name,
                                              style: bodyTextStyle,
                                            ),
                                            Text(
                                              'Rs. ' +
                                                  favouriteAuctions[index]
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
                                                        AuctionDetailScreen(
                                                      favouriteAuctions[index]
                                                          .id,
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
                                        Image.asset(
                                          'assets/images/favorite.png',
                                          height: 50,
                                          width: 50,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              color: Colors.white,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        itemCount: favouriteAuctions.length,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
