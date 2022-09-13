import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/category.dart';
import '../../providers/category_provider.dart';

class ChooseInterestsScreen extends StatefulWidget {
  @override
  State<ChooseInterestsScreen> createState() => _ChooseInterestsScreenState();
}

class _ChooseInterestsScreenState extends State<ChooseInterestsScreen> {
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    loadInterests();
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories =
        Provider.of<CategoryProvider>(context).getCategories;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Interests'),
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              await saveInterests();
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(18),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: List.generate(
            categories.length,
            (index) => GestureDetector(
              onTap: () {
                setState(
                  () {
                    if (isIncludedAlready(categories[index].name)) {
                      selectedCategories.removeWhere(
                          (element) => element == categories[index].name);
                    } else {
                      selectedCategories.add(categories[index].name);
                    }
                  },
                );
              },
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2.5,
                    color: isIncludedAlready(categories[index].name)
                        ? theme.primaryColor
                        : Colors.white,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.network(
                      categories[index].imageUrl,
                      height: 80,
                      width: 80,
                    ),
                    Text(
                      categories[index].name,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isIncludedAlready(String name) {
    for (int i = 0; i < selectedCategories.length; i++) {
      if (name == selectedCategories[i]) {
        return true;
      }
    }
    return false;
  }

  Future<void> loadInterests() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? numberOfInterests = sharedPreferences.getInt('numberOfInterests');
    for (int i = 1; i <= numberOfInterests!; i++) {
      selectedCategories.add(
        sharedPreferences.getString('interest $i').toString(),
      );
    }
  }

  Future<void> saveInterests() async {
    //initialize shared pref and clear old data
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();

    //save data
    int numberOfInterests = selectedCategories.length;
    sharedPreferences.setInt('numberOfInterests', numberOfInterests);
    if (numberOfInterests > 0) {
      for (int i = 1; i <= numberOfInterests; i++) {
        sharedPreferences.setString('interest $i', selectedCategories[i - 1]);
      }
    }

    //show message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Interests Saved!'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );

    //close the screen
    Navigator.of(context).pop();
  }
}
