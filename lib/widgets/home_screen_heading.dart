import 'package:flutter/material.dart';

class HomeScreenHeading extends StatelessWidget {
  final String headingText;

  HomeScreenHeading(this.headingText);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 26, top: 25),
      child: Text(
        headingText,
        style: TextStyle(
          fontFamily: textTheme.headline1!.fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
