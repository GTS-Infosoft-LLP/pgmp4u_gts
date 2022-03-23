import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pgmp4u/Screens/MockTest/MockTestAttempts.dart';
import 'package:pgmp4u/Screens/MockTest/ReviewMockTest.dart';
import 'package:pgmp4u/Screens/MockTest/mockTest.dart';
import 'package:pgmp4u/Screens/MockTest/mockTestQuestions.dart';
import 'package:pgmp4u/Screens/PracticeTests/practiceTest.dart';
import 'package:pgmp4u/Screens/Profile/PaymentStatus.dart';
import 'package:pgmp4u/Screens/Profile/paymentScreen.dart';
import 'package:pgmp4u/Screens/Profile/settingsScreen.dart';
import 'package:pgmp4u/Screens/StartScreen/SplashScreen.dart';
import 'package:pgmp4u/Screens/StartScreen/startScreen.dart';
import 'package:pgmp4u/Screens/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import './Screens/Dashboard/dashboard.dart';
import './Screens/Auth/login.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // set the publishable key for Stripe - this is mandatory
  /// For test mode
  // Stripe.publishableKey =
  //     'pk_test_51KVy8SSF6JrV3GLoEosrxIXwRIwVvXRjiwyRzpSuI6ZubE5snkYl17SFsqRkDEHslXrJLWbrxhYWajzZzChqV1o400ubhdYoep';

  // Stripe.publishableKey = 'pk_live_kUCek2XygEa1X04d7xu5qTmh';
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PurchaseProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (ctx) => SplashScreen(),
          '/start-screen': (ctx) => StartScreen(),
          '/login': (ctx) => LoginScreen(),
          '/test': (ctx) => Test(),
          '/dashboard': (ctx) => Dashboard(),
          '/practice-test': (ctx) => PracticeTest(),
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
