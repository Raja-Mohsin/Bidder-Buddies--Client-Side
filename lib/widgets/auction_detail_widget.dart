import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../widgets/seller_details_auction_detail_screen.dart';
import '../widgets/product_details_widget_auction_detail_screen.dart';
import '../widgets/product_info_card_auction_detail_screen.dart';
import '../screens/user_side_screens/bid_added_success_screen.dart';
import '../models/order.dart';

class AuctionDetailWidget extends StatefulWidget {
  final String userType;
  final String auctionId;

  const AuctionDetailWidget(this.auctionId, this.userType, {Key? key})
      : super(key: key);
  @override
  State<AuctionDetailWidget> createState() => _AuctionDetailWidgetState();
}

class _AuctionDetailWidgetState extends State<AuctionDetailWidget> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<String> imageUrls = [];
  String highestAmount = '';
  String wonUserId = '';
  TextEditingController bidController = TextEditingController();
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    return SingleChildScrollView(
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
          //get the upload date and time of auction
          String date = snapshot.data!['date'];
          String time = snapshot.data!['time'];
          //convert the date and time to DateTime object
          DateTime uploadDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').parse(date + ' ' + time);
          DateTime terminationDateTime = uploadDateTime.add(
            const Duration(
              days: 15,
            ),
          );
          //remaining time is the difference between current time and termination time
          Duration timeRemaining = terminationDateTime.difference(
            DateTime.now(),
          );
          //now calculate remaining days, hours and minutes seprately
          int remainingDays = timeRemaining.inDays;
          int remainingHours = timeRemaining.inHours % 24;
          int remainingMinutes = timeRemaining.inMinutes % 60;
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
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
          //get the seller information
          String sellerId = snapshot.data!['sellerId'].toString();
          //get the current bid
          //first convert dynamic list fetched from database to string list
          List<dynamic> bidsListDynamic = snapshot.data!['bids'];
          List<String> bidsListString =
              bidsListDynamic.map((e) => e.toString()).toList();
          //build the ui
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
              //product info card
              ProductInfoCard(
                snapshot.data!['id'],
                snapshot.data!['name'],
                [...bidsListString],
                remainingDays.toString(),
                remainingHours.toString(),
                remainingMinutes.toString(),
                updateHighestBidAmount,
                snapshot.data!['maxPrice'].toString(),
                highestAmount,
                snapshot.data!['startingPrice'].toString(),
                wonUserId,
              ),
              //product details card
              widget.userType == 'user'
                  ? ProductDetailsCard(
                      snapshot.data!['category'],
                      snapshot.data!['city'].toString() + '/Pakistan',
                      'Rs. ' + snapshot.data!['maxPrice'].toString(),
                      'Rs. ' + snapshot.data!['minIncrement'].toString(),
                      snapshot.data!['description'],
                    )
                  : Container(),
              //seller details card
              widget.userType == 'user'
                  ? SellerDetailsCard(sellerId)
                  : Container(),
              const SizedBox(height: 20),
              //bid button
              widget.userType == 'user'
                  ? Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(bodyWidth * 0.75, 48),
                          primary: theme.primaryColor,
                          elevation: 10,
                        ),
                        onPressed: () {
                          showBidNowBottomSheet(
                            context,
                            sellerId,
                            '',
                            snapshot.data!['minIncrement'],
                            snapshot.data!['maxPrice'],
                            snapshot.data!['name'].toString(),
                            imageUrls,
                          );
                        },
                        child: Text(
                          'Bid Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: theme.textTheme.bodyText1!.fontFamily,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              widget.userType == 'user'
                  ? const SizedBox(height: 30)
                  : Container(),
              //end auction text and button
              widget.userType == 'seller'
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: const Text(
                            'You can end the auction before the termination date and the maximum price limit, the highest bid at that time will be the winner of the auction.',
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(bodyWidth * 0.75, 48),
                              primary: theme.primaryColor,
                              elevation: 10,
                            ),
                            onPressed: () async {
                              await endAuction(
                                context,
                                snapshot.data!['sellerId'],
                                snapshot.data!['name'],
                                highestAmount,
                                imageUrls[0],
                                bidsListString.last.toString(),
                              );
                              await sendAuctionEndedNotificationToSeller(
                                sellerId,
                                snapshot.data!['name'].toString(),
                              );
                              await sendWinNotificationToUser(
                                wonUserId,
                                snapshot.data!['name'].toString(),
                              );
                            },
                            child: Text(
                              'End Auction',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily:
                                    theme.textTheme.bodyText1!.fontFamily,
                              ),
                            ),
                          ),
                        ),
                        //some space
                        const SizedBox(height: 30),
                      ],
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  void showBidNowBottomSheet(
    BuildContext ctx,
    String sellerId,
    String currentBid,
    String minIncrement,
    String maxPrice,
    String title,
    List<String> imageUrls,
  ) {
    ThemeData theme = Theme.of(ctx);
    MediaQueryData media = MediaQuery.of(ctx);
    double bodyWidth = media.size.width - media.padding.top;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      builder: (ctx) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Divider(
                      indent: 130,
                      endIndent: 130,
                      thickness: 3,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 50),
                    //current bid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Bid: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Rs. $highestAmount'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Minimum Increment: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Rs. $minIncrement'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Maximum Price: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Rs. $maxPrice'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                        'Your bidding amount should be in between Rs.${int.parse(highestAmount) + double.parse(minIncrement)} and Rs.$maxPrice'),
                    const SizedBox(height: 30),
                    //amount input
                    Padding(
                      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
                      child: TextField(
                        controller: bidController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.primaryColor,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.primaryColor,
                              width: 2,
                            ),
                          ),
                          hintText: 'Enter amount',
                        ),
                        maxLines: 1,
                        maxLength: 20,
                        cursorColor: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 30),
                    //bid button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(bodyWidth * 0.6, 40),
                          primary: theme.primaryColor,
                          elevation: 10,
                        ),
                        onPressed: () async {
                          //check validation
                          String validationResult = validation(
                            bidController.text,
                            highestAmount,
                            maxPrice,
                            minIncrement,
                          );
                          if (validationResult == 'No Error') {
                            await uploadBid(
                              bidController.text.toString(),
                              sellerId,
                              maxPrice,
                              minIncrement,
                              title,
                              imageUrls,
                            );
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BidAddedSuccessScreen(sellerId),
                              ),
                            );
                          } else {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(validationResult),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Bid Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: theme.textTheme.bodyText1!.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> uploadBid(
    String amount,
    String sellerId,
    String maxPrice,
    String minIncrement,
    String title,
    List<String> imageUrls,
  ) async {
    //bid id, user id, seller id and auction id
    Uuid uuid = const Uuid();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String userId = firebaseAuth.currentUser!.uid.toString();
    String auctionId = widget.auctionId;
    String bidId = uuid.v4().toString();
    //current date and time
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    //upload the bid to bids collection in firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection('bids').doc(bidId).set(
      {
        'id': bidId,
        'auctionId': auctionId,
        'sellerId': sellerId,
        'userId': userId,
        'amount': amount,
        'date': date,
        'time': time,
      },
    );
    //add this bid id to the auction table
    //first fetch current dynamic list and convert it to list of string
    List<dynamic> fetchedDynamicList = [];
    List<String> fetchedListInStringFormat = [];
    await firebaseFirestore.collection('auctions').doc(auctionId).get().then(
      (snapshot) {
        fetchedDynamicList = snapshot['bids'];
        fetchedListInStringFormat =
            fetchedDynamicList.map((e) => e.toString()).toList();
        fetchedListInStringFormat.add(bidId);
      },
    );
    await firebaseFirestore.collection('auctions').doc(auctionId).update(
      {
        'bids': fetchedListInStringFormat,
      },
    );
    //end the auction if max price is reached
    //if difference between max price and current bid is less than min increment
    if (double.parse(maxPrice) - double.parse(amount) <
        double.parse(minIncrement)) {
      endAuction(
        context,
        sellerId,
        title,
        amount,
        imageUrls[0],
        bidId,
      );
    }
  }

  void updateHighestBidAmount(String bidAmount, String fetchedWonUserId) {
    highestAmount = bidAmount;
    wonUserId = fetchedWonUserId;
  }

  String validation(
      String text, String highestAmount, String maxPrice, String minIncrement) {
    if (text.isEmpty) {
      return 'Value can\'t be empty';
    }
    int amountInt = int.parse(text);
    int maxPriceInt = int.parse(maxPrice);
    int highestAmountInt = int.parse(highestAmount);
    String minIncString = double.parse(minIncrement).toStringAsFixed(0);
    int minIncrementInt = int.parse(minIncString);
    int minAmount = highestAmountInt + minIncrementInt;
    if (amountInt > maxPriceInt || amountInt < minAmount) {
      return 'Enter an amount in a given range';
    }
    return 'No Error';
  }

  //end auction function
  //ending the auction will mark the auction status as completed
  //create a order instance in orders table with a pending status
  Future<void> endAuction(
    BuildContext context,
    String sellerId,
    String title,
    String price,
    String imageUrl,
    String highestBidId,
  ) async {
    //current date and time
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    //id
    final String id = const Uuid().v4().toString();
    //calculate delivery date time which is 7 days after current time
    DateTime deliveryDateTime = DateTime.now().add(
      const Duration(days: 7),
    );
    final String deliveryTime = deliveryDateTime.toString();
    //extract buyer id from highest bid id
    await firebaseFirestore.collection('bids').doc(highestBidId).get().then(
      (DocumentSnapshot snapshot) {
        //create order variable
        Order order = Order(
          id,
          widget.auctionId,
          snapshot['userId'],
          sellerId,
          '-',
          title,
          price,
          imageUrl,
          date,
          time,
          'pending',
          '0',
          'pending',
          deliveryTime,
        );
        // //upload order variable
        firebaseFirestore.collection('orders').doc(id).set(
          {
            'id': order.id,
            'auctionId': order.auctionId,
            'buyerId': order.buyerId,
            'sellerId': order.sellerId,
            'chatId': order.chatId,
            'title': order.title,
            'price': order.price,
            'imageUrl': order.imageUrl,
            'date': order.date,
            'time': order.time,
            'status': order.status,
            'reviewGiven': order.reviewGiven,
            'paymentStatus': order.paymentStatus,
            'deliveryDateTime': order.deliveryDateTime,
          },
        );
      },
    );
    //change auction status
    await firebaseFirestore.collection('auctions').doc(widget.auctionId).update(
      {
        'status': 'completed',
      },
    );
    //show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Auction Ended, you can go to the orders page to start order for this auction'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
    // close the screen
    Navigator.of(context).pop();
  }

  Future<void> sendAuctionEndedNotificationToSeller(
    String sellerId,
    String auctionName,
  ) async {
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    String id = const Uuid().v4().toString();
    await firebaseFirestore.collection('notifications').doc(id).set(
      {
        'title': 'Auction Ended',
        'subTitle':
            'Your auction \'$auctionName\' is ended, you can go to the orders section to start the order',
        'id': id,
        'from': 'Admin',
        'to': sellerId,
        'isSeen': 0,
        'imageUrl': 'assets/images/app-icon.png',
        'date': date,
        'time': time,
      },
    );
  }

  Future<void> sendWinNotificationToUser(
      String userId, String auctionName) async {
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    String id = const Uuid().v4().toString();
    await firebaseFirestore.collection('notifications').doc(id).set(
      {
        'title': 'Auction Ended',
        'subTitle':
            'Auction \'$auctionName\' is ended and you won it, you can go to the orders section to view the order once seller has started it',
        'id': id,
        'from': 'Admin',
        'to': userId,
        'isSeen': 0,
        'imageUrl': 'assets/images/app-icon.png',
        'date': date,
        'time': time,
      },
    );
  }
}
