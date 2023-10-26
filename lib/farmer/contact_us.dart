import 'package:capstone/farmer/profile_screen.dart';
import 'package:flutter/material.dart';
import 'contact_us.dart';
import 'farmer_nav.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Image.asset(
                'assets/contact.png',
                width: 900,
                height: 200,
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Get in touch!',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text(
                  'Office Location',
                  style: TextStyle(fontFamily: "Poppins"),
                ),
                subtitle: Text(
                  '551 M.F. Jhocson St, Sampaloc, Manila, 1008 Metro Manila',
                  style: TextStyle(fontFamily: "Poppins-Regular"),
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  'Telephone Number',
                  style: TextStyle(fontFamily: "Poppins"),
                ),
                subtitle: Text(
                  '(02) 8712 1922',
                  style: TextStyle(fontFamily: "Poppins-Regular"),
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  'Email',
                  style: TextStyle(fontFamily: "Poppins"),
                ),
                subtitle: Text(
                  'agripinas@gmail.com',
                  style: TextStyle(fontFamily: "Poppins-Regular"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
