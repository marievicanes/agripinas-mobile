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
          .then((value) {
        if (auth.currentUser!.emailVerified) {
          print("Farmer is Logged In");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BuyerNavBar()),
            (route) => false,
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  '',
                  style: TextStyle(fontFamily: "Poppins", fontSize: 5),
                ),
                content: Text(
                  'Please verify your email before logging in.',
                  style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 15),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 17),
                    ),
                  ),
                ],
              );
            },
          );
        }
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
          .then((value) {
        if (auth.currentUser!.emailVerified) {
          // Check if email is verified
          print("Farmer is Logged In");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBar()),
            (route) => false,
          );
        } else {
          // If email is not verified, show an error dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  '',
                  style: TextStyle(fontFamily: "Poppins", fontSize: 5),
                ),
                content: Text(
                  'Please verify your email before logging in.',
                  style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 15),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 17),
                    ),
                  ),
                ],
              );
            },
          );
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
        },
      );

      if (password.text.trim() != confirmpassword.text.trim()) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                '',
                style: TextStyle(fontFamily: "Poppins", fontSize: 10),
              ),
              content: Text(
                'Password and Confirm Password do not match.',
                style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 17),
                  ),
                ),
              ],
            );
          },
        );

        return;
      }

      await auth
          .createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      )
          .then((value) async {
        print("User is Registered");

        // Save user details to Firestore
        await firestore.collection("Users").doc(auth.currentUser!.uid).set({
          "email": email.text,
          "fullname": fullname.text,
          "contact": contact.text,
          "address": address.text,
          "age": age.text,
          "birthdate": birthdate.text,
          "role": role.text,
          "uid": auth.currentUser!.uid,
        });

        // Send email verification
        await auth.currentUser!.sendEmailVerification();

        Navigator.pop(context); // Dismiss the loading dialog

        // Display a dialog informing the user to check their email for verification
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Account Registered',
                style: TextStyle(fontFamily: "Poppins", fontSize: 14),
              ),
              content: Text(
                'An email verification has been sent to ${auth.currentUser!.email}. Please verify your email before logging in.',
                style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => Login()),
                    );
                  },
                  child: Text(
                    'OK',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 17),
                  ),
                ),
              ],
            );
          },
        );
      });
    } catch (e) {
      Navigator.pop(context); // Dismiss the loading dialog

      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        // Display email already in use error dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                '',
                style: TextStyle(fontFamily: "Poppins", fontSize: 10),
              ),
              content: Text(
                'Email is already in use. Please use a different email.',
                style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 17),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 17),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        print(e);
      }
    }
  }

  void logOutUser(context) async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (C) => Login()), (route) => false);
  }
}
