import 'package:flutter/material.dart';

import '../../widgets/drawer.dart';
import '../../widgets/auction_chat_widget.dart';
import '../../widgets/auction_detail_widget.dart';

class ActiveAuctionsDetailScreen extends StatefulWidget {
  const ActiveAuctionsDetailScreen({Key? key}) : super(key: key);

  @override
  State<ActiveAuctionsDetailScreen> createState() =>
      _ActiveAuctionsDetailScreenState();
}

class _ActiveAuctionsDetailScreenState
    extends State<ActiveAuctionsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: UserDrawer('seller'),
        appBar: AppBar(
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                text: 'Details',
              ),
              Tab(
                text: 'Chat',
              ),
            ],
          ),
          centerTitle: true,
          title: Text(
            'Name of Auction',
            style: TextStyle(
              fontFamily: theme.textTheme.bodyText1!.fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: theme.primaryColor,
          elevation: 0,
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       setState(() {
          //         isFav = !isFav;
          //       });
          //     },
          //     icon: isFav
          //         ? const Icon(Icons.favorite_border)
          //         : const Icon(Icons.favorite),
          //   ),
          // ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   backgroundColor: theme.primaryColor,
        //   child: const Icon(Icons.gavel),
        // ),
        body: SafeArea(
          child: TabBarView(
            children: [
              AuctionDetailWidget('seller', ''),
              AuctionChatWidget(''),
            ],
          ),
        ),
      ),
    );
  }
}
