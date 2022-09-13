import 'package:flutter/material.dart';

class SortBottomSheet extends StatefulWidget {
  Function applySort;
  Function removeSort;

  SortBottomSheet(this.applySort, this.removeSort);

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Sort Auctions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
          //sort A-Z ascending
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.applySort('nameA');
            },
            child: Text(
              'Sort Alphabetically (Ascending)',
              style: TextStyle(
                color: theme.primaryColor,
              ),
            ),
          ),
          //sort A-Z descending
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.applySort('nameD');
            },
            child: Text(
              'Sort Alphabetically (Descending)',
              style: TextStyle(
                color: theme.primaryColor,
              ),
            ),
          ),
          //sort by date ascending
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.applySort('dateA');
            },
            child: Text(
              'Sort By Upload Date (Ascending)',
              style: TextStyle(
                color: theme.primaryColor,
              ),
            ),
          ),
          //sort by date descending
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.applySort('dateD');
            },
            child: Text(
              'Sort By Upload Date (Descending)',
              style: TextStyle(
                color: theme.primaryColor,
              ),
            ),
          ),
          //sort by price ascending
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.applySort('priceA');
            },
            child: Text(
              'Sort By Price (Ascending)',
              style: TextStyle(
                color: theme.primaryColor,
              ),
            ),
          ),
          //sort by price descending
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.applySort('priceD');
            },
            child: Text(
              'Sort By Price (Descending)',
              style: TextStyle(
                color: theme.primaryColor,
              ),
            ),
          ),
          //sort by min increment
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.applySort('minInc');
            },
            child: Text(
              'Sort By Minimum Increment',
              style: TextStyle(
                color: theme.primaryColor,
              ),
            ),
          ),
          //remove sort
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.removeSort();
            },
            child: const Text(
              'Remove Sorting',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
