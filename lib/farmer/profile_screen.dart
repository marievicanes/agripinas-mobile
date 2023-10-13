import 'dart:io';

import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String imageUrl = '';
  String? _imageUrl;

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController password = TextEditingController();

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

    firebase_storage.Reference referenceRoot =
        firebase_storage.FirebaseStorage.instance.ref();
    firebase_storage.Reference referenceDirImages =
        referenceRoot.child('images');

    firebase_storage.Reference referenceImageToUpload =
        referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  Future<void> _updateName([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _fullnameController.text = documentSnapshot['fullname'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _fullnameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromRGBO(157, 192, 139, 1), // Background color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Update'),
                  onPressed: () async {
                    final String fullname = _fullnameController.text;
                    if (fullname != null) {
                      await _users
                          .doc(documentSnapshot!.id)
                          .update({"fullname": fullname});
                      _fullnameController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _updateBirthdate([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _birthdateController.text = documentSnapshot['birthdate'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _birthdateController,
                  decoration: const InputDecoration(labelText: 'Birthdate'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromRGBO(157, 192, 139, 1), // Background color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Update'),
                  onPressed: () async {
                    final String birthdate = _birthdateController.text;
                    if (birthdate != null) {
                      await _users
                          .doc(documentSnapshot!.id)
                          .update({"birthdate": birthdate});
                      _birthdateController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _updateAddress([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _addressController.text = documentSnapshot['address'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromRGBO(157, 192, 139, 1), // Background color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Update'),
                  onPressed: () async {
                    final String address = _addressController.text;
                    if (address != null) {
                      await _users
                          .doc(documentSnapshot!.id)
                          .update({"address": address});
                      _addressController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _updateContact([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _contactController.text = documentSnapshot['contact'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _contactController,
                  decoration:
                      const InputDecoration(labelText: 'Contact Number'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromRGBO(157, 192, 139, 1), // Background color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Update'),
                  onPressed: () async {
                    final String contact = _contactController.text;
                    if (contact != null) {
                      await _users
                          .doc(documentSnapshot!.id)
                          .update({"contact": contact});
                      _contactController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
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
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where("uid", isEqualTo: currentUser.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator while fetching data.
          }

          if (!snapshot.hasData) {
            return Text("No data available."); // Handle when there's no data.
          }

          var data = snapshot.data!.docs[0];
          DocumentSnapshot documentSnapshot = snapshot.data!.docs[0];

          _fullnameController.text = data['fullname'];
          _emailController.text = data['email'];
          _birthdateController.text = data['birthdate'];
          _addressController.text = data['address'];
          _contactController.text = data['contact'];
          password.text = "password";

          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                Text('Account Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins-Bold',
                    )),
                SizedBox(height: 16.0),
                TextField(
                  controller: _fullnameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        iconSize: 18, // You can use any icon you prefer
                        onPressed: () => _updateName(documentSnapshot)),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _birthdateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        iconSize: 18, // You can use any icon you prefer
                        onPressed: () => _updateBirthdate(documentSnapshot)),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _addressController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        iconSize: 18, // You can use any icon you prefer
                        onPressed: () => _updateAddress(documentSnapshot)),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _contactController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        iconSize: 18, // You can use any icon you prefer
                        onPressed: () => _updateContact(documentSnapshot)),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    suffixIcon: IconButton(
                      icon: Icon(Icons
                          .arrow_forward_ios), // You can use any icon you prefer
                      onPressed: () {
                        // Handle the button press event here
                      },
                      iconSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: password,
                  obscureText: true,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(Icons
                          .arrow_forward_ios), // You can use any icon you prefer
                      onPressed: () {
                        // Handle the button press event here
                      },
                      iconSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveInformation() {}

  void _UshowPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        UimgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      UimgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Gallery'),
                  onTap: () {
                    imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
