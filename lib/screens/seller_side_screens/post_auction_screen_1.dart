import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/heading.dart';
import '../../widgets/unordered_list_items.dart';
import './post_auction_screen_2.dart';
import '../../models/category.dart';

class PostAuctionScreen1 extends StatefulWidget {
  const PostAuctionScreen1({Key? key}) : super(key: key);

  @override
  State<PostAuctionScreen1> createState() => _PostAuctionScreen1State();
}

class _PostAuctionScreen1State extends State<PostAuctionScreen1> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool isLoading = false;
  List<String> bulletPoints = [
    'Enter valid and accurate information of the product.',
    'Upload clear pictures with different angles.',
    'Keep the auction chat clean.',
    'Wait for the auction approval after uploading',
  ];
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    return Column(
      children: [
        //heading
        Heading('Post an', 'Auction'),
        //image
        Image.asset(
          'assets/images/upload.png',
          width: bodyWidth * 0.5,
          height: bodyHeight * 0.2,
        ),
        //steps heading
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(
            left: 20,
            top: 20,
          ),
          child: const Text(
            'Steps to follow:',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //bullet points
        UnorderedList(bulletPoints),
        //start button
        isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
              )
            : Container(
                margin: const EdgeInsets.only(top: 30),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(bodyWidth * 0.75, 48),
                      primary: theme.primaryColor,
                      elevation: 10,
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      List<Category> fetchedCategories = [];
                      List<String> fetchedCities = [];
                      await firebaseFirestore
                          .collection('categories')
                          .get()
                          .then(
                        (snapshot) async {
                          snapshot.docs.forEach(
                            (category) {
                              fetchedCategories.add(
                                Category(
                                  category['name'],
                                  category['subTitle'],
                                  category['url'],
                                ),
                              );
                            },
                          );
                          await firebaseFirestore
                              .collection('cities')
                              .get()
                              .then(
                            (snapshot) {
                              snapshot.docs.forEach(
                                (city) {
                                  fetchedCities.add(
                                    city['name'],
                                  );
                                },
                              );
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PostAuctionScreen2(
                                      fetchedCategories, fetchedCities),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Text(
                      'Start Posting',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
