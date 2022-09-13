import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import './active_auctions_screens.dart';
import '../../widgets/heading.dart';
import '../../widgets/drawer.dart';
import './seller_home_screen.dart';

class AuctionPublishSuccessScreen extends StatelessWidget {
  const AuctionPublishSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Heading('It\'s Alive', ''),
              //success text
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Your auction is under review\nIt will be live when the admin approves it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: theme.textTheme.bodyText1!.fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              //image
              Lottie.network(
                'https://assets3.lottiefiles.com/private_files/lf30_nsqfzxxx.json',
                width: 250,
                height: 250,
                repeat: false,
              ),
              const SizedBox(height: 40),
              //view my auctions button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(bodyWidth * 0.75, 48),
                    primary: theme.primaryColor,
                    elevation: 10,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ActiveAuctionsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'View My Auctions',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                    ),
                  ),
                ),
              ),
              //back to home screen button
              Container(
                margin: const EdgeInsets.only(top: 18),
                child: Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(bodyWidth * 0.75, 48),
                      side: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                    onPressed: () {
                      //remove all prevoius routes
                      Navigator.of(context).popUntil((route) => false);
                      //push new route
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SellerHomeScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Back to Home Screen',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.primaryColor,
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      ),
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
}
