import 'package:flutter/material.dart';
import 'package:userproject/screens/user_side_screens/auction_detail_screen.dart';

import '../models/auction.dart';

class SearchDelegateHomeScreen extends SearchDelegate<Auction> {
  List<Auction> auctions;
  List<Auction> recentAuctions = [];
  BuildContext context;

  SearchDelegateHomeScreen(this.auctions, this.context);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(
          context,
          Auction(
              '', '', '', [], [], '', '', '', '', '', '', '', '', '', '', ''),
        );
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //theme data
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    TextStyle bodyTextStyle =
        TextStyle(fontFamily: theme.textTheme.bodyText1!.fontFamily);
    //preparing final search result
    List<Auction> results = auctions
        .where(
          (auction) => auction.name.startsWith(query),
        )
        .toList();
    //list of auctions
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
                        'assets/images/test.png',
                        height: bodyHeight * 0.18,
                        width: bodyWidth * 0.25,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            results[index].name,
                            style: bodyTextStyle,
                          ),
                          Text(
                            'Rs. ' + results[index].startingPrice.toString(),
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
                                  builder: (context) => AuctionDetailScreen(
                                      auctions[index].id, 'user'),
                                ),
                              );
                            },
                            child: Text(
                              'Bid Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily:
                                    theme.textTheme.bodyText1!.fontFamily,
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
        itemCount: results.length,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    recentAuctions.clear();
    List<Auction> tempList = auctions;
    tempList.shuffle();
    for (int i = 0; i < 3; i++) {
      recentAuctions.add(
        auctions[i],
      );
    }
    final suggestionsList = query.isEmpty
        ? recentAuctions
        : auctions
            .where(
              (auction) => auction.name.trim().contains(query),
            )
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            showResults(context);
          },
          title: RichText(
            text: TextSpan(
              text: suggestionsList[index].name.substring(0, query.length),
              style: const TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: suggestionsList[index].name.substring(query.length),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: suggestionsList.length,
    );
  }
}
