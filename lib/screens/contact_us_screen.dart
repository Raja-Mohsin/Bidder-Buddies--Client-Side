import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/drawer.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        title: const Text('Contact Bidder Buddies'),
        elevation: 0,
      ),
      drawer: UserDrawer('user'),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.asset(
                'assets/images/contact_us.png',
                height: bodyHeight * 0.3,
                width: bodyWidth * 0.5,
              ),
              Text(
                'Drop us a line...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: theme.textTheme.bodyText1!.fontFamily,
                ),
              ),
              const SizedBox(height: 25),
              //location info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 30,
                      color: theme.primaryColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'House Number E-2/1\nPTCL Colony Saddar\nRawalpindi',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: theme.textTheme.bodyText1!.fontFamily,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await openMap(context);
                          },
                          child: Text(
                            'Open in Map',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 16,
                              fontFamily: theme.textTheme.bodyText1!.fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              //phone info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 30,
                      color: theme.primaryColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0335-5850501',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: theme.textTheme.bodyText1!.fontFamily,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await openDialer(context);
                          },
                          child: Text(
                            'Call Now',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 16,
                              fontFamily: theme.textTheme.bodyText1!.fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              //timing info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 30,
                      color: theme.primaryColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Monday - Friday\n9am - 12pm',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: theme.textTheme.bodyText1!.fontFamily,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await openMap(context);
                          },
                          child: Text(
                            'Reach Us',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 16,
                              fontFamily: theme.textTheme.bodyText1!.fontFamily,
                            ),
                          ),
                        ),
                      ],
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

  Future<void> openMap(BuildContext context) async {
    const String latitude = "33.660564";
    const String longitude = "73.020135";
    const String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    final Uri encodedURl = Uri.parse(googleMapslocationUrl);
    if (await canLaunchUrl(encodedURl)) {
      await launchUrl(encodedURl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Can\'t open map'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
  }

  Future<void> openDialer(BuildContext context) async {
    Uri url = Uri.parse("tel:+923355850501");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Can\'t open dialer'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
  }
}
