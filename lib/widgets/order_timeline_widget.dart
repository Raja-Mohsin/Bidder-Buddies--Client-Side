import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../screens/user_side_screens/review_screen.dart';
import '../screens/user_side_screens/payment_failure_screen.dart';
import '../screens/user_side_screens/payment_success_screen.dart';

class OrderTimelineWidget extends StatefulWidget {
  final String orderId;
  final String userType;
  OrderTimelineWidget(this.orderId, this.userType);

  @override
  State<OrderTimelineWidget> createState() => _OrderTimelineWidgetState();
}

class _OrderTimelineWidgetState extends State<OrderTimelineWidget> {
  Razorpay razorpay = Razorpay();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int remainingDays = 0;
  int remainingHours = 0;
  int remainingMinutes = 0;

  int optionsAmount = 10000;
  String optionsName = '';
  String optionsDescription = '';
  String optionsContact = '';
  String optionsEmail = '';

  @override
  void initState() {
    //payment event handlers
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //razor pay options
    var options = {
      'key': 'rzp_test_zlCvN1VAQ3uTLI',
      'amount': optionsAmount, //in the smallest currency sub-unit.
      'name': optionsName,
      // 'order_id': 'order_DBJOWzybf0sJbb', // Generate order_id using Orders API
      'description': optionsDescription,
      'timeout': 120, // in seconds
      'prefill': {
        'contact': optionsContact,
        'email': optionsEmail,
      }
    };
    //theme and screen size
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: firebaseFirestore
            .collection('orders')
            .doc(widget.orderId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            );
          }
          // calculating remaining days hours and minutes
          String fetchedDateTime = snapshot.data!['deliveryDateTime'];
          DateTime deliveryDtObject =
              DateFormat('yyyy-MM-dd HH:mm:ss').parse(fetchedDateTime);
          DateTime now = DateTime.now();
          Duration remainingTime = deliveryDtObject.difference(now);
          remainingDays = remainingTime.inDays;
          remainingHours = remainingTime.inHours % 24;
          remainingMinutes = remainingTime.inMinutes % 60;
          //fetch the payment status
          String paymentStatus = snapshot.data!['paymentStatus'].toString();
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                height: bodyHeight * 0.15,
                child: Card(
                  child: Row(
                    children: [
                      Image.network(
                        snapshot.data!['imageUrl'],
                        height: 70,
                        width: 70,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data!['title']),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //status
                                Container(
                                  color: theme.primaryColor.withAlpha(50),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    snapshot.data!['status'].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 50),
                                //price
                                Text(
                                  'Rs.${snapshot.data!['price']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 5),
                child: Column(
                  children: [
                    if (snapshot.data!['paymentStatus'].toString() == 'paid' ||
                        snapshot.data!['paymentStatus'].toString() == 'cod')
                      widget.userType == 'user'
                          ? TimelineTile(
                              afterLineStyle:
                                  LineStyle(color: theme.primaryColor),
                              beforeLineStyle:
                                  LineStyle(color: theme.primaryColor),
                              indicatorStyle:
                                  const IndicatorStyle(color: Colors.amber),
                              endChild: buildReviewTile(
                                snapshot.data!['reviewGiven'].toString(),
                                snapshot.data!['paymentStatus'].toString(),
                                context,
                                snapshot.data!['id'].toString(),
                                snapshot.data!['sellerId'].toString(),
                                snapshot.data!['buyerId'].toString(),
                              ),
                            )
                          : TimelineTile(
                              afterLineStyle:
                                  LineStyle(color: theme.primaryColor),
                              beforeLineStyle:
                                  LineStyle(color: theme.primaryColor),
                              indicatorStyle:
                                  const IndicatorStyle(color: Colors.amber),
                              endChild: buildSellerReviewTile(
                                snapshot.data!['reviewGiven'].toString(),
                              ),
                            ),
                    const Divider(),
                    widget.userType == 'user'
                        ? paymentStatus == 'pending'
                            ? TimelineTile(
                                afterLineStyle:
                                    LineStyle(color: theme.primaryColor),
                                beforeLineStyle:
                                    LineStyle(color: theme.primaryColor),
                                indicatorStyle:
                                    const IndicatorStyle(color: Colors.amber),
                                endChild: buildPaymentTile(
                                    snapshot.data!['price'], context, options),
                              )
                            : TimelineTile(
                                afterLineStyle:
                                    LineStyle(color: theme.primaryColor),
                                beforeLineStyle:
                                    LineStyle(color: theme.primaryColor),
                                indicatorStyle:
                                    const IndicatorStyle(color: Colors.amber),
                                endChild: buildPaymentDoneTile(
                                    context, paymentStatus),
                              )
                        : TimelineTile(
                            afterLineStyle:
                                LineStyle(color: theme.primaryColor),
                            beforeLineStyle:
                                LineStyle(color: theme.primaryColor),
                            indicatorStyle:
                                const IndicatorStyle(color: Colors.amber),
                            endChild: buildSellerPaymentTile(paymentStatus),
                          ),
                    TimelineTile(
                      afterLineStyle: LineStyle(color: theme.primaryColor),
                      beforeLineStyle: LineStyle(color: theme.primaryColor),
                      indicatorStyle: const IndicatorStyle(color: Colors.amber),
                      endChild: buildExpectedDeliveryTile(deliveryDtObject),
                    ),
                    const Divider(),
                    TimelineTile(
                      afterLineStyle: LineStyle(color: theme.primaryColor),
                      beforeLineStyle: LineStyle(color: theme.primaryColor),
                      indicatorStyle: const IndicatorStyle(color: Colors.amber),
                      endChild: buildDeliveryDateTile(deliveryDtObject),
                    ),
                    const Divider(),
                    TimelineTile(
                      afterLineStyle: LineStyle(color: theme.primaryColor),
                      beforeLineStyle: LineStyle(color: theme.primaryColor),
                      indicatorStyle: const IndicatorStyle(color: Colors.amber),
                      endChild: buildOrderStartedTile(),
                    ),
                    const Divider(),
                    TimelineTile(
                      afterLineStyle: LineStyle(color: theme.primaryColor),
                      beforeLineStyle: LineStyle(color: theme.primaryColor),
                      indicatorStyle: const IndicatorStyle(color: Colors.amber),
                      endChild: buildOrderCreatedTile(
                        snapshot.data!['title'],
                        snapshot.data!['price'],
                        snapshot.data!['date'],
                        snapshot.data!['id'],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  //event handlers for payment
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(),
      ),
    );
    await firebaseFirestore.collection('orders').doc(widget.orderId).update(
      {
        'paymentStatus': 'paid',
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response.message.toString() + ' error response');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentFailureScreen(),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('external wallet');
  }

  Widget buildOrderCreatedTile(
      String title, String price, String date, String id) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Order Created',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 8,
            ),
            child: Column(
              children: [
                Text(date),
                Text(
                  'ID: $id',
                  style: const TextStyle(fontSize: 12),
                ),
                const Divider(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title),
                      Text('Rs. ' + price),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 35),
                  alignment: Alignment.centerLeft,
                  child: Text('Delivery Date: ' + date),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderStartedTile() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Order Started',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryDateTile(DateTime dtObject) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your delivery date was updated to ${dtObject.day}-${dtObject.month}-${dtObject.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExpectedDeliveryTile(DateTime dtObject) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Expected delivery ${dtObject.day}-${dtObject.month}-${dtObject.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).primaryColor.withAlpha(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      remainingDays.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Days'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      remainingHours.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Hours'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      remainingMinutes.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Minutes'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentTile(String price, BuildContext context, var options) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Payment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text('Select a payment method'),
          ),
          const SizedBox(height: 8),
          //pay now button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(bodyWidth * 0.5, 35),
                primary: theme.primaryColor,
                elevation: 10,
              ),
              onPressed: () {
                razorpay.open(options);
              },
              child: Text(
                'Pay Now',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: theme.textTheme.bodyText1!.fontFamily,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          //cash on delivery button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(bodyWidth * 0.5, 35),
                primary: theme.primaryColor,
                elevation: 10,
              ),
              onPressed: () async {
                await firebaseFirestore
                    .collection('orders')
                    .doc(widget.orderId)
                    .update(
                  {
                    'paymentStatus': 'cod',
                  },
                );
              },
              child: Text(
                'Cash on Delivery',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: theme.textTheme.bodyText1!.fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentDoneTile(BuildContext context, String paymentStatus) {
    if (paymentStatus == 'paid') {
      return Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text('You have paid for this order'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                  'You have selected cash on delivery payment method'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    }
  }

  Widget buildReviewTile(
    String reviewGiven,
    String paymentStatus,
    BuildContext context,
    String orderId,
    String sellerId,
    String buyerId,
  ) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          //heading
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Review',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //give review option if review if not given
          if (reviewGiven == '0' &&
              (paymentStatus == 'cod' || paymentStatus == 'paid'))
            Column(
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Your honest and valid review will really help us to improve your experience at the app, take a minute and share your review about this order and the seller.',
                ),
                const SizedBox(height: 10),
                //give review button which will navigate to the review screen
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(bodyWidth * 0.5, 50),
                      primary: theme.primaryColor,
                      elevation: 10,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReviewScreen(
                            orderId,
                            sellerId,
                            buyerId,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Share Review & Complete Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          //if review is already given
          if (reviewGiven == '1')
            Column(
              children: [
                const Text(
                  'You have shared your review about this order. If you have any problem regarding this review then kindly contact our support',
                ),
                const SizedBox(height: 10),
                //contact support button if there is an issue in the review
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(bodyWidth * 0.5, 35),
                      primary: theme.primaryColor,
                      elevation: 10,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Contact Support',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget buildSellerPaymentTile(String paymentStatus) {
    String paymentText = '';
    if (paymentStatus == 'pending') {
      paymentText = 'Pending';
    } else if (paymentStatus == 'cod') {
      paymentText = 'Cash on Delivery';
    } else {
      paymentText = 'Paid';
    }
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          //heading
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Payment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text('Payment Status: $paymentText'),
        ],
      ),
    );
  }

  Widget buildSellerReviewTile(String reviewStatus) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          //heading
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Review',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          reviewStatus == '0'
              ? const Text('Review not given yet')
              : const Text(
                  'Buyer has given the review, you can view it in your Reviews section from the dashboard',
                ),
        ],
      ),
    );
  }
}
