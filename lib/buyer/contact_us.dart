import 'package:capstone/farmer/profile_screen.dart';
import 'package:flutter/material.dart';
import 'contact_us.dart';
import 'buyer_nav.dart';

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
                  'GET IN TOUCH!',
                  style: TextStyle(fontSize: 24.0, fontFamily: 'Poppins-Bold'),
                ),
              ),
              SizedBox(height: 24.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins-Regular',
                    fontSize: 14,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins-Regular',
                    fontSize: 14,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Subject',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins-Regular',
                    fontSize: 14,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins-Regular',
                    fontSize: 14,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                  ),
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
                    child: Text(
                      'Send',
                      style: TextStyle(fontFamily: 'Poppins-Regular'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text(
                  'Office Location',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                subtitle: Text(
                  '551 M.F. Jhocson St, Sampaloc, Manila, 1008 Metro Manila',
                  style: TextStyle(fontFamily: 'Poppins-Regular'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  'Telephone Number',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                subtitle: Text(
                  '(02) 8712 1922',
                  style: TextStyle(fontFamily: 'Poppins-Regular'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  'Email',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                subtitle: Text(
                  'agripinas@gmail.com',
                  style: TextStyle(fontFamily: 'Poppins-Regular'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
