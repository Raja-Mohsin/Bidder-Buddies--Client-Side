import 'package:flutter/material.dart';

import './categories_search_screen.dart';
import './interests_screen.dart';

class SearchScreenWidget extends StatefulWidget {
  const SearchScreenWidget({Key? key}) : super(key: key);

  @override
  State<SearchScreenWidget> createState() => _SearchScreenWidgetState();
}

class _SearchScreenWidgetState extends State<SearchScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: TabBarView(
        children: [
          CategorySearchScreen(),
          InterestsScreen(),
        ],
      ),
    );
  }
}
