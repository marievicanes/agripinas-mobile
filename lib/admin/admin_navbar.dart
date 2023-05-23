import 'package:capstone/admin/dashboard.dart';
import 'package:capstone/admin/profile_screen.dart';
import 'package:capstone/admin/transactions.dart';
import 'package:capstone/admin/forum_admin.dart';
import 'package:capstone/admin/accounts_management.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class AdminNavBar extends StatefulWidget {
  @override
  _AdminNavBarState createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    AdminDashboard(),
    AdminForum(),
    Transaction(),
    AccountsManagement(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.bar_chart_outlined),
          Icon(Icons.forum_outlined),
          Icon(Icons.money_outlined),
          Icon(Icons.manage_accounts_outlined),
          Icon(Icons.person_2_outlined),
        ],
        backgroundColor: Colors.white,
        color: Color(0xFFA9AF7E),
        buttonBackgroundColor: Color(0xFF557153),
        height: 50,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
