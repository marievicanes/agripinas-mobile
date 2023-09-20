import 'package:capstone/buyer/buyer_categories.dart';
import 'package:capstone/buyer/add_to_cart.dart';
import 'package:capstone/buyer/community_forum_screen.dart';
import 'package:capstone/buyer/transactions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class BuyerNavBar extends StatefulWidget {
  @override
  _BuyerNavBarState createState() => _BuyerNavBarState();
}

class _BuyerNavBarState extends State<BuyerNavBar> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    BuyerCategoriesScreen(),
    AddToCart(),
    CommunityForumScreen(),
    TransactionBuyer(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.shopping_bag_outlined),
          Icon(Icons.shopping_cart_checkout_outlined),
          Icon(Icons.forum_outlined),
          Icon(Icons.person_outlined),
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
