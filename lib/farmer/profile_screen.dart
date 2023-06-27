import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  DateTime? birthdate;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _dateFormat = DateFormat('yyyy-MM-dd');
  int age = 0;

  @override
  void initState() {
    super.initState();
    nameController.text = "Arriane Gatpo";
    contactNumberController.text = "09675046713";
    addressController.text = "Cabiao, Nueva Ecija";
    birthdate = DateTime(1999, 7, 15);
    emailController.text = "acg@gmail.com";
    passwordController.text = "password";
    _calculateAge();
  }

  @override
  void dispose() {
    nameController.dispose();
    contactNumberController.dispose();
    addressController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _calculateAge() {
    if (birthdate != null) {
      final now = DateTime.now();
      age = now.year - birthdate!.year;
      if (now.month < birthdate!.month ||
          (now.month == birthdate!.month && now.day < birthdate!.day)) {
        age--;
      }
    }
  }

  bool _validateFields() {
    if (nameController.text.isEmpty ||
        contactNumberController.text.isEmpty ||
        addressController.text.isEmpty ||
        birthdate == null ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return false; // Return false if any of the fields are empty
    }

    // Add any additional field validation logic here

    return true; // Return true if all fields are valid
  }

  void _saveProfile() {
    // Implement the logic to save the profile data
    // You can access the values of the text controllers here
    // For example:
    String name = nameController.text;
    String contactNumber = contactNumberController.text;
    String address = addressController.text;
    DateTime? selectedBirthdate = birthdate;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Perform the saving logic here
    // For demonstration purposes, print the values
    print('Name: $name');
    print('Contact Number: $contactNumber');
    print('Address: $address');
    print('Birthdate: $selectedBirthdate');
    print('Email: $email');
    print('Password: $password');
    print('Confirm Password: $confirmPassword');
  }

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
      body: Padding(
        key: Key('padding'),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/user.png'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit Profile'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                              ),
                            ),
                            TextField(
                              controller: contactNumberController,
                              decoration: InputDecoration(
                                labelText: 'Contact Number',
                              ),
                            ),
                            TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                labelText: 'Address',
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: _dateFormat
                                    .format(birthdate ?? DateTime.now()),
                              ),
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: birthdate ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                ).then((selectedDate) {
                                  setState(() {
                                    if (selectedDate != null) {
                                      birthdate = selectedDate;
                                      _calculateAge();
                                    }
                                  });
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Birthdate',
                              ),
                            ),
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: age.toString(),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Age',
                              ),
                            ),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                            ),
                            TextField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                              ),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (_validateFields()) {
                              _saveProfile();
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'Please fill all the fields correctly.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text('Save'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: Color(0xFF9DC08B),
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: nameController,
              readOnly: true,
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
              ),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ),
            TextField(
              controller: contactNumberController,
              readOnly: true,
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
              ),
              decoration: InputDecoration(
                labelText: 'Contact Number',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ),
            TextField(
              controller: addressController,
              readOnly: true,
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
              ),
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: _dateFormat.format(birthdate ?? DateTime.now()),
              ),
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: birthdate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ).then((selectedDate) {
                  setState(() {
                    if (selectedDate != null) {
                      birthdate = selectedDate;
                      _calculateAge();
                    }
                  });
                });
              },
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
              ),
              decoration: InputDecoration(
                labelText: 'Birthdate',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: age.toString(),
              ),
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
              ),
              decoration: InputDecoration(
                labelText: 'Age',
              ),
            ),
            TextField(
              controller: emailController,
              readOnly: true,
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
              ),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ),
            TextField(
              controller: passwordController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                ),
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
