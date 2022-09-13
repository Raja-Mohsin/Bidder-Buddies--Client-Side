import 'package:flutter/material.dart';

import '../../widgets/drawer.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      drawer: UserDrawer('user'),
      appBar: AppBar(
        title: const Text('About Bidder Buddies'),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
              top: 20,
              right: 20,
              left: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NO NEED TO RUN BECAUSE',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: theme.textTheme.headline1!.fontFamily,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'BIDDING IS FUN',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: theme.textTheme.headline1!.fontFamily,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque consequat, sapien non interdum suscipit, urna erat rutrum nisl, auctor pellentesque eros enim in ex. In congue elit eget fermentum semper. Duis pretium massa dui, non vulputate purus pellentesque nec. Donec sed tempor erat.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque consequat, sapien non interdum suscipit, urna erat rutrum nisl, auctor pellentesque eros enim in ex.',
                  style: TextStyle(
                    fontFamily: theme.textTheme.bodyText1!.fontFamily,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 18),
                Text(
                  'OUR AUCTIONS ARE FAIR AND PROFITABLE.',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: theme.textTheme.headline1!.fontFamily,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque consequat, sapien non interdum suscipit, urna erat rutrum nisl, auctor pellentesque eros enim in ex. In congue elit eget fermentum semper. Duis pretium massa dui, non vulputate purus pellentesque nec. Donec sed tempor erat.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque consequat, sapien non interdum suscipit, urna erat rutrum nisl, auctor pellentesque eros enim in ex.',
                  style: TextStyle(
                    fontFamily: theme.textTheme.bodyText1!.fontFamily,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
