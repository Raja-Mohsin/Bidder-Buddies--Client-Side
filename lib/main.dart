import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './screens/user_side_screens/user_home_screen.dart';
import './screens/welcome_screen.dart';

import './providers/user_provider.dart';
import './providers/auction_provider.dart';
import './providers/category_provider.dart';
import './providers/order_provider.dart';

Future<void> fcmBackgroundHandler(RemoteMessage message) async {
  // print('background fcm message recieved + ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(35, 41, 122, 1),
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: AuctionProvider()),
        ChangeNotifierProvider.value(value: CategoryProvider()),
        ChangeNotifierProvider.value(value: OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bidder Buddies',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.blue[50],
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color.fromRGBO(35, 41, 122, 1),
          ),
          primaryColor: const Color.fromRGBO(35, 41, 122, 1),
          textTheme: TextTheme(
            headline1: TextStyle(
              fontFamily: GoogleFonts.josefinSans().fontFamily,
              fontWeight: FontWeight.bold,
            ),
            bodyText1: TextStyle(
              fontFamily: GoogleFonts.roboto().fontFamily,
            ),
          ),
        ),
        home: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const UserHomeScreen();
            } else {
              return const WelcomeScreen();
            }
          },
          stream: FirebaseAuth.instance.userChanges(),
        ),
      ),
    );
  }
}
