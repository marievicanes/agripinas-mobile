import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        centerTitle: false,
        title: Row(
          children: [
            SizedBox(width: 8.0),
            Text(
              'About Us',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Poppins',
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
                style: TextStyle(fontSize: 24.0, fontFamily: "Poppins"),
              ),
              SizedBox(height: 16.0),
              Text(
                'AgriPinas is an innovative mobile and web application designed to revolutionize the agricultural industry, specifically aiming to assist farmers in Cabiao, Nueva Ecija, Philippines. \nThe region known as the Rice Granary of the Philippines is facing challenges such as low income and lack of support from the government.',
                style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
