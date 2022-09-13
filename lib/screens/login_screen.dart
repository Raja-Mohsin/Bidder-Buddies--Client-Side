import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:userproject/screens/signup_screen.dart';

import '../screens/user_side_screens/user_home_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../widgets/heading.dart';
import './verify_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  bool _isLoading = false;

  //text editing variables
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //firebase variables
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //heading
              Heading('Login to', 'your account'),
              const SizedBox(height: 20),
              //email text field
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
              const SizedBox(height: 15),
              //password text field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: passwordController,
                  obscureText: _passwordVisible ? false : true,
                  maxLines: 1,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: theme.primaryColor,
                      ),
                    ),
                    label: const Text('Password'),
                    labelStyle: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      color: theme.primaryColor,
                    ),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                    ),
                    icon: Icon(
                      Icons.security,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              //forgot password text
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ForgotPasswordScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 10, right: 15),
                  child: Text(
                    'forgot your password?',
                    style: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      fontSize: 16,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: bodyHeight * 0.08),
              //login button
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
                            String password =
                                passwordController.text.toString();
                            //login the user
                            await loginUser(email, password, context);
                            setState(() {
                              _isLoading = false;
                            });
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
                          'Log in',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: theme.textTheme.bodyText1!.fontFamily,
                          ),
                        ),
                      ),
                    ),
              //dont have an account text
              Container(
                margin: EdgeInsets.only(top: bodyHeight * 0.07),
                child: Center(
                  child: Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              //sign up instead button
              Container(
                margin: const EdgeInsets.only(top: 18),
                child: Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(bodyWidth * 0.75, 48),
                      side: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.primaryColor,
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      ),
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
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return 'Email or Password cannot be empty';
    }
    return 'No Error';
  }

  Future<void> loginUser(
      String email, String password, BuildContext context1) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      //clear fields
      emailController.clear();
      passwordController.clear();
      //move to the next screen
      if (firebaseAuth.currentUser!.emailVerified) {
        //move to home screen if email is already verified
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const UserHomeScreen(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        //show success msg
        ScaffoldMessenger.of(context1).showSnackBar(
          SnackBar(
            content: const Text('Sign in succeeded, Welcome Back!'),
            backgroundColor: Theme.of(context1).primaryColor,
          ),
        );
      } else {
        //move to home screen if email is not verified
        Navigator.of(context1).push(
          MaterialPageRoute(
            builder: (context) => const VerifyEmailScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Verify your email before starting bidding'),
            backgroundColor: Theme.of(context1).primaryColor,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context1).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context1).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context1).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
