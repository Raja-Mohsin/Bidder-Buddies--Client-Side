import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SellerDetailsCard extends StatelessWidget {
  final String sellerId;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  SellerDetailsCard(this.sellerId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return StreamBuilder(
      stream: firebaseFirestore.collection('users').doc(sellerId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          );
        }
        //fetch the information
        //name
        String sellerName = snapshot1.data!['name'].toString();
        //date of joining
        String dateOfJoining = snapshot1.data!['date'].toString();
        //create date time object from fetched date in string
        DateTime dateOfJoiningObject =
            DateFormat('yyyy-MM-dd').parse(dateOfJoining);
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
        int monthIndex = dateOfJoiningObject.month;
        String monthName = months[monthIndex - 1];
        return Card(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seller Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: theme.textTheme.bodyText1!.fontFamily,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: bodyWidth * 0.8,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Image.asset('assets/images/test.png'),
                      ),
                      title: Text(sellerName),
                      subtitle: Text(
                          'Member Since: $monthName ${dateOfJoiningObject.day}, ${dateOfJoiningObject.year}'),
                      trailing: SizedBox(
                        height: 30,
                        width: 50,
                        child: Center(
                          child: FutureBuilder(
                            future: firebaseFirestore
                                .collection('reviews')
                                .where('sellerId', isEqualTo: sellerId)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text('Loading seller data'),
                                );
                              }
                              double finalAvgRating = 0;
                              bool noReviews = false;
                              if (snapshot.data == null ||
                                  snapshot.data!.docs.isEmpty) {
                                noReviews = true;
                              }
                              double averageRating = 0;
                              int numberOfReviews = 0;
                              if (!noReviews) {
                                snapshot.data!.docs.forEach(
                                  (review) {
                                    String avgRatingString =
                                        review['averageRating'];
                                    double avgRatingDouble =
                                        double.parse(avgRatingString);
                                    averageRating =
                                        averageRating + avgRatingDouble;
                                    numberOfReviews++;
                                  },
                                );
                                finalAvgRating =
                                    averageRating / numberOfReviews;
                              }
                              return SizedBox(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "(",
                                        style: TextStyle(
                                          color: Colors.yellow,
                                        ),
                                      ),
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 18,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${finalAvgRating.toStringAsFixed(1)})",
                                        style: const TextStyle(
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          elevation: 3,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
