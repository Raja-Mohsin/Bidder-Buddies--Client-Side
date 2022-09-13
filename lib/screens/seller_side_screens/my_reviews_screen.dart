import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../widgets/drawer.dart';
import '../../models/review.dart';
import './my_review_detail_screen.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({Key? key}) : super(key: key);

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<Review> myReviews = [];
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
      ),
      drawer: UserDrawer('seller'),
      body: SafeArea(
        child: StreamBuilder(
          stream: firebaseFirestore
              .collection('reviews')
              .where('sellerId', isEqualTo: currentUserKey)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: theme.primaryColor),
              );
            }
            myReviews.clear();
            snapshot.data!.docs.forEach(
              (review) {
                myReviews.add(
                  Review(
                    review['id'].toString(),
                    review['orderId'].toString(),
                    review['sellerId'].toString(),
                    review['buyerId'].toString(),
                    review['qualityRating'].toString(),
                    review['recommendationRating'].toString(),
                    review['satisfactionRating'].toString(),
                    review['averageRating'].toString(),
                    review['content'].toString(),
                    review['date'].toString(),
                    review['time'].toString(),
                  ),
                );
              },
            );
            return ListView.builder(
              itemBuilder: (context, index) {
                //calculating duration
                String finalDurationText = '';
                String reviewDate = myReviews[index].date;
                String reviewTime = myReviews[index].time;
                DateTime uploadDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                    .parse(reviewDate + ' ' + reviewTime);
                DateTime now = DateTime.now();
                Duration difference = now.difference(uploadDateTime);
                finalDurationText = difference.inDays.toString() + ' days ago';
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReviewDetailScreen(
                          myReviews[index].qualityRating.toString(),
                          myReviews[index].recommendationRating.toString(),
                          myReviews[index].satisfactionRating.toString(),
                          myReviews[index].buyerId,
                          myReviews[index].content,
                          myReviews[index].orderId,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            FutureBuilder(
                              future: firebaseFirestore
                                  .collection('users')
                                  .doc(myReviews[index].buyerId)
                                  .get(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('fetching data...');
                                }
                                return Row(
                                  children: [
                                    //buyer image
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          snapshot.data!['imageUrl'].toString(),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //buyer name
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            snapshot.data!['name'].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        //rating and duration row
                                        SizedBox(
                                          width: bodyWidth * 0.75,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //rating stars
                                              RatingBarIndicator(
                                                rating: double.parse(
                                                    myReviews[index]
                                                        .averageRating),
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 20,
                                              ),
                                              //duration ago
                                              Text(
                                                finalDurationText,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Text(myReviews[index].content),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        indent: 20,
                        endIndent: 20,
                        thickness: 1,
                      ),
                    ],
                  ),
                );
              },
              itemCount: myReviews.length,
            );
          },
        ),
      ),
    );
  }
}
