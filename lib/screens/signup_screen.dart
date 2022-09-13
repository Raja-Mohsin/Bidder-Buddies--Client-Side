import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:userproject/screens/login_screen.dart';

import '../providers/user_provider.dart';
import '../widgets/heading.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _passwordVisible = false;
  bool _isLoading = false;

  //text editing controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
              Heading('Signup to', 'your account'),
              //name text field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  decoration: InputDecoration(
                    label: const Text('Name'),
                    labelStyle: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      color: theme.primaryColor,
                    ),
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                    ),
                    icon: Icon(
                      Icons.person_rounded,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
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
                      Icons.email,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
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
              //phone number text field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  decoration: InputDecoration(
                    label: const Text('Phone'),
                    labelStyle: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      color: theme.primaryColor,
                    ),
                    hintText: 'Enter your phone number',
                    hintStyle: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                    ),
                    icon: Icon(
                      Icons.phone,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              //address text field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: addressController,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  decoration: InputDecoration(
                    label: const Text('Address'),
                    labelStyle: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      color: theme.primaryColor,
                    ),
                    hintText: 'Enter your current address',
                    hintStyle: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                    ),
                    icon: Icon(
                      Icons.add_road,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: bodyWidth * 0.12),
              //signup button
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
                            //if validation is correct, fetch the data
                            String email = emailController.text.toString();
                            String password =
                                passwordController.text.toString();
                            String name = nameController.text.toString();
                            String phone = phoneController.text.toString();
                            String address = addressController.text.toString();
                            //create user in firebase auth
                            await createUser(email, password, context);
                            //create user in firebase firestore
                            await Provider.of<UserProvider>(context,
                                    listen: false)
                                .createUserInFirestore(
                                    name, email, phone, address);
                            setState(() {
                              _isLoading = false;
                            });
                          } else {
                            //if validation error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(validationResult),
                                backgroundColor: Colors.red,
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: theme.textTheme.bodyText1!.fontFamily,
                          ),
                        ),
                      ),
                    ),
              //already have an account text
              Container(
                margin: EdgeInsets.only(top: bodyHeight * 0.04),
                child: Center(
                  child: Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              //login instead button
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
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Log in',
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
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      return 'All fields are required';
    } else if (nameController.text.length < 6) {
      return 'Name should be atleast 6 characters long';
    } else if (nameController.text.contains(RegExp(r'[0-9]'))) {
      return 'Name cannot contain number(s)';
    } else if (passwordController.text.length < 7) {
      return 'Password should be atleast 7 characters long';
    } else if (phoneController.text.length < 10) {
      return 'Enter a valid phone number';
    } else if (addressController.text.length < 15) {
      return 'Enter complete address';
    }
    return 'No Error';
  }

  Future<void> createUser(
      String email, String password, BuildContext context1) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context1).primaryColor,
          content: const Text(
              'Account Created!, Go to the login screen and login with your account'),
        ),
      );
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      phoneController.clear();
      addressController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context1).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context1).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context1).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
