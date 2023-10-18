import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final currentUser = FirebaseAuth.instance;
  AuthService authService = AuthService();

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController password = TextEditingController();

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');

  bool _isEditing = false;
  DateTime? _selectedDate;

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
                  decoration: const InputDecoration(labelText: 'Fullname'),
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
}
