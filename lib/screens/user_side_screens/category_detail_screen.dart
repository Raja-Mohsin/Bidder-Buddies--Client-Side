import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/user_side_screens/auction_detail_screen.dart';
import '../../models/auction.dart';
import '../../widgets/drawer.dart';
import '../../widgets/sort_bottom_sheet.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String category;

  CategoryDetailScreen(this.category);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  List<Auction> auctions = [];
  bool isSortApplied = false;
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
          'Browse this category',
          style: TextStyle(
            fontFamily: theme.textTheme.bodyText1!.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showSortBottomSheet(context);
            },
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            //heading
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                left: 20,
                top: 20,
                bottom: 30,
              ),
              child: Text(
                widget.category,
                style: TextStyle(
                  fontFamily: theme.textTheme.headline1!.fontFamily,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //list view
            StreamBuilder(
              stream: firebaseFirestore
                  .collection('auctions')
                  .where('status', isEqualTo: 'approved')
                  .where('category', isEqualTo: widget.category)
                  .where('sellerId', isNotEqualTo: currentUserKey)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ),
                  );
                }
                if (snapshot.data == null || snapshot.data!.size == 0) {
                  return Container(
                    margin:
                        const EdgeInsets.only(top: 100, left: 40, right: 40),
                    child: const Text(
                      'There are currently no auctions in this category.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                } else {
                  if (!isSortApplied) {
                    auctions.clear();
                    for (int index = 0; index < snapshot.data!.size; index++) {
                      //list fetched from database will be of type List<dynamic>
                      //but we want type List<String>
                      //so first convert the type and then pass to the constructor
                      List<dynamic> imageUrlsDynamicList =
                          snapshot.data!.docs[index]['imageUrls'];
                      List<dynamic> bidsDynamicList =
                          snapshot.data!.docs[index]['bids'];
                      List<String> imageUrlsList = imageUrlsDynamicList
                          .map((e) => e.toString())
                          .toList();
                      List<String> bidsList =
                          bidsDynamicList.map((e) => e.toString()).toList();
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

  void showSortBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      builder: (ctx) {
        return SortBottomSheet(applySort, removeSort);
      },
    );
  }

  void applySort(String sortType) {
    isSortApplied = true;

    //name ascending
    if (sortType == 'nameA') {
      setState(() {
        auctions.sort(
          (a, b) => a.name.compareTo(b.name),
        );
      });
      //name descending
    } else if (sortType == 'nameD') {
      setState(() {
        auctions.sort(
          (a, b) => b.name.compareTo(a.name),
        );
      });
    }
    //date ascending
    else if (sortType == 'dateA') {
      setState(() {
        auctions.sort(
          (a, b) => a.date.compareTo(b.date),
        );
      });
    }
    //date descending
    else if (sortType == 'dateD') {
      setState(() {
        auctions.sort(
          (a, b) => b.date.compareTo(a.date),
        );
      });
    }
    //price ascending
    else if (sortType == 'priceA') {
      setState(() {
        auctions.sort(
          (a, b) =>
              int.parse(a.startingPrice).compareTo(int.parse(b.startingPrice)),
        );
      });
      //price descending
    } else if (sortType == 'priceD') {
      setState(() {
        auctions.sort(
          (a, b) =>
              int.parse(b.startingPrice).compareTo(int.parse(a.startingPrice)),
        );
      });
    }
    //by minimum increment
    else if (sortType == 'minInc') {
      setState(() {
        auctions.sort(
          (a, b) => double.parse(a.minimumIncrement)
              .compareTo(double.parse(b.minimumIncrement)),
        );
      });
    }
  }

  void removeSort() {
    setState(() {
      isSortApplied = false;
    });
  }
}
