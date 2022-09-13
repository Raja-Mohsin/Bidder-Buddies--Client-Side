import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../screens/user_side_screens/auction_detail_screen.dart';
import '../../models/auction.dart';
import '../../widgets/drawer.dart';

class FiltersResultsScreen extends StatelessWidget {
  final List<String> selectedCategories;
  final List<String> selectedCities;
  final double minimumPrice;
  final double maximumPrice;
  final bool isFeaturedChecked;

  FiltersResultsScreen(
    this.selectedCategories,
    this.selectedCities,
    this.maximumPrice,
    this.minimumPrice,
    this.isFeaturedChecked,
  );

  List<Auction> auctions = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    TextStyle bodyTextStyle =
        TextStyle(fontFamily: theme.textTheme.bodyText1!.fontFamily);
    String isFeaturedCheckedInt = isFeaturedChecked ? "1" : "0";
    selectedCategories.forEach((element) {
      print(element);
    });
    return Scaffold(
      drawer: UserDrawer('user'),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Browse Auctions',
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
            //list view
            StreamBuilder(
              stream: firebaseFirestore.collection('auctions').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ),
                  );
                }
                if (snapshot.data!.size == 0) {
                  return Container(
                    margin:
                        const EdgeInsets.only(top: 100, left: 40, right: 40),
                    child: const Text(
                      'There are currently no auctions from these filters.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                } else {
                  auctions.clear();
                  for (int index = 0; index < snapshot.data!.size; index++) {
                    //list fetched from database will be of type List<dynamic>
                    //but we want type List<String>
                    //so first convert the type and then pass to the constructor
                    List<dynamic> imageUrlsDynamicList =
                        snapshot.data!.docs[index]['imageUrls'];
                    List<dynamic> bidsDynamicList =
                        snapshot.data!.docs[index]['bids'];
                    List<String> imageUrlsList =
                        imageUrlsDynamicList.map((e) => e.toString()).toList();
                    List<String> bidsList =
                        bidsDynamicList.map((e) => e.toString()).toList();
                    //applying out filters conditions before
                    //adding auctions in to the final list
                    if (snapshot.data!.docs[index]['featured'] ==
                            isFeaturedCheckedInt &&
                        selectedCategories
                            .contains(snapshot.data!.docs[index]['category']) &&
                        selectedCities
                            .contains(snapshot.data!.docs[index]['city']) &&
                        double.parse(
                                snapshot.data!.docs[index]['startingPrice']) >=
                            minimumPrice &&
                        double.parse(
                                snapshot.data!.docs[index]['startingPrice']) <=
                            maximumPrice) {
                      auctions.add(
                        Auction(
                          snapshot.data!.docs[index]['id'],
                          snapshot.data!.docs[index]['name'],
                          snapshot.data!.docs[index]['description'],
                          imageUrlsList,
                          bidsList,
                          snapshot.data!.docs[index]['sellerId'],
                          snapshot.data!.docs[index]['date'],
                          snapshot.data!.docs[index]['time'],
                          snapshot.data!.docs[index]['category'],
                          snapshot.data!.docs[index]['city'],
                          snapshot.data!.docs[index]['minIncrement'],
                          snapshot.data!.docs[index]['terminationDate'],
                          snapshot.data!.docs[index]['startingPrice'],
                          snapshot.data!.docs[index]['maxPrice'],
                          snapshot.data!.docs[index]['status'],
                          snapshot.data!.docs[index]['featured'],
                        ),
                      );
                    }
                  }
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
                                      auctions[index].imageUrls[0],
                                      height: bodyHeight * 0.18,
                                      width: bodyWidth * 0.25,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          auctions[index].name,
                                          style: bodyTextStyle,
                                        ),
                                        Text(
                                          'Rs. ' +
                                              auctions[index]
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
                                                  auctions[index].id,
                                                  'user',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Bid Now',
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
                      itemCount: auctions.length,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
