import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';

import '../../widgets/drawer.dart';
import './filters_results_screen.dart';

class FiltersScreen extends StatefulWidget {
  final List<String> categories;
  final List<String> cities;

  const FiltersScreen(this.categories, this.cities, {Key? key})
      : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<String> categoriesTags = [];
  List<String> citiesTags = [];
  double sliderStartValue = 500;
  double sliderEndValue = 10000;
  bool isCheckedFeatured = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    TextStyle headingStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );
    return Scaffold(
      drawer: UserDrawer('user'),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Refine Your Search',
          style: TextStyle(
            fontFamily: theme.textTheme.bodyText1!.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //heading
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: const Text(
                  'Select Filters',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //filters
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    child: Text(
                      'Categories',
                      style: headingStyle,
                    ),
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
                    child: Text(
                      'Cities',
                      style: headingStyle,
                    ),
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
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
                    child: Text(
                      'Price Range',
                      style: headingStyle,
                    ),
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                  ),
                  //price range slider
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: bodyWidth,
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
                            values:
                                RangeValues(sliderStartValue, sliderEndValue),
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
                  ),
                  Container(
                    child: Text(
                      'Featured',
                      style: headingStyle,
                    ),
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
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
              const SizedBox(height: 10),
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
                    style: TextStyle(color: theme.primaryColor, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
