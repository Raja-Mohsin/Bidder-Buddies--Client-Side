import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../widgets/drawer.dart';

class ReviewDetailScreen extends StatelessWidget {
  final String qualityRating;
  final String recommendedRating;
  final String satisfactionRating;
  final String buyerId;
  final String reviewText;
  final String orderId;

  ReviewDetailScreen(
    this.qualityRating,
    this.recommendedRating,
    this.satisfactionRating,
    this.buyerId,
    this.reviewText,
    this.orderId,
  );

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Detail'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
      ),
      drawer: UserDrawer('seller'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              //ratings heading
              buildHeading('Ratings'),
              //ratings percentage
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //quality
                    CircularPercentIndicator(
                      radius: 45,
                      percent: double.parse(qualityRating) / 5,
                      progressColor: Colors.amber,
                      footer: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text('Satisfaction'),
                      ),
                      center: Text(((double.parse(qualityRating) / 5) * 100)
                              .toStringAsFixed(0) +
                          '%'),
                    ),
                    //recommended
                    CircularPercentIndicator(
                      radius: 45,
                      percent: double.parse(recommendedRating) / 5,
                      progressColor: Colors.amber,
                      footer: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text('Satisfaction'),
                      ),
                      center: Text(((double.parse(recommendedRating) / 5) * 100)
                              .toStringAsFixed(0) +
                          '%'),
                    ),
                    //satisfaction
                    CircularPercentIndicator(
                      radius: 45,
                      percent: double.parse(satisfactionRating) / 5,
                      progressColor: Colors.amber,
                      footer: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text('Satisfaction'),
                      ),
                      center: Text(
                          ((double.parse(satisfactionRating) / 5) * 100)
                                  .toStringAsFixed(0) +
                              '%'),
                    ),
                  ],
                ),
              ),
              //review heading
              buildHeading('Review'),
              //review text
              Container(
                margin: const EdgeInsets.only(left: 10, bottom: 15, right: 10),
                child: Text(
                  reviewText,
                ),
              ),
              //order details heading
              buildHeading('Order Details'),
              //order details
              StreamBuilder(
                  stream: firebaseFirestore
                      .collection('orders')
                      .doc(orderId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: theme.primaryColor,
                        ),
                      );
                    }
                    String orderName = snapshot.data!['title'].toString();
                    String orderPrice = snapshot.data!['price'].toString();
                    String orderDate = snapshot.data!['date'].toString();
                    String imageUrl = snapshot.data!['imageUrl'].toString();
                    return Column(
                      children: [
                        //order image
                        Container(
                          margin: const EdgeInsets.only(bottom: 20, top: 10),
                          child: Image.network(
                            imageUrl,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        //detail tiles
                        buildOrderDetailTile('Order Name', orderName),
                        const SizedBox(height: 15),
                        buildOrderDetailTile('Order Price', 'Rs. $orderPrice'),
                        const SizedBox(height: 15),
                        buildOrderDetailTile(
                            'Order Date (yyyy-MM-dd)', orderDate),
                        const SizedBox(height: 30),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeading(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 15),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget buildOrderDetailTile(String heading, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.grey.withAlpha(70),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}
