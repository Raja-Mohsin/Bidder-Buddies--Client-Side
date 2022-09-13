import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:userproject/widgets/heading.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;
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
              Heading('Forgot your', 'password?'),
              //image with helping text
              Column(
                children: [
                  Image.asset(
                    'assets/images/forgot_password.png',
                    width: bodyWidth * 0.6,
                    height: bodyHeight * 0.25,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 30,
                    ),
                    child: Text(
                      'Enter the email address associated with your account and we\'ll send an email with instructions to reset your password.',
                      style: TextStyle(
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
              SizedBox(height: bodyHeight * 0.06),
              //input field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  decoration: InputDecoration(
                    label: const Text('Email'),
                    labelStyle: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      color: theme.primaryColor,
                    ),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                    ),
                    icon: Icon(
                      Icons.person,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: bodyHeight * 0.06),
              //button
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                      ),
                    )
                  : Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(bodyWidth * 0.75, 48),
                          primary: theme.primaryColor,
                          elevation: 10,
                        ),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          String validationResult = validation();
                          if (validationResult == 'No Error') {
                            String email = emailController.text.toString();
                            try {
                              await firebaseAuth.sendPasswordResetEmail(
                                  email: email);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(e.toString()),
                                ),
                              );
                              setState(() {
                                _isLoading = false;
                              });
                              return;
                            }
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: theme.primaryColor,
                                content: const Text(
                                    'Password Reset Link has been sent to your email.'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(validationResult),
                                backgroundColor: Colors.red,
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          }
                        },
                        child: Text(
                          'Send Reset Link',
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

  String validation() {
    if (emailController.text.isEmpty) {
      return 'Email cannot be empty';
    }
    return 'No Error';
  }
}
