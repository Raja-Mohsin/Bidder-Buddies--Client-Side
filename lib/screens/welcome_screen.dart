import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void loginButtonOnPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }

  void signupButtonOnPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SignupScreen();
        },
      ),
    );
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    getToken();
    initMessaging();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontFamily: theme.textTheme.headline1!.fontFamily,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Virtual Bidding',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontFamily: theme.textTheme.headline1!.fontFamily,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_aykitofz.json',
                width: bodyWidth * 0.75,
                height: bodyHeight * 0.4,
              ),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(bodyWidth * 0.75, 48),
                      primary: theme.primaryColor,
                      elevation: 10,
                    ),
                    onPressed: () {
                      loginButtonOnPressed(context);
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(bodyWidth * 0.75, 48),
                      side: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                    onPressed: () {
                      signupButtonOnPressed(context);
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initMessaging() {
    var androidInit =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInit = const IOSInitializationSettings();
    var initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initSettings);
    var androidDetails = const AndroidNotificationDetails(
      '1',
      'Default Channel',
      channelDescription: 'Bidder Buddies Notifications Channel',
      importance: Importance.high,
      priority: Priority.high,
    );
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage remoteMessage) {
        RemoteNotification notification = remoteMessage.notification!;
        AndroidNotification? androidNotification =
            remoteMessage.notification!.android;
        if (notification != null && androidNotification != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            generalNotificationDetails,
          );
        }
      },
    );
  }

  void getToken() {
    firebaseMessaging.getToken().then(
      (value) {
        String? token = value;
        print(token.toString() + ' noti token');
      },
    );
  }
}
