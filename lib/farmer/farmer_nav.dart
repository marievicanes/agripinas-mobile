import 'package:capstone/farmer/marketplace_screen.dart';
import 'package:capstone/farmer/profile_screen.dart';
import 'package:capstone/farmer/crop_tracker_screen.dart';
import 'package:capstone/farmer/community_forum_screen.dart';
import 'package:capstone/farmer/transactions_screen.dart';
import 'package:capstone/farmer/profile_wall.dart';
import 'package:capstone/farmer/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    DashboardScreen(),
    MarketplaceScreen(),
    CommunityForumScreen(),
    ProfileWall(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.dashboard_customize),
          Icon(Icons.shopping_cart_outlined),
          Icon(Icons.forum_outlined),
          Icon(Icons.person_outline),
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
