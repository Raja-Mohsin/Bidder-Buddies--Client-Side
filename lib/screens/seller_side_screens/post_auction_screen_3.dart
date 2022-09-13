import 'package:flutter/material.dart';

import '../../widgets/heading.dart';
import '../../widgets/drawer.dart';
import './post_auction_screen_4.dart';

class PostAuctionScreen3 extends StatefulWidget {
  final String title;
  final String category;
  final String city;

  PostAuctionScreen3(this.title, this.category, this.city);

  @override
  State<PostAuctionScreen3> createState() => _PostAuctionScreen3State();
}

class _PostAuctionScreen3State extends State<PostAuctionScreen3> {
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    return Scaffold(
      drawer: UserDrawer('seller'),
      appBar: AppBar(
        title: const Text('Post Auction'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //heading
              Heading('Write a', 'Description'),
              //hint
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    //guide text
                    const Text(
                      'Write a description which best describes your product in detail.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 40),
                    //description input field
                    TextField(
                      controller: descriptionController,
                      minLines: 10,
                      maxLines: 15,
                      maxLength: 500,
                      cursorColor: theme.primaryColor,
                      decoration: InputDecoration(
                        hintText:
                            'For Example:\nSuzuki Cultus VXR 2007 model\nMillage Approx 14 to in city 17 on long route\nModel 2007\nNew tyre 2 weeks before install\nNew bettery 1 week old\nPower staring\nPaint body\nAc kit complete install only gas need to refill',
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
                          //check validation
                          String validationResult = validation();
                          if (validationResult == 'No Error') {
                            //extract the data
                            String description =
                                descriptionController.text.toString();
                            //move to the next screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PostAuctionScreen4(
                                  widget.title,
                                  widget.category,
                                  widget.city,
                                  description,
                                ),
                              ),
                            );
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
            ],
          ),
        ),
      ),
    );
  }

  String validation() {
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Description can\'t be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return 'error';
    } else if (descriptionController.text.length < 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Description too short'),
          backgroundColor: Colors.red,
        ),
      );
      return 'error';
    }
    return 'No Error';
  }
}
