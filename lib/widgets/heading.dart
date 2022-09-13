import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String firstLine;
  final String secondLine;

  Heading(this.firstLine, this.secondLine);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);

    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(
        left: 20,
        top: 20,
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            firstLine,
            style: TextStyle(
              fontFamily: theme.textTheme.headline1!.fontFamily,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            secondLine,
            style: TextStyle(
              fontFamily: theme.textTheme.headline1!.fontFamily,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
