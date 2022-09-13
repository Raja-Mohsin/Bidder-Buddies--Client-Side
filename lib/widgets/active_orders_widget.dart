import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order.dart';
import '../screens/order_timeline_screen.dart';

class ActiveOrdersWidget extends StatefulWidget {
  const ActiveOrdersWidget({Key? key}) : super(key: key);

  @override
  State<ActiveOrdersWidget> createState() => _ActiveOrdersWidgetState();
}

class _ActiveOrdersWidgetState extends State<ActiveOrdersWidget> {
  List<Order> activeOrders = [];
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
          .where('buyerId', isEqualTo: currentUserKey)
          .where('status', isEqualTo: 'active')
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
            child: Text('You have no active orders currently'),
          );
        }
        activeOrders.clear();
        snapshot.data!.docs.forEach(
          (order) {
            activeOrders.add(
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
          itemCount: activeOrders.length,
          itemBuilder: (context, index) {
            //converting date to required format
            //fetched date in default format
            String date = activeOrders[index].date.toString();
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
                //move to detail screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        OrderTimelineScreen(activeOrders[index].id),
                  ),
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
                                activeOrders[index].imageUrl,
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
                                    'Rs. ${activeOrders[index].price}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    activeOrders[index].title,
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
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder(
                                stream: firebaseFirestore
                                    .collection('users')
                                    .doc(activeOrders[index].sellerId)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text('fetching seller data..');
                                  }
                                  return Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundImage: NetworkImage(
                                          snapshot.data!['imageUrl'].toString(),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        snapshot.data!['name'],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Container(
                                color: theme.primaryColor.withAlpha(50),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 2,
                                ),
                                child: Text(
                                  activeOrders[index].status.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
}
