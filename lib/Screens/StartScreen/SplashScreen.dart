import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pgmp4u/Screens/Profile/notifications.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/screen/discussionGoupList.dart';
import 'package:pgmp4u/Services/globalcontext.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/user_object.dart';
import '../Tests/local_handler/hive_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String tokenData;
  ChatProvider chatProvider;
  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    chatProvider = Provider.of(context, listen: false);
    chatProvider.initSharePreferecne();
    //Return String
    String stringValue = prefs.getString('token');
    return stringValue;
  }

  navigateToScreen() async {
    String value = await getValue();
    setState(() {
      tokenData = value;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Timer timer = new Timer(new Duration(seconds: 2), () async {
      if (value != null) {
        String token = prefs.getString('token');
        String photo = prefs.getString('photo');
        String name = prefs.getString('name');
        String email = prefs.getString('email');
        var _user = UserModel(image: photo, name: name, token: token, email: email);
        UserObject.setUser(_user);

        Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (r) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil('/start-screen', (r) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print(double.infinity);
    localDataUpdate();
    fireNotification();
    navigateToScreen();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   // Timer timer = new Timer(new Duration(seconds: 5), () {

  //   //    Navigator.of(context).pushNamed('');
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      // height: double.infinity,
      color: Colors.white,
      child: Center(
        child: Container(
          child: Image.asset(
            'assets/pgmp4u.png',
          ),
        ),
      ),
    );
  }

  // check local user object if not found any user object move login screen.
  /// if fount user object move to dashboard screeen.
  /// if found that user not see on-boarding then move on-boarding sreeen.
  localDataUpdate() async {
    print("---------------: GETTING FIREBASE TOKEN :----------------");
    var messaging = FirebaseMessaging.instance;
    messaging.getToken(vapidKey: "").then((value) async {
      print("fcm token $value");
      HiveHandler.setDeviceToken(value);
      String token = await HiveHandler.getDeviceToken();
      print("get device token after set $token");

      // api.updateDeviceIdUser({"deviceId": value});
    });
  }

  fireNotification() async {
    LocalNotifications().init();
    print(">>>>>>>>>>>?????????????<<<<<<<<<<<<<<< firebase Notification");
    
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print(">>>>>>>>>>>?????????????<<<<<<<<<<<<<<< firebase onMessage");
      print("notification====${event.data}");
      // print("event notification sss====${event.notification}");
      print("noti body ====${event.notification.body}");
      print("noti body ====${event.notification.title}");

      if (event.notification != null) {
        print(">>>>>>>>>>>?????????????<<<<<<<<<<<<<<< firebase onMessage 1");
        LocalNotifications().showNotification(
          title: '${event.notification.body}',
          body: '',
          payload: jsonEncode(event.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Listen onMessageOpenedApp   ${message.data}");

      print("Notificationsssssss>>>>>>");
      print("NOTIFICATION json$message");

      print("NOTIFICATION======$json");
      print("tpmdjsdvjsdv======${["notificationType"]}");
      print("   ${['Notificationtype']}");

      print("Notificationsssssss>>>>>>");

      print("NOTIFICATION======$json");
      print("   ${['Notificationtype']}");

      switch (['Notificationtype'].toString()) {
        case "1":
        // Navigator.push(GlobalVariable.navState.currentContext, MaterialPageRoute(builder: (context)=>Notifications()));
        //   break;
        case "2":
        //  Navigator.push(GlobalVariable.navState.currentContext, MaterialPageRoute(builder: (context)=>Notifications()));
        //   break;
        case "3":
        //  Navigator.push(GlobalVariable.navState.currentContext, MaterialPageRoute(builder: (context)=>Notifications()));
        //   break;
        case "4":
          Navigator.push(
              GlobalVariable.navState.currentContext, MaterialPageRoute(builder: (context) => Notifications()));
          break;
      }

      // if (message.data["notificationType"] == "1") {
      //   Navigator.of(GlobalVariable.navState.currentContext!).push(
      //       MaterialPageRoute(builder: (context) => const Notifications()));
      // } else if (message.data["notificationType"] == "2") {
      //   Navigator.of(GlobalVariable.navState.currentContext!)
      //       .push(MaterialPageRoute(builder: (context) => const Rewards()));
      // } else {}
    });
  }
}

//  // // for local Notification.........
class LocalNotifications {
  static final _notification = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
  final IOSInitializationSettings initializationSettingsIOS = const IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  var initializationSettings;
  Future init() async {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-------text1");
    initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: null);
    print("text2");
    _notification.initialize(initializationSettings, onSelectNotification: selectNotification);
  }

  Future showNotification({
    int id = 0,
    String title = "",
    String body = "",
    String payload = "",
  }) async {
    print(">>>>>>>>>>>?????????????<<<<<<<<<<<<<<< firebase onMessage 2 $id, title $title body $body ");
    _notification.show(id, title, body, await _notificationDetails(), payload: payload);
  }

  void selectNotification(String pay) {
    print("Notificationsssssss>>>>>>");
    print("NOTIFICATION json $pay");
    var json = jsonDecode(pay);

    print("NOTIFICATION======$json");
    print(" typeeeee=====  ${['Notificationtype']}");
    print(" typeeeee sdsd=====  ${json['notificationType']}");

    print("selectNotification type$pay");
    switch (json["notificationType"].toString()) {
      case "1":
      // Navigator.push(GlobalVariable.navState.currentContext, MaterialPageRoute(builder: (context)=>Notifications()));
      //   break;
      case "2":
      //  Navigator.push(GlobalVariable.navState.currentContext, MaterialPageRoute(builder: (context)=>Notifications()));
      //   break;
      case "3":
        //  Navigator.push(GlobalVariable.navState.currentContext, MaterialPageRoute(builder: (context)=>Notifications()));
        //   break;
        Navigator.push(
            GlobalVariable.navState.currentContext, MaterialPageRoute(builder: (context) => GroupListPage()));
        break;
      case "4":
        Navigator.push(
            GlobalVariable.navState.currentContext, MaterialPageRoute(builder: (context) => Notifications()));
        break;
      default:
        Navigator.push(
            GlobalVariable.navState.currentContext, MaterialPageRoute(builder: (context) => Notifications()));
    }
    // if(){}
    // if (pay == "one") {
    //   Navigator.of(GlobalVariable.navState.currentContext!)
    //       .push(MaterialPageRoute(builder: (context) => const Notifications()));
    // } else if (pay == "two") {
    //   Navigator.of(GlobalVariable.navState.currentContext!)
    //       .push(MaterialPageRoute(builder: (context) => const Rewards()));
    // } else {}
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName', importance: Importance.max),
        iOS: IOSNotificationDetails(presentBadge: true, presentSound: true, presentAlert: true));
  }
}
