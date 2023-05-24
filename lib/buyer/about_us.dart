import 'package:capstone/farmer/profile_screen.dart';
import 'package:flutter/material.dart';
import 'contact_us.dart';
import 'buyer_nav.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 32.0,
            ),
            SizedBox(width: 7.0),
            Text(
              'AgriPinas',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Image.asset(
                'assets/about.png',
                width: 900,
                height: 300,
              ),
              SizedBox(height: 16.0),
              Text(
                'ABOUT US',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Farmers are at the center of our culture; they provide us with every single meal. As a result, farmers provide a means of subsistence for everyone in the country. No matter how small or large, it still counts. It is solely because of them that we may live on this world. In addition to a wealth of nutritious food, farmers also generate a wide range of valued commodities. Farmers protect the environment through maintaining healthy soil, preserving water supplies, and protecting animals. In the community, farmers have a big part to play. Despite their huge importance, farmers still do not have a decent way of life. As a result, researchers will develop a market and management system that will allow farmers to post their crop online, making it simple for anyone to buy it.  ',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}