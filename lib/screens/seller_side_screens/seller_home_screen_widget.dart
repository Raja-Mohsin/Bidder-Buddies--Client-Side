import 'package:flutter/material.dart';

import './active_auctions_screens.dart';
import './completed_auctions_screen.dart';
import '../my_profile_screen.dart';
import './my_orders_screen.dart';
import './my_reviews_screen.dart';

class SellerHomeScreenWidget extends StatelessWidget {
  const SellerHomeScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    Widget buildHorizontolCard(String title, IconData icon, Function onTap) {
      return GestureDetector(
        onTap: () {
          onTap();
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Colors.amber,
              width: 2,
            ),
          ),
          margin: const EdgeInsets.only(top: 20),
          color: theme.primaryColor,
          elevation: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: bodyHeight * 0.18,
            width: bodyWidth * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  icon,
                  color: Colors.white,
                  size: 40,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          //three horizontol cards
          //active auctions
          buildHorizontolCard(
            'My Active Auctions',
            Icons.gavel,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ActiveAuctionsScreen(),
                ),
              );
            },
          ),
          //completed auctions card
          buildHorizontolCard(
            'My Completed Auctions',
            Icons.done_all,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CompletedAuctionsScreens(),
                ),
              );
            },
          ),
          //orders card
          buildHorizontolCard(
            'My Orders',
            Icons.shopping_cart,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyOrdersScreenSeller(),
                ),
              );
            },
          ),
          //my profile card
          buildHorizontolCard(
            'My Profile',
            Icons.person,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyProfileScreen(),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //reviews card
                buildHorizontolCard(
                  'Reviews',
                  Icons.star,
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyReviewsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
