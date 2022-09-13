import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../providers/category_provider.dart';
import './category_detail_screen.dart';
import '../../shimmers/categories_shimmer_user_home_screen.dart';
import '../../widgets/home_screen_heading.dart';
import '../../widgets/latest_auctions_home_screen.dart';
import '../../widgets/featured_auctions_home_screen.dart';
import '../../widgets/interested_auctions_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.changeIndex, {Key? key}) : super(key: key);

  final Function changeIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    TextStyle bodyTextStyle = TextStyle(
      fontFamily: textTheme.bodyText1!.fontFamily,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          //heading
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(
              left: 20,
              top: 20,
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover',
                  style: TextStyle(
                    fontFamily: theme.textTheme.headline1!.fontFamily,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'and start bidding',
                  style: TextStyle(
                    fontFamily: theme.textTheme.headline1!.fontFamily,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          //categories
          Container(
            margin: const EdgeInsets.only(
              left: 26,
              right: 26,
              top: 12,
              bottom: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontFamily: textTheme.headline1!.fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.changeIndex(1);
                  },
                  child: Text(
                    'See All',
                    style: bodyTextStyle,
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: Provider.of<CategoryProvider>(context, listen: false)
                .fetchAndSetCategories(),
            builder: (context, snapshot) {
              categories.clear();
              categories = Provider.of<CategoryProvider>(context).getCategories;
              categories.removeWhere((element) => element.name == 'Other');
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.9,
                    crossAxisCount: 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 10,
                    children: List.generate(
                      categories.length,
                      (index) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryDetailScreen(categories[index].name),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 8,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.network(
                                categories[index].imageUrl,
                                height: bodyHeight * 0.05,
                                width: bodyWidth * 0.1,
                              ),
                              Center(
                                child: Text(
                                  categories[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: textTheme.bodyText1!.fontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const CategoriesShimmerUserHomeScreen();
            },
          ),
          //featured auctions
          HomeScreenHeading('Featured Auctions'),
          FeaturedAuctionsHomeScreen(),
          //latest auctions
          HomeScreenHeading('Latest Auctions'),
          LatestAuctionsHomeScreen(),
          //your interests
          HomeScreenHeading('Your Interests'),
          InterestedAuctionsHomeScreen(),
        ],
      ),
    );
  }
}
