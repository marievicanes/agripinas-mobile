import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'farmer/farmer_nav.dart';
import 'admin/admin_navbar.dart';
import 'main.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController adminemail = TextEditingController();
  TextEditingController adminpassword = TextEditingController();
  TextEditingController fullname = TextEditingController();

  final firestore = FirebaseFirestore.instance;
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

  void RegisterFarmer(context) async {
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
        firestore.collection("user").add({
          "email": email.text,
          "fullname": fullname.text,
          "uid": auth.currentUser!.uid
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginFarmer()));
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
