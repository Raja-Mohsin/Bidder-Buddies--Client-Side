import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../widgets/drawer.dart';
import '../../screens/seller_side_screens/seller_home_screen_widget.dart';
import '../../screens/seller_side_screens/post_auction_screen_1.dart';
import '../../screens/seller_side_screens/seller_my_account_screen.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({Key? key}) : super(key: key);

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  int _selectedIndex = 0;
  String currentAppBarTitle = 'Seller Dashboard';
  List<String> appBarTitles = [
    'Seller Dashboard',
    'Post Auction',
    'My Account',
  ];
  static final List<Widget> _widgetOptions = <Widget>[
    const SellerHomeScreenWidget(),
    const PostAuctionScreen1(),
    SellerMyAccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      //app bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.primaryColor,
        title: Text(currentAppBarTitle),
        centerTitle: true,
      ),
      //drawer
      drawer: UserDrawer('seller'),
      //body
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      //bottom navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              textStyle: TextStyle(
                fontFamily: theme.textTheme.bodyText1!.fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: theme.primaryColor,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.add,
                  text: 'Post Ad',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Account',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(
                  () {
                    _selectedIndex = index;
                    currentAppBarTitle = appBarTitles[index];
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
