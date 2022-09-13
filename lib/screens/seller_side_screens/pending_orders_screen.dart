import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/order.dart';

class PendingOrdersWidget extends StatefulWidget {
  const PendingOrdersWidget({Key? key}) : super(key: key);

  @override
  State<PendingOrdersWidget> createState() => _PendingOrdersWidgetState();
}

class _PendingOrdersWidgetState extends State<PendingOrdersWidget> {
  List<Order> pendingOrders = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    return StreamBuilder(
      stream: firebaseFirestore
          .collection('orders')
          .where('sellerId', isEqualTo: currentUserKey)
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          );
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('You have no pending orders currently'),
          );
        }
        pendingOrders.clear();
        snapshot.data!.docs.forEach(
          (order) {
            pendingOrders.add(
              Order(
                order['id'],
                order['auctionId'],
                order['buyerId'],
                order['sellerId'],
                order['chatId'],
                order['title'],
                order['price'],
                order['imageUrl'],
                order['date'],
                order['time'],
                order['status'],
                order['reviewGiven'],
                order['paymentStatus'],
                order['deliveryDateTime'],
              ),
            );
          },
        );
        return ListView.builder(
          itemCount: pendingOrders.length,
          itemBuilder: (context, index) {
            //converting date to required format
            //fetched date in default format
            String date = pendingOrders[index].date.toString();
            //create date time object from fetched date
            DateTime dateObject = DateFormat('yyyy-MM-dd').parse(date);
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
            int monthIndex = dateObject.month;
            String monthName = months[monthIndex - 1];
            return GestureDetector(
              onTap: () {
                //show bottom sheet to change order status to active
                showBottomSheet(
                  context,
                  pendingOrders[index].id,
                  pendingOrders[index].buyerId,
                );
              },
              child: Container(
                width: bodyWidth * 0.9,
                height: bodyHeight * 0.315,
                margin: const EdgeInsets.all(8),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.primaryColor,
                                  width: 0.6,
                                ),
                              ),
                              child: Image.network(
                                pendingOrders[index].imageUrl,
                                width: 70,
                                height: 70,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rs. ${pendingOrders[index].price}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    pendingOrders[index].title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Divider(),
                        Container(
                          margin: const EdgeInsets.only(left: 8, top: 6),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$monthName ${dateObject.day}, ${dateObject.year}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showBottomSheet(BuildContext ctx, String orderId, String userId) {
    ThemeData theme = Theme.of(ctx);
    MediaQueryData media = MediaQuery.of(ctx);
    double bodyWidth = media.size.width - media.padding.top;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (ctx) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                const Text(
                  'This order is currently in pending state and is waiting for your approval to start.\nWe will not show this order to buyer untill you mark it as active by clicking the below button.',
                ),
                const SizedBox(height: 25),
                //start order button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(bodyWidth * 0.5, 35),
                      primary: theme.primaryColor,
                      elevation: 10,
                    ),
                    onPressed: () async {
                      //change order status to active
                      await firebaseFirestore
                          .collection('orders')
                          .doc(orderId)
                          .update(
                        {
                          'status': 'active',
                        },
                      );
                      //send notification to user
                      await sendOrderAcceptedNotificationToUser(userId);
                      //close the bottom sheet
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'Start Order',
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
        );
      },
    );
  }

  Future<void> sendOrderAcceptedNotificationToUser(String userId) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    String id = Uuid().v4().toString();
    await firebaseFirestore.collection('notifications').doc(id).set(
      {
        'title': 'Order Accepted',
        'subTitle':
            'The order of the auction you won has been started, go to the orders section to review it',
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
