import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_ya4ycrti.json',
                width: 300,
                height: 300,
                animate: true),
            margin: const EdgeInsets.only(top: 40),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Confirmation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: theme.textTheme.bodyText1!.fontFamily,
                ),
              ),
              SizedBox(
                height: bodyHeight * 0.03,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: bodyWidth * 0.15,
                ),
                child: const Center(
                  child: Text(
                    'You have successfully completed your payment procedure',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          //login button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(bodyWidth * 0.75, 48),
                primary: theme.primaryColor,
                elevation: 10,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Great!',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: theme.textTheme.bodyText1!.fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
