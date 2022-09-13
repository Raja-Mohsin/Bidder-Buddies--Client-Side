import 'package:flutter/material.dart';

import '../../widgets/heading.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Widget buildField(
      String heading, String content, String key, double bodyWidth) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: bodyWidth * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(content),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int paymentMethod = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

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
              Heading('Check your', 'order details'),
              //details fields
              buildField(
                  'Receiver\'s Name', 'Mohsin Nadeem', 'name', bodyWidth),
              buildField('Phone no', '03355850501', 'phone', bodyWidth),
              buildField('City', 'Rawalpindi', 'city', bodyWidth),
              buildField('Address', 'House no 34 street 45 saddar', 'address',
                  bodyWidth),
              buildField('Postal Code', '46000', 'postal', bodyWidth),
              const SizedBox(height: 5),
              //payment details
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: theme.primaryColor,
                        value: 0,
                        groupValue: paymentMethod,
                        onChanged: (int? value) {
                          setState(() {
                            paymentMethod = value!;
                          });
                        },
                      ),
                      const Text('Cash on Delivery'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: theme.primaryColor,
                        value: 1,
                        groupValue: paymentMethod,
                        onChanged: (int? value) {
                          setState(() {
                            paymentMethod = value!;
                          });
                        },
                      ),
                      const Text('Payment through Card'),
                    ],
                  ),
                ],
              ),
              //proceed button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(bodyWidth * 0.75, 48),
                    primary: theme.primaryColor,
                    elevation: 10,
                  ),
                  onPressed: () {},
                  child: Text(
                    'Proceed',
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
