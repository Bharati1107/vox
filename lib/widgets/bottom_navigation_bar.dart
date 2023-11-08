// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';

import '../main/home_page/homepage.dart';
import '../main/settings.dart';

import '../utils/constant.dart';

class BottomNavigationExample extends StatefulWidget {
  const BottomNavigationExample({
    super.key,
  });

  @override
  _BottomNavigationExampleState createState() =>
      _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State<BottomNavigationExample> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AppbarTop(),
    // const SearchPage(),
    // const SignInScreen(),
    const Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: orange,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.search,
          //   ),
          //   label: 'Search',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.cloud_download),
          //   label: 'cloud',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
