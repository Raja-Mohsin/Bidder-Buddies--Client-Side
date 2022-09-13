import 'package:flutter/material.dart';

import '../../widgets/heading.dart';

class BillingConfirmationScreen extends StatelessWidget {
  const BillingConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    Widget buildAmountRow(double bodyWidth, String label, String content) {
      return Container(
        width: bodyWidth * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(content),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //heading
              Heading('Confirm your', 'billing details'),
              const SizedBox(height: 15),
              //details card
              Center(
                child: SizedBox(
                  height: bodyHeight * 0.5,
                  width: bodyWidth * 0.9,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: bodyHeight * 0.12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildAmountRow(bodyWidth, 'Subtotal', 'Rs 63000'),
                          buildAmountRow(bodyWidth, 'Discount', '2%'),
                          buildAmountRow(bodyWidth, 'Shipping', 'Rs 2500'),
                          const Divider(
                            thickness: 1,
                            endIndent: 15,
                            indent: 15,
                          ),
                          buildAmountRow(bodyWidth, 'Total', 'Rs 64240'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              //Proceed button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(bodyWidth * 0.75, 48),
                    primary: theme.primaryColor,
                    elevation: 10,
                  ),
                  onPressed: () {},
                  child: Text(
                    'Order Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                    ),
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
