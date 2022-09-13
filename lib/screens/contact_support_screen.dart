import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../widgets/heading.dart';

class ContactSupportScreen extends StatelessWidget {
  ContactSupportScreen({Key? key}) : super(key: key);

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController subjectController = TextEditingController();
  TextEditingController issueMsgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    String userEmail = firebaseAuth.currentUser!.email.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //heading
              Heading('We\'re here', 'to help'),
              //sub heading text
              Container(
                margin: const EdgeInsets.only(left: 20, right: 50),
                child: Text(
                  'Share your issue and information with us, we will get back to you as soon as possible, Thanks for trusting us',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: theme.textTheme.bodyText1!.fontFamily,
                  ),
                ),
              ),
              //subject heading
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20, top: 40),
                child: const Text(
                  'Subject',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              //subject text field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: subjectController,
                  cursorColor: theme.primaryColor,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              //issue heading
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20, top: 40),
                child: const Text(
                  'Issue/Message',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              //issue msg text field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  maxLines: 6,
                  controller: issueMsgController,
                  cursorColor: theme.primaryColor,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              //send button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(bodyWidth * 0.75, 48),
                    primary: theme.primaryColor,
                    elevation: 10,
                  ),
                  onPressed: () async {
                    String validationResult = validation();
                    if (validationResult == 'No Error') {
                      //send email
                      final Email email = Email(
                        body: issueMsgController.text.toString(),
                        subject: subjectController.text.toString(),
                        recipients: [userEmail],
                      );
                      await FlutterEmailSender.send(email);
                      //show success msg
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Email sent, we will get back to you shortly.'),
                          backgroundColor: theme.primaryColor,
                        ),
                      );
                    } else {
                      //show error msg
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(validationResult),
                          backgroundColor: theme.primaryColor,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Send Request',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String validation() {
    if (subjectController.text.isEmpty || issueMsgController.text.isEmpty) {
      return 'All fields are required and can\'t be empty';
    }
    if (subjectController.text.length < 5) {
      return 'Subject too short';
    }
    if (issueMsgController.text.length < 20) {
      return 'Kindly explain the issue breifly';
    }
    return 'No Error';
  }
}
