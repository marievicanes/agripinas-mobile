import 'package:capstone/buyer/about_us.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'contact_us.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bdateController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool _isEditing = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        centerTitle: true,
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Arriane Gatpo'),
              accountEmail: Text('ag@gatpo.com'),
              currentAccountPicture: CircleAvatar(
                radius: 14.0,
                backgroundImage: AssetImage('assets/user.png'),
              ),
              decoration: BoxDecoration(
                color: Color(0xFFA9AF7E),
              ),
              otherAccountsPictures: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {},
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuyerAboutUsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuyerContactUsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage('assets/user.png'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _bdateController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Birth Date',
                  hintText: 'Enter your birthdate',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  if (_isEditing) {
                    _selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    _bdateController.text =
                        DateFormat('MM/dd/yyyy').format(_selectedDate!);
                  }
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter your Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              _isEditing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            _isEditing = false;
                          },
                          child: Text('Cancel'),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF9DC08B)),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                color: Color(0xFF9DC08B),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _isEditing = false;
                            _saveInformation();
                          },
                          child: Text('Save'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF9DC08B)),
                          ),
                        ),
                      ],
                    )
                  : MaterialButton(
                      onPressed: () {
                        _isEditing = true;
                      },
                      child: Text('Edit Information'),
                      color: Color.fromRGBO(157, 192, 139, 1),
                      textColor: Colors.white,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveInformation() {}
}
