import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user_side_screens/category_detail_screen.dart';
import '../../models/category.dart';
import '../../providers/category_provider.dart';

class CategorySearchScreen extends StatelessWidget {
  CategorySearchScreen({Key? key}) : super(key: key);

  List<Category> categories = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<CategoryProvider>(context, listen: false)
          .fetchAndSetCategories(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        categories = Provider.of<CategoryProvider>(context).getCategories;
        return Container(
          margin: const EdgeInsets.only(top: 15),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(categories[index].name),
                    subtitle: Text(categories[index].subTitle),
                    leading: Image.network(categories[index].imageUrl),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryDetailScreen(categories[index].name),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
              );
            },
            itemCount: categories.length,
          ),
        );
      },
    );
  }
}
