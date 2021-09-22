import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/Dashboard/DashboardScreen.dart';
import 'package:pgmp4u/Screens/Profile/profile.dart';
import 'package:pgmp4u/Screens/Tests/testsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  final selectedId;

  Dashboard({
    this.selectedId,
  });

  @override
  _DashboardState createState() =>
      _DashboardState(selectedIdNew: this.selectedId);
}

class _DashboardState extends State<Dashboard> {
  final selectedIdNew;
  String photoUrl;
  _DashboardState({
    this.selectedIdNew,
  });
  int _currentIndex = 0;
  void updateCurrentIndex() {}
  void updateStatus() {
    setState(() {
      _currentIndex = 1;
    });
  }

  final List<Widget> _children = [
    DashboardScreen(selectedId: () => {print('object')}),
    TestsScreen(),
    Profile()
  ];

  void onTabTapped(int index) async {
    // users
    //     .add({
    //       'step1': 'fullName', // John Doe
    //     })
    //     .then((value) => print("User Added"))
    //     .catchError((error) => print("Failed to add user: $error"));

    setState(() {
      _currentIndex = index;
    });
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('photo');
    setState(() {
      photoUrl = stringValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print(MediaQuery.of(context).padding.top);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.home,
                size: width * (26 / 420),
                color: _currentIndex == 0
                    ? _colorfromhex("#3846A9")
                    : _colorfromhex("#ABAFD1"),
              ),
              title: Text(
                'Dashboard',
                style: TextStyle(
                  fontFamily: 'Roboto Medium',
                  fontSize: width * (12 / 420),
                  color: _currentIndex == 0
                      ? _colorfromhex("#3846A9")
                      : _colorfromhex("#ABAFD1"),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.assignment,
                color: _currentIndex == 1
                    ? _colorfromhex("#3846A9")
                    : _colorfromhex("#ABAFD1"),
                size: width * (26 / 420),
              ),
              title: Text(
                'Tests4U',
                style: TextStyle(
                  color: _currentIndex == 1
                      ? _colorfromhex("#3846A9")
                      : _colorfromhex("#ABAFD1"),
                  fontFamily: 'Roboto Medium',
                  fontSize: width * (12 / 420),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.person,
                size: width * (26 / 420),
                color: _currentIndex == 2
                    ? _colorfromhex("#3846A9")
                    : _colorfromhex("#ABAFD1"),
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                  fontFamily: 'Roboto Medium',
                  fontSize: width * (12 / 420),
                  color: _currentIndex == 2
                      ? _colorfromhex("#3846A9")
                      : _colorfromhex("#ABAFD1"),
                ),
              ),
            ),
          ],
        ),
        body: _children[_currentIndex],
      ),
    );
  }
}
