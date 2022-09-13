import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/category.dart';
import '../user_side_screens/filters_screen.dart';
import '../../widgets/drawer.dart';
import '../../widgets/search_delegate_home_screen.dart';
import '../../widgets/all_categories.dart';
import './home_screen_widget.dart';
import './user_my_account_screen.dart';
import './search_screen.dart';
import '../../models/auction.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String currentAppBarTitle = 'Get Started!';
  List<String> appBarTitles = [
    'Get Started!',
    'Categories',
    'Search',
    'My Account',
  ];
  void _changeWidget(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Auction> auctions = [];
  int _selectedIndex = 0;
  bool isLoading = false;
  late final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(_changeWidget),
    AllCategories(),
    const SearchScreenWidget(),
    MyAccountUser(),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appBar: AppBar(
        // bottom: _selectedIndex == 2
        //     ? const TabBar(
        //         indicatorColor: Colors.white,
        //         indicatorWeight: 3,
        //         tabs: [
        //           Tab(
        //             text: 'Categories',
        //           ),
        //           Tab(
        //             text: 'Interests',
        //           ),
        //         ],
        //       )
        //     : null,
        //   elevation: 0,
        //   backgroundColor: theme.primaryColor,
        //   title: Text(currentAppBarTitle),
        //   centerTitle: true,
        // actions: [
        //   //filters icon button
        //   if (_selectedIndex != 3)
        //     isLoading
        //         ? const Center(
        //             child: CircularProgressIndicator(
        //               color: Colors.amber,
        //             ),
        //           )
        //         : IconButton(
        //             onPressed: () async {
        //               setState(() {
        //                 isLoading = true;
        //               });
        //               //fetch cities and categories from database
        //               QuerySnapshot<Map<String, dynamic>> citiesSnapshot =
        //                   await firebaseFirestore.collection('cities').get();
        //               QuerySnapshot<Map<String, dynamic>> categoriesSnapshot =
        //                   await firebaseFirestore
        //                       .collection('categories')
        //                       .get();
        //               List<Category> fetchedCategories = [];
        //               List<String> fetchedCities = [];
        //               categoriesSnapshot.docs.forEach(
        //                 (category) {
        //                   fetchedCategories.add(
        //                     Category(
        //                       category['name'],
        //                       category['subTitle'],
        //                       category['url'],
        //                     ),
        //                   );
        //                 },
        //               );
        //               citiesSnapshot.docs.forEach(
        //                 (city) {
        //                   fetchedCities.add(
        //                     city['name'].toString(),
        //                   );
        //                 },
        //               );
        //               List<String> categoriesString =
        //                   fetchedCategories.map((e) => e.name).toList();
        //               setState(() {
        //                 isLoading = false;
        //               });
        //               showDialog(
        //                 context: context,
        //                 builder: (context) {
        //                   return FiltersAlertDialog(
        //                       categoriesString, fetchedCities);
        //                 },
        //               );
        //             },
        //             icon: const Icon(Icons.filter_list_rounded),
        //           ),
        //   //search icon button
        //   if (_selectedIndex == 2)
        //     FutureBuilder(
        //       future: firebaseFirestore
        //           .collection('auctions')
        //           .where('status', isEqualTo: 'approved')
        //           .get(),
        //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return Container();
        //         }
        //         //add fetched auctions to the list
        //         auctions.clear();
        //         snapshot.data!.docs.forEach(
        //           (auction) {
        //             //convert dynamic lists to string type lists
        //             List<dynamic> imageUrlsDynamicList = auction['imageUrls'];
        //             List<dynamic> bidsDynamicList = auction['bids'];
        //             List<String> imageUrlsList = imageUrlsDynamicList
        //                 .map((e) => e.toString())
        //                 .toList();
        //             List<String> bidsList =
        //                 bidsDynamicList.map((e) => e.toString()).toList();
        //             auctions.add(
        //               Auction(
        //                 auction['id'],
        //                 auction['name'],
        //                 auction['description'],
        //                 imageUrlsList,
        //                 bidsList,
        //                 auction['sellerId'],
        //                 auction['date'],
        //                 auction['time'],
        //                 auction['category'],
        //                 auction['city'],
        //                 auction['minIncrement'],
        //                 auction['terminationDate'],
        //                 auction['startingPrice'],
        //                 auction['maxPrice'],
        //                 auction['status'],
        //                 auction['featured'],
        //               ),
        //             );
        //           },
        //         );
        //         return IconButton(
        //           onPressed: () {
        //             showSearch(
        //               context: context,
        //               delegate: SearchDelegateHomeScreen(auctions, context),
        //             );
        //           },
        //           icon: const Icon(Icons.search),
        //         );
        //       },
        //     ),
        // ],
        // ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0,
              backgroundColor: theme.primaryColor,
              title: Text(currentAppBarTitle),
              centerTitle: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  child: Image.asset('assets/images/app-icon.png'),
                  padding: EdgeInsets.only(
                    top: 100,
                    bottom: _selectedIndex == 2 ? 50 : 30,
                    left: 30,
                    right: 30,
                  ),
                ),
              ),
              bottom: _selectedIndex == 2
                  ? const TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(
                          text: 'Categories',
                        ),
                        Tab(
                          text: 'Interests',
                        ),
                      ],
                    )
                  : null,
              actions: [
                //filters icon button
                if (_selectedIndex != 3)
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        )
                      : IconButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            //fetch cities and categories from database
                            QuerySnapshot<Map<String, dynamic>> citiesSnapshot =
                                await firebaseFirestore
                                    .collection('cities')
                                    .get();
                            QuerySnapshot<Map<String, dynamic>>
                                categoriesSnapshot = await firebaseFirestore
                                    .collection('categories')
                                    .get();
                            List<Category> fetchedCategories = [];
                            List<String> fetchedCities = [];
                            categoriesSnapshot.docs.forEach(
                              (category) {
                                fetchedCategories.add(
                                  Category(
                                    category['name'],
                                    category['subTitle'],
                                    category['url'],
                                  ),
                                );
                              },
                            );
                            citiesSnapshot.docs.forEach(
                              (city) {
                                fetchedCities.add(
                                  city['name'].toString(),
                                );
                              },
                            );
                            List<String> categoriesString =
                                fetchedCategories.map((e) => e.name).toList();
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FiltersScreen(
                                    categoriesString, fetchedCities),
                              ),
                            );
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return FiltersAlertDialog(
                            //         categoriesString, fetchedCities);
                            //   },
                            // );
                          },
                          icon: const Icon(Icons.filter_list_rounded),
                        ),
                //search icon button
                if (_selectedIndex == 2)
                  FutureBuilder(
                    future: firebaseFirestore
                        .collection('auctions')
                        .where('status', isEqualTo: 'approved')
                        .get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      //add fetched auctions to the list
                      auctions.clear();
                      snapshot.data!.docs.forEach(
                        (auction) {
                          //convert dynamic lists to string type lists
                          List<dynamic> imageUrlsDynamicList =
                              auction['imageUrls'];
                          List<dynamic> bidsDynamicList = auction['bids'];
                          List<String> imageUrlsList = imageUrlsDynamicList
                              .map((e) => e.toString())
                              .toList();
                          List<String> bidsList =
                              bidsDynamicList.map((e) => e.toString()).toList();
                          auctions.add(
                            Auction(
                              auction['id'],
                              auction['name'],
                              auction['description'],
                              imageUrlsList,
                              bidsList,
                              auction['sellerId'],
                              auction['date'],
                              auction['time'],
                              auction['category'],
                              auction['city'],
                              auction['minIncrement'],
                              auction['terminationDate'],
                              auction['startingPrice'],
                              auction['maxPrice'],
                              auction['status'],
                              auction['featured'],
                            ),
                          );
                        },
                      );
                      return IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate:
                                SearchDelegateHomeScreen(auctions, context),
                          );
                        },
                        icon: const Icon(Icons.search),
                      );
                    },
                  ),
              ],
            ),
            SliverToBoxAdapter(
              child: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ),
          ],
        ),
        // Center(
        //   child: _widgetOptions.elementAt(_selectedIndex),
        // ),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
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
                    icon: Icons.category,
                    text: 'Categories',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Account',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                    currentAppBarTitle = appBarTitles[index];
                  });
                },
              ),
            ),
          ),
        ),
        //drawer
        drawer: UserDrawer('user'),
      ),
    );
  }
}
