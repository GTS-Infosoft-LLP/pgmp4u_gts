import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/Dashboard/DashboardScreen.dart';
import 'package:pgmp4u/Screens/Profile/profile.dart';
import 'package:pgmp4u/Screens/Tests/testsScreen.dart';

import '../test.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final List<Widget> _children = [DashboardScreen(), TestsScreen(), Profile()];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
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
              'Mock Test',
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
    );
  }
}
