import 'package:flutter/material.dart';

import '../../widgets/heading.dart';
import '../../widgets/drawer.dart';
import './post_auction_screen_5.dart';

class PostAuctionScreen4 extends StatefulWidget {
  final String title;
  final String category;
  final String city;
  final String description;

  PostAuctionScreen4(this.title, this.category, this.city, this.description);

  @override
  State<PostAuctionScreen4> createState() => _PostAuctionScreen4State();
}

class _PostAuctionScreen4State extends State<PostAuctionScreen4> {
  TextEditingController startingPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  double minIncrementValue = 0;
  double minSliderValue = 0;
  double maxSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    return Scaffold(
      drawer: UserDrawer('seller'),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        title: const Text('Post Auction'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //heading
              Heading('Select Pricing', 'Details'),
              //starting price input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //guide text
                    const Text(
                      'Enter a starting price for your auction.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 20),
                    //text field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Rs. ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: bodyWidth * 0.8,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                minIncrementValue = value.isEmpty
                                    ? 0
                                    : double.parse(value) * 0.2;
                                minSliderValue = value.isEmpty
                                    ? 0
                                    : double.parse(value) * 0.1;
                                maxSliderValue = value.isEmpty
                                    ? 0
                                    : double.parse(value) * 0.4;
                              });
                            },
                            keyboardType: TextInputType.number,
                            controller: startingPriceController,
                            maxLines: 1,
                            cursorColor: theme.primaryColor,
                            decoration: InputDecoration(
                              hintText: 'Starting Price in rupees',
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
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: bodyHeight * 0.05),
              //minimum increment input
              Column(
                children: [
                  const Text(
                    'Select minimum increment between two bids',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: bodyWidth * 0.95,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(minSliderValue.toStringAsFixed(0)),
                        SizedBox(
                          width: bodyWidth * 0.7,
                          child: Slider(
                            label: (minIncrementValue.round()).toString(),
                            divisions: 20,
                            min: minSliderValue,
                            max: maxSliderValue,
                            value: minIncrementValue,
                            thumbColor: Colors.amber,
                            activeColor: theme.primaryColor,
                            onChanged: (newValue) {
                              setState(() {
                                minIncrementValue = newValue;
                              });
                            },
                          ),
                        ),
                        Text(maxSliderValue.toStringAsFixed(0)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: bodyHeight * 0.04),
              //max price input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //guide text
                    const Text(
                      'Enter a maximum price for your auction. Your auction will close after that price is reached.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 20),
                    //text field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Rs. ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: bodyWidth * 0.8,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: maxPriceController,
                            maxLines: 1,
                            cursorColor: theme.primaryColor,
                            decoration: InputDecoration(
                              hintText: 'Maximum Price in rupees',
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
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: bodyHeight * 0.06),
              //next button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(bodyWidth * 0.75, 48),
                    primary: theme.primaryColor,
                    elevation: 10,
                  ),
                  onPressed: () {
                    String validationResult = validation(minIncrementValue);
                    if (validationResult == 'No Error') {
                      //extract data
                      String startingPrice =
                          startingPriceController.text.toString();
                      String maxPrice = maxPriceController.text.toString();
                      String minIncrement = minIncrementValue.toString();
                      //move to next screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PostAuctionScreen5(
                            widget.title,
                            widget.category,
                            widget.city,
                            widget.description,
                            startingPrice,
                            maxPrice,
                            minIncrement,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(validationResult),
                          backgroundColor: theme.primaryColor,
                        ),
                      );
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

  String validation(double minIncValue) {
    if (startingPriceController.text.isEmpty ||
        maxPriceController.text.isEmpty ||
        minIncValue == 0.0) {
      return 'All fields are required';
    }
    int startingPrice = int.parse(startingPriceController.text.toString());
    int maxPrice = int.parse(maxPriceController.text.toString());
    if (startingPrice < 0) {
      return 'Invalid value for starting price';
    }
    if (maxPrice < 0) {
      return 'Invalid value for maximum price';
    }
    if (maxPrice <= startingPrice) {
      return 'Maximum Price should be greater than starting price';
    }
    return 'No Error';
  }
}
