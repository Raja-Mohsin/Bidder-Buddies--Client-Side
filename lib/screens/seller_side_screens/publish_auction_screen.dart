import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './auction_publish_success_screen.dart';
import '../../providers/auction_provider.dart';
import '../../widgets/drawer.dart';
import '../../widgets/heading.dart';

class PublishAuctionScreen extends StatefulWidget {
  final String title;
  final String category;
  final String city;
  final String description;
  final String startingPrice;
  final String maxPrice;
  final String minIncrement;
  final List<XFile>? pickedImages;

  PublishAuctionScreen(this.title, this.category, this.city, this.description,
      this.startingPrice, this.maxPrice, this.minIncrement, this.pickedImages);

  @override
  State<PublishAuctionScreen> createState() => _PublishAuctionScreenState();
}

class _PublishAuctionScreenState extends State<PublishAuctionScreen> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Uuid uuid = const Uuid();
  List<String> imageUrls = [];
  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Auction'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
      ),
      drawer: UserDrawer('seller'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //heading
              Heading('Almost There...', ''),
              //publish text
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Let\'s publish your auction and get some bidders rolling in.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: theme.textTheme.bodyText1!.fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              //image
              Image.asset(
                'assets/images/hourglass.png',
                width: 250,
                height: 250,
              ),
              const SizedBox(height: 50),
              //publish button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(bodyWidth * 0.75, 48),
                    primary: theme.primaryColor,
                    elevation: 10,
                  ),
                  onPressed: () async {
                    progressDialog.show(
                      max: 100,
                      msg: 'Uploading your auction ad...',
                      progressBgColor: theme.primaryColor,
                      progressValueColor: Colors.amber,
                      msgMaxLines: 3,
                      borderRadius: 10,
                    );
                    //calculate the termination date which is 1 month after the current date
                    var currentDateObject = DateTime.now();
                    var terminationDateObject = DateTime(
                      currentDateObject.year,
                      currentDateObject.month,
                      currentDateObject.day,
                    );
                    String terminationDate = terminationDateObject.toString();
                    //upload images to firebase storage and add the download urls
                    await uploadImagesAndGetUrls(widget.pickedImages).then(
                      (value) async {
                        //call the provider function to upload auction
                        await Provider.of<AuctionProvider>(context,
                                listen: false)
                            .uploadAuction(
                          widget.title,
                          widget.description,
                          imageUrls,
                          widget.category,
                          widget.city,
                          widget.minIncrement,
                          terminationDate,
                          widget.startingPrice,
                          widget.maxPrice,
                          'pending',
                        );
                      },
                    );
                    progressDialog.close();
                    //move to the next screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const AuctionPublishSuccessScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Publish',
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

  Future<void> uploadImagesAndGetUrls(List<XFile>? pickedImages) async {
    imageUrls.clear();
    for (int i = 0; i < pickedImages!.length; i++) {
      String imageId = uuid.v4().toString();
      File imageFile = File(pickedImages[i].path);
      Reference reference =
          firebaseStorage.ref().child('auctionImages').child(imageId);
      final UploadTask uploadTask = reference.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final String url = await taskSnapshot.ref.getDownloadURL();
      imageUrls.add(url);
    }
  }
}
