import 'package:capstone/farmer/profile_screen.dart';
import 'package:flutter/material.dart';
import 'contact_us.dart';
import 'admin_navbar.dart';

class ContactUsScreen extends StatelessWidget {
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
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Text('Name'),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(height: 16.0),
              Text('Email'),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 16.0),
              Text('Subject'),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter the subject',
                ),
              ),
              SizedBox(height: 16.0),
              Text('Message'),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter your message',
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(157, 192, 139, 1),
                      onPrimary: Colors.white,
                    ),
                    child: Text('Send'),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text(
                  'Office Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '551 M.F. Jhocson St, Sampaloc, Manila, 1008 Metro Manila',
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  'Telephone Number',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('(02) 8712 1922'),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('agripinas@gmail.com'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
