import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'buyer/buyer_nav.dart';
import 'farmer/farmer_nav.dart';
import 'main.dart';

class AuthHelper {
  static Future<UserCredential> loginUser(String email, String password) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  static Future<DocumentSnapshot> getUserDocument(String uid) async {
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userSnapshot = userQuerySnapshot.docs[0];
      return userSnapshot;
    } else {
      throw Exception('User document not found');
    }
  }
}

class AuthService {
  final auth = FirebaseAuth.instance;

  TextEditingController fullname = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController birthdate = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  TextEditingController adminemail = TextEditingController();
  TextEditingController adminpassword = TextEditingController();

  final firestore = FirebaseFirestore.instance;

  void loginBuyer(context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: CircularProgressIndicator(),
              ),
            );
          });
      await auth
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) => {
                print("Buyer is Logged In"),
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BuyerNavBar()),
                    (route) => false),
              });
    } catch (e) {
      print(e);
    }
  }

  void loginFarmer(context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: CircularProgressIndicator(),
              ),
            );
          });
      await auth
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) => {
                print("Farmer is Logged In"),
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavBar()),
                    (route) => false),
              });
    } catch (e) {
      print(e);
    }
  }

  void Register(context) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );

      await auth
          .createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      )
          .then((value) {
        print("User is Registered");
        firestore.collection("Users").add({
          "email": email.text,
          "fullname": fullname.text,
          "contact": contact.text,
          "address": address.text,
          "age": age.text,
          "birthdate": birthdate.text,
          "role": role.text,
          "uid": auth.currentUser!.uid,
        });

        // Close the loading dialog
        Navigator.pop(context);

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Registration Successful"),
              content: Text("You have successfully registered."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => Login()));
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }).catchError((e) {
        // Close the loading dialog
        Navigator.pop(context);

        // Check if the error is due to an existing email
        if (e.code == 'email-already-in-use') {
          // Show email already exists dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Registration Failed"),
                content: Text("Error: Email already exists."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          // Show generic error dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Registration Failed"),
                content: Text("Error: $e"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      // Show generic error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Registration Failed"),
            content: Text("Error: $e"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      print(e);
    }
  }

  void logOutUser(context) async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (C) => Login()), (route) => false);
  }
}
