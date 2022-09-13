import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesShimmerUserHomeScreen extends StatelessWidget {
  const CategoriesShimmerUserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Shimmer.fromColors(
      child: Container(
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
            10,
            (index) => Card(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: bodyHeight * 0.05,
                    width: bodyWidth * 0.1,
                  ),
                  Text(
                    'Name of Category',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontFamily: textTheme.bodyText1!.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
    );
  }
}
