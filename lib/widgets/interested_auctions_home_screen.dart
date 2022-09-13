import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../screens/user_side_screens/auction_detail_screen.dart';
import '../models/auction.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';

class InterestedAuctionsHomeScreen extends StatelessWidget {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late SharedPreferences sharedPreferences;
  int? numberOfInterests = 0;
  List<String> interestedCategories = [];
  List<Category> targetCategories = [];
  bool isZeroInterests = false;

  @override
  Widget build(BuildContext context) {
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    TextTheme textTheme = theme.textTheme;
    TextStyle bodyTextStyle = TextStyle(
      fontFamily: textTheme.bodyText1!.fontFamily,
    );

    return FutureBuilder(
      future: loadInterests(context),
      builder: (context, snapshot) {
        return isZeroInterests
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                      'You have no interests right now, add some interests to show them here'),
                ),
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('auctions')
                    .where('status', isEqualTo: 'approved')
                    .orderBy('date', descending: true)
                    .limit(4)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child:
                          CircularProgressIndicator(color: theme.primaryColor),
                    );
                  }
                  List<Auction> interestedAuctions = [];
                  snapshot.data!.docs.forEach(
                    (auction) {
                      if (auction['sellerId'].toString() != currentUserKey) {
                        //only add auction to the local list if its category is in interested categories list
                        for (int i = 0; i < targetCategories.length; i++) {
                          if (targetCategories[i].name == auction['category']) {
                            //list fetched from database will be of type List<dynamic>
                            //but we want type List<String>
                            //so first convert the type and then pass to the constructor
                            List<dynamic> imageUrlsDynamicList =
                                auction['imageUrls'];
                            List<String> imageUrlsList = imageUrlsDynamicList
                                .map((e) => e.toString())
                                .toList();
                            //same is the case with list of bids
                            //we will convert List<dynamic> to List<String>
                            List<dynamic> bidsDynamicList = auction['bids'];
                            List<String> bidsList = bidsDynamicList
                                .map((e) => e.toString())
                                .toList();
                            interestedAuctions.add(
                              Auction(
                                auction['id'],
                                auction['name'],
                                auction['description'],
                                imageUrlsList,
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
                        }
                      }
                    },
                  );
                  if (interestedAuctions.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: Text(
                            'You have no interests right now, add some interests to show them here'),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.active) {
                    return GridView.count(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.8,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      children: List.generate(
                        interestedAuctions.length,
                        (index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AuctionDetailScreen(
                                  interestedAuctions[index].id,
                                  'user',
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(26),
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                                topLeft: Radius.circular(6),
                              ),
                              side: BorderSide(
                                width: 0.8,
                                color: theme.primaryColor,
                              ),
                            ),
                            elevation: 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.network(
                                  snapshot.data!.docs[index]['imageUrls'][0],
                                  height: bodyHeight * 0.15,
                                  width: bodyWidth * 0.3,
                                  fit: BoxFit.cover,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]['name'],
                                      style: bodyTextStyle,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Min Price: Rs.${snapshot.data!.docs[index]['startingPrice']}',
                                      style: bodyTextStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              );
      },
    );
  }

  Future<void> loadInterests(BuildContext context) async {
    List<Category> categories =
        Provider.of<CategoryProvider>(context).getCategories;
    sharedPreferences = await SharedPreferences.getInstance();
    numberOfInterests = sharedPreferences.getInt('numberOfInterests');
    if (numberOfInterests! > 0) {
      interestedCategories.clear();
      for (int i = 1; i <= numberOfInterests!; i++) {
        interestedCategories.add(
          sharedPreferences.getString('interest $i').toString(),
        );
      }
      targetCategories.clear();
      for (int i = 0; i < categories.length; i++) {
        if (interestedCategories.contains(categories[i].name)) {
          targetCategories.add(categories[i]);
        }
      }
    } else {
      isZeroInterests = true;
    }
  }
}
