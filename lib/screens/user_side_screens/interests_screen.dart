import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/category_provider.dart';
import '../../models/category.dart';
import './choose_interests_screen.dart';

class InterestsScreen extends StatefulWidget {
  InterestsScreen({Key? key}) : super(key: key);

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  List<Category> interests = [];
  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return FutureBuilder(
      future: initSharedPref(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          );
        }
        if (sharedPreferences.getInt('numberOfInterests') == null ||
            sharedPreferences.getInt('numberOfInterests') == 0) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your interests',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => ChooseInterestsScreen(),
                          ),
                        )
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontFamily: theme.textTheme.bodyText1!.fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ),
                child: const Text(
                  'You have currently no interests, tap on the edit button to add or change your interests.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        } else {
          int? numberOfInterests =
              sharedPreferences.getInt('numberOfInterests');
          interests.clear();
          for (int i = 0; i < numberOfInterests!; i++) {
            interests.add(
              Category(
                sharedPreferences.getString('interest ${i + 1}').toString(),
                'subTitle for this category',
                'https://firebasestorage.googleapis.com/v0/b/oac-fyp.appspot.com/o/categoriesIcons%2Fantique.png?alt=media&token=0b6b323f-f1f9-4563-89fa-79abc75cc1b9',
              ),
            );
          }
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your interests',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => ChooseInterestsScreen(),
                          ),
                        )
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontFamily: theme.textTheme.bodyText1!.fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(interests[index].name),
                        // subtitle: Text(interests[index].subTitle),
                        leading: Image.asset(
                          'assets/images/heart.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                    );
                  },
                  itemCount: interests.length,
                ),
              )
            ],
          );
        }
      },
    );
  }

  Future<void> initSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
