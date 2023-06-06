import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pgmp4u/Screens/MockTest/MockTestAttempts.dart';
import 'package:pgmp4u/Screens/MockTest/ReviewMockTest.dart';
import 'package:pgmp4u/Screens/MockTest/mockTest.dart';
import 'package:pgmp4u/Screens/MockTest/mockTestQuestions.dart';
import 'package:pgmp4u/Screens/PracticeTests/practiceTextProvider.dart';
import 'package:pgmp4u/Screens/Profile/PaymentStatus.dart';
import 'package:pgmp4u/Screens/Profile/paymentScreen.dart';
import 'package:pgmp4u/Screens/Profile/settingsScreen.dart';
import 'package:pgmp4u/Screens/StartScreen/SplashScreen.dart';
import 'package:pgmp4u/Screens/StartScreen/startScreen.dart';
import 'package:pgmp4u/Screens/Tests/provider/category_provider.dart';
import 'package:pgmp4u/Screens/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pgmp4u/provider/player_provider.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:pgmp4u/provider/response_provider.dart';
import './Screens/Dashboard/dashboard.dart';
import './Screens/Auth/login.dart';
import 'package:provider/provider.dart';

import 'Screens/PracticeTests/practiceTest copy.dart';
import 'Screens/Tests/local_handler/hive_handler.dart';
import 'Services/globalcontext.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHandler.hiveRegisterAdapter().then((value) {
      print("**************** hive register initialization *************");
    });
  // set the publishable key for Stripe - this is mandatory
  /// For test mode
  // Stripe.publishableKey =
  //     'pk_test_51KVy8SSF6JrV3GLoEosrxIXwRIwVvXRjiwyRzpSuI6ZubE5snkYl17SFsqRkDEHslXrJLWbrxhYWajzZzChqV1o400ubhdYoep';

  // Stripe.publishableKey = 'pk_live_kUCek2XygEa1X04d7xu5qTmh';
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown], );
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //     statusBarColor: Colors.white, // Color for Android
    //     statusBarBrightness:
    //         Brightness.dark // Dark == white status bar -- for IOS.
    //     ));

    return MultiProvider(
      providers: [

        ChangeNotifierProvider<PurchaseProvider>(
            create: (_) => PurchaseProvider()),
        ChangeNotifierProvider<ResponseProvider>(
          create: (_) => ResponseProvider(),
        ),
        ChangeNotifierProvider<PlayerProvider>(create: (_) => PlayerProvider()),
        ChangeNotifierProvider<PracticeTextProvider>(
            create: (_) => PracticeTextProvider()),

        ChangeNotifierProvider<CategoryProvider>(
            create: (_) => CategoryProvider()),


      ],
      child: MaterialApp(
         navigatorKey: GlobalVariable.navState,
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (ctx) => SplashScreen(),
          '/start-screen': (ctx) => StartScreen(),
          '/login': (ctx) => LoginScreen(),
          '/test': (ctx) => Test(),
          '/dashboard': (ctx) => Dashboard(),
          '/practice-test': (ctx) => PracticeTestCopy(),
          // '/practice-test': (ctx) => PracticeTest(),
          '/mock-test': (ctx) => MockTest(),
          '/mock-test-attempts': (ctx) => MockTestAttempts(),
          '/mock-test-questions': (ctx) => MockTestQuestions(),
          '/review-mock-test': (ctx) => ReviewMockTest(),
          '/settings': (ctx) => SettingsScreen(),
          '/payment': (ctx) => PaymentScreen(),
          '/payment-status': (ctx) => PaymentStatus(),
        },
      ),
    );
  }
}
