import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/heading.dart';
import '../../widgets/drawer.dart';
import './publish_auction_screen.dart';

class PostAuctionScreen5 extends StatefulWidget {
  final String title;
  final String category;
  final String city;
  final String description;
  final String startingPrice;
  final String maxPrice;
  final String minIncrement;

  PostAuctionScreen5(
    this.title,
    this.category,
    this.city,
    this.description,
    this.startingPrice,
    this.maxPrice,
    this.minIncrement,
  );

  @override
  State<PostAuctionScreen5> createState() => _PostAuctionScreen5State();
}

class _PostAuctionScreen5State extends State<PostAuctionScreen5> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? pickedImages;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Auction'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
      ),
      drawer: UserDrawer('seller'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          pickedImages = await imagePicker.pickMultiImage(imageQuality: 60);
          setState(() {});
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(
          Icons.edit,
          color: Colors.amber,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //heading
              Heading('Prepare your', 'Auction Gallery'),
              //images input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    //guide text
                    Container(
                      margin: const EdgeInsets.only(right: 15, left: 5),
                      child: const Text(
                        'Pick images to showcase for your auction. Upload clear and good quality pictures of your product so that the buyers can clearly understand the condition and apperance of the product. Select atleast 3 and maximum 6 images from different angles and sides. The first image will be posted as a main image of the auction.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 40),
                    //plus icon
                    pickedImages == null || pickedImages!.isEmpty
                        ? GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              width: bodyWidth * 0.4,
                              height: bodyHeight * 0.28,
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            ),
                            onTap: () async {
                              pickedImages = await imagePicker.pickMultiImage(
                                  imageQuality: 60);
                              if (pickedImages == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('No Images Picked'),
                                    backgroundColor: theme.primaryColor,
                                  ),
                                );
                              } else {
                                setState(() {});
                              }
                            },
                          )
                        : SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Card(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          color: Colors.amber,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          File(pickedImages![index].path),
                                          width: bodyWidth * 0.4,
                                          height: bodyHeight * 0.28,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 5,
                                      child: CircleAvatar(
                                        backgroundColor: theme.primaryColor,
                                        radius: 12,
                                      ),
                                    ),
                                    Positioned(
                                      top: -12,
                                      right: -7,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            pickedImages!.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.clear,
                                          size: 20,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: pickedImages!.length,
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
                            //move to the next screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PublishAuctionScreen(
                                  widget.title,
                                  widget.category,
                                  widget.city,
                                  widget.description,
                                  widget.startingPrice,
                                  widget.maxPrice,
                                  widget.minIncrement,
                                  pickedImages,
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
            ],
          ),
        ),
      ),
    );
  }

  String validation() {
    if (pickedImages == null ||
        pickedImages!.isEmpty ||
        pickedImages!.length < 3) {
      return 'Select minimum 3 images for your auction gallery';
    } else if (pickedImages!.length > 6) {
      return 'Maximum 6 images are allowed to upload';
    }
    return 'No Error';
  }
}
