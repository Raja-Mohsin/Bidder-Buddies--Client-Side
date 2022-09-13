import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../../models/category.dart';
import '../../widgets/drawer.dart';
import '../../widgets/heading.dart';
import './post_auction_screen_3.dart';

class PostAuctionScreen2 extends StatefulWidget {
  List<Category> categories;
  List<String> cities;

  PostAuctionScreen2(this.categories, this.cities);

  @override
  State<PostAuctionScreen2> createState() => _PostAuctionScreen2State();
}

class _PostAuctionScreen2State extends State<PostAuctionScreen2> {
  TextEditingController titleController = TextEditingController();
  List<String> categoryDropDownItems = [];
  List<String> cityDropDownItems = [];
  String categoryDropDownInitialValue = 'Select a Category';
  String cityDropDownInitialValue = 'Select a City';
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    //adding initial data to drop down items
    categoryDropDownItems.clear();
    cityDropDownItems.clear();
    categoryDropDownItems.add('Select a Category');
    cityDropDownItems.add('Select a City');
    for (int i = 0; i < widget.categories.length; i++) {
      categoryDropDownItems.add(widget.categories[i].name);
    }
    for (int i = 0; i < widget.cities.length; i++) {
      cityDropDownItems.add(widget.cities[i]);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Auction'),
        backgroundColor: theme.primaryColor,
        centerTitle: true,
      ),
      drawer: UserDrawer('seller'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //heading
              Heading('Enter Basic', 'Information'),
              //title input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select a suitable title for your Auction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      maxLines: 1,
                      maxLength: 30,
                      cursorColor: theme.primaryColor,
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
                        hintText: 'Enter title',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(
                thickness: 1.5,
                indent: 50,
                endIndent: 50,
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select a suitable category for your Auction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: const Text('Select a Category'),
                          value: categoryDropDownInitialValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: categoryDropDownItems
                              .map(
                                (String item) => DropdownMenuItem(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                        fontWeight: item == 'Select a Category'
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  value: item,
                                ),
                              )
                              .toList(),
                          onChanged: (var newValue) {
                            setState(() {
                              categoryDropDownInitialValue =
                                  newValue.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(
                thickness: 1.5,
                indent: 50,
                endIndent: 50,
              ),
              const SizedBox(height: 15),
              //city input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select an area of upload, select a nearby city if the exact city is not in the list.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: const Text('Select a Category'),
                          value: cityDropDownInitialValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: cityDropDownItems
                              .map(
                                (String item) => DropdownMenuItem(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                        fontWeight: item == 'Select a City'
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  value: item,
                                ),
                              )
                              .toList(),
                          onChanged: (var newValue) {
                            setState(() {
                              cityDropDownInitialValue = newValue.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              //next button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(bodyWidth * 0.75, 48),
                    primary: theme.primaryColor,
                    elevation: 10,
                  ),
                  onPressed: () {
                    String validationResult = validation();
                    if (validationResult == 'No Error') {
                      //extract data
                      String title = titleController.text.toString();
                      String city = cityDropDownInitialValue;
                      String category = categoryDropDownInitialValue;
                      //move to the next screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PostAuctionScreen3(
                            title,
                            category,
                            city,
                          ),
                        ),
                      );
                    } else {
                      return;
                    }
                  },
                  child: Text(
                    'Next',
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
      ),
    );
  }

  String validation() {
    if (titleController.text.isEmpty ||
        categoryDropDownInitialValue == 'Select a Category' ||
        cityDropDownInitialValue == 'Select a City') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kindly fill out all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return 'Error';
    }
    return 'No Error';
  }
}
