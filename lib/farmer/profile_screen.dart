import 'dart:io';

import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'about_us.dart';
import 'contact_us.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String imageUrl = '';

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bdateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('Users');

  bool _isEditing = false;
  DateTime? _selectedDate;

  XFile? file;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future UimgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future UimgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  final currentUser = FirebaseAuth.instance;
  AuthService authService = AuthService();
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("uid", isEqualTo: currentUser.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          var data = snapshot.data!.docs[i];
                          return UserAccountsDrawerHeader(
                            accountName: Text(data['fullname']),
                            accountEmail: Text(data['email']),
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
                          );
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUsScreen(),
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
                    builder: (context) => ContactUsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                AuthService authService = AuthService();
                authService.logOutUser(context);
              },
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
                controller: _fullnameController,
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
                controller: _passwordController,
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
                controller: _contactController,
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
                            setState(() {
                              _isEditing = false;
                            });
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
                            setState(() {
                              _isEditing = false;
                            });
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
                        setState(() {
                          _isEditing = true;
                        });
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
