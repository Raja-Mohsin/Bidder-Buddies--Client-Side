import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> categories = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<Category> get getCategories {
    return [...categories];
  }

  Future<void> fetchAndSetCategories() async {
    categories.clear();
    await firebaseFirestore.collection('categories').get().then(
      (snapshot) {
        snapshot.docs.forEach(
          (category) {
            categories.add(
              Category(
                category['name'],
                category['subTitle'],
                category['url'],
              ),
            );
          },
        );
      },
    );
    notifyListeners();
  }
}
