import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

import '../../widgets/drawer.dart';
import '../../widgets/product_details_widget_auction_detail_screen.dart';

class CompletedAuctionsDetailScreen extends StatefulWidget {
  final String auctionId;

  CompletedAuctionsDetailScreen(this.auctionId);

  @override
  State<CompletedAuctionsDetailScreen> createState() =>
      _CompletedAuctionsDetailScreenState();
}

class _CompletedAuctionsDetailScreenState
    extends State<CompletedAuctionsDetailScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<String> imageUrls = [];

  Future<void> showDeleteDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Auction'),
          content: const Text('Are you sure you want to delete this auction?'),
          actions: [
            TextButton(
              onPressed: () async {
                await firebaseFirestore
                    .collection('auctions')
                    .doc(widget.auctionId)
                    .delete();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    final TextStyle bigFont = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      fontFamily: theme.textTheme.bodyText1!.fontFamily,
    );
    final List<String> popUpMenuItems = ['Delete Auction'];

    return Scaffold(
      drawer: UserDrawer('seller'),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 40, 0, 0),
                items: popUpMenuItems
                    .map(
                      (e) => PopupMenuItem(
                        onTap: () async {
                          Future.delayed(
                            const Duration(),
                            () => showDeleteDialog(context),
                          );
                        },
                        child: Text(e),
                        value: 1,
                      ),
                    )
                    .toList(),
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
        centerTitle: true,
        title: Text(
          'Auction Details',
          style: TextStyle(
            fontFamily: theme.textTheme.bodyText1!.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: firebaseFirestore
                .collection('auctions')
                .doc(widget.auctionId)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.primaryColor,
                  ),
                );
              }
              //get number of bids
              List<dynamic> bids = snapshot.data!['bids'];
              String numberOfBids = bids.length.toString();
              //get date and termination date and convert to datetime objects
              String date = snapshot.data!['date'].toString();
              DateFormat dateFormat = DateFormat('yyyy-MM-dd');
              DateTime terminationDateObject = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse(snapshot.data!['terminationDate'].toString());
              DateTime dateObject = dateFormat.parse(date);
              //calculate month name from int
              const List months = [
                'January',
                'Febuary',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December',
              ];
              int dateMonthIndex = dateObject.month;
              int terminationDateMonthIndex = terminationDateObject.month;
              String dateMonthName = months[dateMonthIndex - 1];
              String terminationDateMonthName =
                  months[terminationDateMonthIndex - 1];
              //get the images urls for the slider
              List<dynamic> imageUrlsDynamic = snapshot.data!['imageUrls'];
              imageUrls = imageUrlsDynamic
                  .map(
                    (item) => item.toString(),
                  )
                  .toList();
              //preparing the slider with images
              final List<Widget> imageSliders = imageUrls
                  .map(
                    (item) => Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 20),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          width: bodyWidth * 0.8,
                        ),
                      ),
                    ),
                  )
                  .toList();
              return Column(
                children: [
                  //images slider widget
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      height: bodyHeight * 0.45,
                      enlargeCenterPage: true,
                    ),
                    items: imageSliders,
                  ),
                  //name and price row
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            snapshot.data!['name'],
                            style: bigFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //starting price
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: bodyWidth * 0.15,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Starting Price: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data!['startingPrice'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //number of bids
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: bodyWidth * 0.15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Number of Bids: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          numberOfBids,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //start date
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: bodyWidth * 0.15,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Starting Date: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$dateMonthName ${dateObject.day}, ${dateObject.year}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //ending date
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: bodyWidth * 0.15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ending Date: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$terminationDateMonthName ${terminationDateObject.day}, ${terminationDateObject.year}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  //product details card
                  ProductDetailsCard(
                    snapshot.data!['category'],
                    snapshot.data!['city'].toString() + '/Pakistan',
                    'Rs. ' + snapshot.data!['maxPrice'].toString(),
                    'Rs. ' + snapshot.data!['minIncrement'].toString(),
                    snapshot.data!['description'],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
