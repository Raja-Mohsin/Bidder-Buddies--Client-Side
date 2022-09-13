import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';

import '../screens/user_side_screens/filters_results_screen.dart';

class FiltersAlertDialog extends StatefulWidget {
  List<String> categories;
  List<String> cities;

  FiltersAlertDialog(this.categories, this.cities);

  @override
  State<FiltersAlertDialog> createState() => _FiltersAlertDialogState();
}

class _FiltersAlertDialogState extends State<FiltersAlertDialog> {
  List<String> categoriesTags = [];
  List<String> citiesTags = [];
  double sliderStartValue = 500;
  double sliderEndValue = 50000;
  bool isCheckedFeatured = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(6),
      //title of the dialog
      title: const Text('Select Filters'),
      //content of the dialog
      content: Column(
        children: [
          Container(
            child: const Text('Categories'),
            margin: const EdgeInsets.symmetric(vertical: 15),
          ),
          //categories choice chips
          ChipsChoice<String>.multiple(
            value: categoriesTags,
            onChanged: (val) {
              setState(() {
                categoriesTags = val;
              });
            },
            choiceItems: C2Choice.listFrom<String, String>(
              source: widget.categories,
              value: (i, v) => v,
              label: (i, v) => v,
            ),
          ),
          Container(
            child: const Text('Cities'),
            margin: const EdgeInsets.symmetric(vertical: 15),
          ),
          //cities choice chips
          ChipsChoice<String>.multiple(
            value: citiesTags,
            onChanged: (val) => setState(() {
              citiesTags = val;
            }),
            choiceItems: C2Choice.listFrom<String, String>(
              source: widget.cities,
              value: (i, v) => v,
              label: (i, v) => v,
            ),
          ),
          Container(
            child: const Text('Price Range'),
            margin: const EdgeInsets.symmetric(vertical: 15),
          ),
          //price range slider
          SizedBox(
            width: bodyWidth * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //start value indicator
                Text(
                  'Rs. ' + sliderStartValue.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 12),
                ),
                //slider
                RangeSlider(
                  activeColor: theme.primaryColor,
                  min: 100,
                  max: 100000,
                  divisions: 40,
                  values: RangeValues(sliderStartValue, sliderEndValue),
                  onChanged: (RangeValues newValues) {
                    setState(() {
                      sliderStartValue = newValues.start;
                      sliderEndValue = newValues.end;
                    });
                  },
                ),
                //end value indicator
                Text(
                  'Rs. ' + sliderEndValue.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            child: const Text('Featured'),
            margin: const EdgeInsets.symmetric(vertical: 15),
          ),
          //featured check box
          CheckboxListTile(
            title: const Text('Show featured auctions'),
            activeColor: theme.primaryColor,
            value: isCheckedFeatured,
            onChanged: (bool? newValue) {
              setState(() {
                isCheckedFeatured = newValue!;
              });
            },
          ),
        ],
      ),
      actions: [
        //apply button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: theme.primaryColor,
            elevation: 10,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FiltersResultsScreen(
                  categoriesTags,
                  citiesTags,
                  sliderEndValue,
                  sliderStartValue,
                  isCheckedFeatured,
                ),
              ),
            );
          },
          child: Text(
            'Apply & Search',
            style: TextStyle(
              fontSize: 16,
              fontFamily: theme.textTheme.bodyText1!.fontFamily,
            ),
          ),
        ),
        //cancel button
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
