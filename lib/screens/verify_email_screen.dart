import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/heading.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String? currentUserEmail = firebaseAuth.currentUser!.email;

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
      body: FutureBuilder(
          future: firebaseAuth.currentUser!.sendEmailVerification(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SafeArea(
                child: Center(
                  child: CircularProgressIndicator(
                    color: theme.primaryColor,
                  ),
                ),
              );
            }
            //else if (snapshot.connectionState == ConnectionState.done) {
            //  if (snapshot.hasData) {
            return SafeArea(
              child: Expanded(
                child: Column(
                  children: [
                    //heading
                    Heading('Verify your', 'email address'),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/images/verify_email.png',
                            height: 170,
                            width: 170,
                          ),
                          Column(
                            children: [
                              Text(
                                'Confirm your email address',
                                style: TextStyle(
                                  fontFamily:
                                      theme.textTheme.bodyText1!.fontFamily,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'We have sent a confirmation email to:',
                                style: TextStyle(
                                  fontFamily:
                                      theme.textTheme.bodyText1!.fontFamily,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              //user email
                              Text(
                                currentUserEmail!,
                                style: TextStyle(
                                  fontFamily:
                                      theme.textTheme.bodyText1!.fontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'Check your email and click on the confirmation link to continue bidding.',
                              style: TextStyle(
                                fontFamily:
                                    theme.textTheme.bodyText1!.fontFamily,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Column(
                            children: [
                              //back button
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
                                    'Back to Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily:
                                          theme.textTheme.bodyText1!.fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              //resend confirmation email button
                              Container(
                                margin: const EdgeInsets.only(top: 14),
                                child: Center(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      fixedSize: Size(bodyWidth * 0.75, 48),
                                      side: BorderSide(
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    onPressed: () async {
                                      await firebaseAuth.currentUser!
                                          .sendEmailVerification();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                              'Verification link sent to your email'),
                                          backgroundColor: theme.primaryColor,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Resend Email',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: theme.primaryColor,
                                        fontFamily: theme
                                            .textTheme.bodyText1!.fontFamily,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          //}
          //},
          ),
    );
  }
}
