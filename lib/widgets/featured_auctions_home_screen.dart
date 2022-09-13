import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/user_side_screens/auction_detail_screen.dart';

class FeaturedAuctionsHomeScreen extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FeaturedAuctionsHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();

    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    TextStyle bodyTextStyle = TextStyle(
      fontFamily: textTheme.bodyText1!.fontFamily,
    );
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('auctions')
          .where('featured', isEqualTo: "1")
          .where('status', isEqualTo: 'approved')
          .where('sellerId', isNotEqualTo: currentUserKey)
          .limit(4)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //if loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              child: CircularProgressIndicator(color: theme.primaryColor),
              margin: const EdgeInsets.symmetric(vertical: 12),
            ),
          );
        }
        //if loading done
        // if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              'There are no featured auctions currently.',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          return GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: List.generate(
              snapshot.data!.docs.length,
              (index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AuctionDetailScreen(
                        snapshot.data!.docs[index]['id'],
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
      },
    );
  }
}
