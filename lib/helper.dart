import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin/admin_navbar.dart';
import 'buyer/buyer_nav.dart';
import 'farmer/farmer_nav.dart';
import 'main.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  TextEditingController fullname = TextEditingController();
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

  void adminlogin(context) async {
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
      await FirebaseFirestore.instance
          .collection("admin")
          .doc("adminLogin")
          .snapshots()
          .forEach((element) {
        if (element.data()?['adminEmail'] == adminemail.text &&
            element.data()?['adminPassword'] == adminpassword.text) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AdminNavBar()),
              (route) => false);
        }
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
          });
      await auth
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) {
        print("User is Registered");
        firestore.collection("Users").add({
          "email": email.text,
          "fullname": fullname.text,
          "role": role.text,
          "uid": auth.currentUser!.uid
        });
        Navigator.push(context, MaterialPageRoute(builder: (c) => Login()));
      });
    } catch (e) {
      print(e);
    }
  }

  void logOutUser(context) async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (C) => WelcomePage()), (route) => false);
  }
}
