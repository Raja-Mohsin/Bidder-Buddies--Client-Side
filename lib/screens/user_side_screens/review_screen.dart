import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../widgets/heading.dart';
import '../../widgets/drawer.dart';

class ReviewScreen extends StatefulWidget {
  final String orderId;
  final String sellerId;
  final String buyerId;
  const ReviewScreen(this.orderId, this.sellerId, this.buyerId, {Key? key})
      : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController msgController = TextEditingController();
  double qualityRating = 0;
  double recommendationRating = 0;
  double satisfactionRating = 0;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return Scaffold(
      drawer: UserDrawer('user'),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Rating & Feedback',
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
          child: Column(
            children: [
              Heading('Share your', 'feedback'),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                    'How was your experience with this order and seller?'),
              ),
              const SizedBox(height: 25),
              //first rating bar
              Column(
                children: [
                  //label
                  const Text('Product Quality'),
                  const SizedBox(height: 3),
                  //rating bar
                  RatingBar.builder(
                    glowRadius: 1,
                    glowColor: Colors.amber.withAlpha(70),
                    initialRating: 1,
                    minRating: 1,
                    allowHalfRating: true,
                    unratedColor: Colors.amber.withAlpha(50),
                    itemCount: 5,
                    itemSize: 40,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    updateOnDrag: true,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (selectedRating) {
                      qualityRating = selectedRating;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //second rating bar
              Column(
                children: [
                  //label
                  const Text('Would Recommend'),
                  const SizedBox(height: 3),
                  //rating bar
                  RatingBar.builder(
                    glowRadius: 1,
                    glowColor: Colors.amber.withAlpha(70),
                    initialRating: 1,
                    minRating: 1,
                    allowHalfRating: true,
                    unratedColor: Colors.amber.withAlpha(50),
                    itemCount: 5,
                    itemSize: 40,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    updateOnDrag: true,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (selectedRating) {
                      recommendationRating = selectedRating;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //third rating bar
              Column(
                children: [
                  //label
                  const Text('Satisfaction Level'),
                  const SizedBox(height: 3),
                  //rating bar
                  RatingBar.builder(
                    glowRadius: 1,
                    glowColor: Colors.amber.withAlpha(70),
                    initialRating: 1,
                    minRating: 1,
                    allowHalfRating: true,
                    unratedColor: Colors.amber.withAlpha(50),
                    itemCount: 5,
                    itemSize: 40,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    updateOnDrag: true,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return const Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Colors.red,
                          );
                        case 1:
                          return const Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.redAccent,
                          );
                        case 2:
                          return const Icon(
                            Icons.sentiment_neutral,
                            color: Colors.amber,
                          );
                        case 3:
                          return const Icon(
                            Icons.sentiment_satisfied,
                            color: Colors.lightGreen,
                          );
                        case 4:
                          return const Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          );
                        default:
                          return Container();
                      }
                    },
                    onRatingUpdate: (selectedRating) {
                      satisfactionRating = selectedRating;
                    },
                  ),
                ],
              ),
              //feedback text field
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 45,
                  vertical: 30,
                ),
                child: TextField(
                  controller: msgController,
                  cursorColor: theme.primaryColor,
                  minLines: 4,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Your feedback..',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              //submit button
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(bodyWidth * 0.75, 48),
                          primary: theme.primaryColor,
                          elevation: 10,
                        ),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          //submit review
                          submitReview(context);
                          //mark order as complete by changing the status
                          completeOrder(context);
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: const Icon(
                          Icons.done,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitReview(BuildContext context) async {
    String id = const Uuid().v4().toString();
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    double averageRating =
        (qualityRating + recommendationRating + satisfactionRating) / 3;
    //submit the review
    await firebaseFirestore.collection('reviews').doc(id).set(
      {
        'id': id,
        'orderId': widget.orderId,
        'sellerId': widget.sellerId,
        'buyerId': widget.buyerId,
        'qualityRating': qualityRating,
        'recommendationRating': recommendationRating,
        'satisfactionRating': satisfactionRating,
        'averageRating': averageRating.toStringAsFixed(2).toString(),
        'content': msgController.text.toString(),
        'date': date,
        'time': time,
      },
    );
    //change review status in orders table
    await firebaseFirestore.collection('orders').doc(widget.orderId).update(
      {
        'reviewGiven': '1',
      },
    );
    //send notification to seller about the review
    sendNotificationToSellerAboutReview(widget.sellerId);
    //show success msg
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Review submitted successfully'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
    //exit the screen
    Navigator.of(context).pop();
  }

  Future<void> completeOrder(BuildContext context) async {
    await firebaseFirestore.collection('orders').doc(widget.orderId).update(
      {
        'status': 'completed',
      },
    );
  }

  Future<void> sendNotificationToSellerAboutReview(String sellerId) async {
    String id = const Uuid().v4().toString();
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    await firebaseFirestore.collection('notifications').doc(id).set(
      {
        'title': 'Order completed + New review for you',
        'subTitle':
            'The buyer has shared the review on the order, and the order is completed',
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
}
