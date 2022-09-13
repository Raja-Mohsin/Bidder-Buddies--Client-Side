import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userproject/shimmers/categories_shimmer_user_home_screen.dart';

import '../providers/category_provider.dart';
import '../models/category.dart';
import '../widgets/heading.dart';
import '../screens/user_side_screens/category_detail_screen.dart';

class AllCategories extends StatelessWidget {
  AllCategories({Key? key}) : super(key: key);

  List<Category> categories = [];

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    TextStyle bodyTextStyle =
        TextStyle(fontFamily: textTheme.bodyText1!.fontFamily);

    return Column(
      children: [
        //heading
        Heading('Browse', 'All Categories'),
        //categories
        FutureBuilder(
          future: Provider.of<CategoryProvider>(context, listen: false)
              .fetchAndSetCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CategoriesShimmerUserHomeScreen();
            }
            categories.clear();
            categories = Provider.of<CategoryProvider>(context).getCategories;
            return Container(
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
          },
        ),
      ],
    );
  }
}
