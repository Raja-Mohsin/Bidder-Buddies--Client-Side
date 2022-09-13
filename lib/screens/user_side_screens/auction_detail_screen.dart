import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/drawer.dart';
import '../../widgets/auction_chat_widget.dart';
import '../../widgets/auction_detail_widget.dart';

class AuctionDetailScreen extends StatefulWidget {
  final String auctionId;
  final String mode;

  AuctionDetailScreen(this.auctionId, this.mode);

  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // bool isFav = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: UserDrawer('user'),
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
            'Live Auction',
            style: TextStyle(
              fontFamily: theme.textTheme.bodyText1!.fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: theme.primaryColor,
          elevation: 0,
          actions: [
            widget.mode == 'user'
                ? FutureBuilder(
                    future: firebaseFirestore
                        .collection('users')
                        .doc(firebaseAuth.currentUser!.uid.toString())
                        .get(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                            strokeWidth: 3,
                          ),
                        );
                      }
                      bool isFav;
                      //fetch the current list of favorites
                      List<dynamic> currentFavsDynamic =
                          snapshot.data!['favorites'];
                      //list fetched from database will be of type List<dynamic>
                      //but we want type List<String>
                      //so first convert the type and then pass to the constructor
                      List<String> currentFavsList =
                          currentFavsDynamic.map((e) => e.toString()).toList();
                      if (currentFavsList.contains(widget.auctionId)) {
                        isFav = true;
                      } else {
                        isFav = false;
                      }
                      return IconButton(
                        onPressed: () async {
                          await changeFavStatus();
                          setState(() {
                            isFav = !isFav;
                          });
                        },
                        icon: isFav
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                      );
                    },
                  )
                : Container(),
          ],
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              AuctionDetailWidget(
                widget.auctionId,
                widget.mode,
              ),
              AuctionChatWidget(widget.auctionId),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changeFavStatus() async {
    final String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    //fetch the current list of favorites
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await firebaseFirestore.collection('users').doc(currentUserKey).get();
    //list fetched from database will be of type List<dynamic>
    //but we want type List<String>
    //so first convert the type and then pass to the constructor
    List<dynamic> currentFavsDynamic = userSnapshot.data()!['favorites'];
    List<String> currentFavsList =
        currentFavsDynamic.map((e) => e.toString()).toList();
    //if this auction is already in the list then remove it otherwise add it
    if (currentFavsList.contains(widget.auctionId)) {
      currentFavsList.removeWhere((element) => element == widget.auctionId);
    } else {
      currentFavsList.add(widget.auctionId);
    }
    //update data in the database
    await firebaseFirestore.collection('users').doc(currentUserKey).update(
      {
        'favorites': currentFavsList,
      },
    );
  }
}
