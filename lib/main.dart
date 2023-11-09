import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fil', 'PH')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: SplashScreen(), // Use SplashScreen as the initial screen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WelcomePage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned(
        left: 0,
        right: 0,
        top: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 70,
              height: 50,
            ),
            Text(
              'AgriPinas',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Poppins",
                color: Color.fromARGB(255, 85, 113, 83),
              ),
            ),
            Spacer(),
            PopupMenuButton<String>(
              onSelected: (value) {
                context.locale =
                    value == 'en' ? Locale('en', 'US') : Locale('fil', 'PH');
              },
              icon: Icon(
                Icons.public,
                size: 30,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'en',
                  child: ListTile(
                    title: Text(
                      'English',
                      style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'fil',
                  child: ListTile(
                    title: Text('Filipino',
                        style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 16,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Grown with care,\ntraded with trust.',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 85, 113, 83),
              ),
            ),
            SizedBox(height: 30),
            Text(
              '                           Let’s help farmers! \n     Direct link between farmers and consumers.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-Medium',
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 80),
            Image.asset(
              'assets/welcomegrass.png',
              width: 900,
              height: 200,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text(
                "homeComponentText4".tr(),
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF27AE60),
              ),
            ),
          ],
        ),
      )
    ]));
  }
}

void login() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fil', 'PH')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Login(),
    );
  }
}

class Login extends StatelessWidget {
  final currentUser = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email.';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    if (value.length < 8) {
      return 'Password must have at least 8 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Form(
                key: _formkey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                        child: Column(
                          children: [
                            Hero(
                              tag: 'hero',
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: Image.asset('assets/logo.png'),
                              ),
                            ),
                            SizedBox(height: 0),
                            Text(
                              "AgriPinas",
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Poppins',
                                letterSpacing: 8,
                                color: Color.fromARGB(255, 85, 113, 83),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          "Signin".tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            color: Color.fromARGB(255, 85, 113, 83),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: authService.email,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xFF9DC08B),
                          ),
                          labelText: "E-mail",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins-Regular',
                            fontSize: 13,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 208, 216, 144),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        controller: authService.password,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF9DC08B),
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins-Regular',
                            fontSize: 14,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            try {
                              UserCredential userCredential =
                                  await AuthHelper.loginUser(
                                      authService.email.text,
                                      authService.password.text);
                              String uid = userCredential.user!.uid;

                              DocumentSnapshot userSnapshot =
                                  await AuthHelper.getUserDocument(uid);
                              String role = userSnapshot.get('role');

                              if (role == "Farmer") {
                                authService.loginFarmer(context);
                              } else if (role == "Buyer") {
                                authService.loginBuyer(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Invalid Role'),
                                      content: Text(
                                          'The role of the user is invalid.'),
                                      actions: [
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              // Handle login errors here
                              String errorMessage =
                                  'An error occurred during login. Please try again.';

                              if (e is FirebaseAuthException) {
                                if (e.code == 'user-not-found') {
                                  errorMessage =
                                      'Incorrect email. Please try again.';
                                } else if (e.code == 'wrong-password') {
                                  errorMessage =
                                      'Incorrect password. Please try again.';
                                } else if (e.code == 'wrong-password' &&
                                    e.code == 'user-not-found') {
                                  errorMessage =
                                      'Incorrect email and password. Please try again.';
                                }
                              }
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Login Failed',
                                      style: TextStyle(fontFamily: "Poppins"),
                                    ),
                                    content: Text(errorMessage),
                                    actions: [
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: Text("text25".tr()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF27AE60),
                          textStyle: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()),
                          );
                        },
                        child: Text(
                          "ForgotPassword".tr(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF9DC08B),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "text26".tr(),
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "text27".tr(),
                                style: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  color: Color(0xFF27AE60),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]))));
  }
}

void fpassword() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fil', 'PH')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: ForgotPw(),
    ),
  );
}

class ForgotPw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: ForgotPassword(),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email.';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  Future<void> _sendResetCode(BuildContext context) async {
    final email = _emailController.text.trim();

    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Password reset email sent successfully.'),
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
      } catch (e) {
        print("Error sending password reset email: $e");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Failed to send password reset email. Please try again.'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      SizedBox(height: 190.0),
                      IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        "userForgotPassword1".tr(),
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 85, 113, 83),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text(
                  "userForgotPassword".tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins-Medium',
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 80),
                Image.asset(
                  'assets/forgotpw.png',
                  width: 900,
                  height: 250,
                ),
                SizedBox(height: 10),
                Container(
                  width: 350,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "E-mail",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 216, 144),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: _validateEmail,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => _sendResetCode(context),
                    child: Text(
                      "userSendCode".tr(),
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      primary: Color(0xFF27AE60),
                      minimumSize: Size(5, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VerifyEmail extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _codeNumber;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email.';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      SizedBox(height: 190.0),
                      IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Confirm your account',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 85, 113, 83),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '   We sent a code to your email. Please enter the \n           digit code sent to confirm your account',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins-Medium',
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 40),
                Image.asset(
                  'assets/email.png',
                  width: 700,
                  height: 150,
                ),
                SizedBox(height: 40),
                Container(
                  width: 350,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Enter Code",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-Regular',
                        fontSize: 13,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 208, 216, 144),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your contact number';
                      } else if (value.length != 11) {
                        return 'Contact number must be exactly 11 digits';
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.phone,
                    onSaved: (value) {
                      _codeNumber = value;
                    },
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF9DC08B),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewPassword()));
                    },
                    child: Text(
                      'Verify',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      primary: Color(0xFF27AE60),
                      minimumSize: Size(5, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _confirmPassword;
  String? _password;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email.';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[a-zA-Z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      SizedBox(height: 150.0),
                      IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Create new password',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 85, 113, 83),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your new password must be different\n   from previously used password',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins-Medium',
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 80),
                Image.asset(
                  'assets/cnpassword.png',
                  width: 500,
                  height: 250,
                ),
                Container(
                  width: 350,
                  child: Column(
                    children: [
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF9DC08B),
                          ),
                          labelText: "New Password",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins-Regular',
                            fontSize: 13,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 208, 216, 144),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!_isPasswordValid(value)) {
                            return 'Password must be at least 8 characters long and contain a combination of letters, numbers, and symbols';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value;
                        },
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Password must be at least 8 characters long and contain a combination of letters, numbers, and symbols',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF9DC08B),
                          ),
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins-Regular',
                            fontSize: 13,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 208, 216, 144),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _confirmPassword = value;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Save',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      primary: Color(0xFF27AE60),
                      minimumSize: Size(5, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void register() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fil', 'PH')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class RegisterTrans extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

bool _isChecked = false;
String? _contactNumber;

class _RegisterState extends State<Register> {
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String _password = '';
  String _confirmPassword = '';
  bool _passwordsMatch = true;

  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[a-zA-Z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1955),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        authService.birthdate.text =
            "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
        authService.age.text = _calculateAge(_selectedDate).toString();
      });
    }
  }

  String _calculateAge(DateTime? birthdate) {
    if (birthdate == null) return '';
    final now = DateTime.now();
    final age = now.year - birthdate.year;
    return age.toString();
  }

  @override
  void dispose() {
    authService.birthdate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                      child: Hero(
                        tag: 'hero',
                        child: SizedBox(
                          height: 100,
                          child: Image.asset('assets/logo.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Text(
                        "Started".tr(),
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 113, 121, 112),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: authService.fullname,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "registerComponentText2".tr(),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 216, 144),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: authService.contact,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "Contact Number",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 216, 144),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (value) {},
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        } else if (value.length != 11) {
                          return 'Contact number must be exactly 11 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: authService.address,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.house,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "registerComponentText4".tr(),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 216, 144),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      controller: authService.birthdate,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "farmerProfileText14".tr(),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 216, 144),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your birth date';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      enabled: false,
                      controller: authService.age,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.hourglass_bottom_outlined,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "text32".tr(),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 216, 144),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: authService.email,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "E-mail",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 216, 144),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 85, 113, 83),
                        ),
                        labelText: "Roles",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 14,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 216, 144),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "Farmer",
                          child: Text(
                            "registerRoleFarmer".tr(),
                            style: TextStyle(fontFamily: 'Poppins-Regular'),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Buyer",
                          child: Text(
                            "registerRoleBuyer".tr(),
                            style: TextStyle(fontFamily: 'Poppins-Regular'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        authService.role.text = value as String;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a role';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      controller: authService.password,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 216, 144),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        } else if (!RegExp(
                                r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$%\^&\*])')
                            .hasMatch(value)) {
                          return 'Password must contain at least one lowercase letter, one uppercase letter, one number, and one special character';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    Text(
                      "registerPasswordCharacters".tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      controller: authService.confirmpassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "registerComponentText9".tr(),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 216, 144),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != authService.password.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "registerClickingRegister".tr(),
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Terms and Condition",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color:
                                              Color.fromARGB(255, 85, 113, 83),
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Welcome to the AgriPinas! These terms and conditions outline the rules and regulations for the use of our mobile application.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Regular',
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "By accessing this app, we assume you accept these terms and conditions. Do not continue to use the AgriApp if you do not agree to all of the terms and conditions stated on this page.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Regular',
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "The following terminology applies to these Terms and Conditions, Privacy Statement, and Disclaimer Notice and all Agreements: 'Client', 'You' and 'Your' refer to you, the person log in to this app and compliant to the Company’s terms and conditions. 'The Company', 'Ourselves', 'We', 'Our' and 'Us', refer to our Company. 'Party', 'Parties', or 'Us', refers to both the Client and ourselves.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Regular',
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "1. INTELLECTUAL PROPERTY RIGHTS",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "Unless otherwise indicated, we retain all right, title, and interest in and to the Software and the Website, including without limitation all graphics, user interfaces, databases, functionality, software, website designs, audio, video, text, photographs, graphics, logos, and trademarks or service marks reproduced through the System. These Terms of Use do not grant you any intellectual property license or rights in or to the Software and the Website or any of its components, except to the limited extent that these Terms of Use specifically sets forth your license rights to it. You recognize that the Software and the Website and their components are protected by copyright and other laws.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Regular',
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "2. USER REPRESENTATIONS",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "By using the AgriPinas, you represent and warrant that: (1) all registration information you submit will be true, accurate, current, and complete; (2) you will maintain the accuracy of such information and promptly update such registration information as necessary; (3) you have the legal capacity and you agree to comply with these Terms of Use; (4) you are not a minor in the jurisdiction in which you reside; (5) you will not access the AgriPinas through automated or non-human means, whether through a bot, script or otherwise; (6) you will not use the Services for any illegal or unauthorized purpose; and (7) your use of the AgriPinas will not violate any applicable law or regulation.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Regular',
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "3. USER REGISTRATION",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "You may be required to register with the Services. You agree to keep your password confidential and will be responsible for all use of your account and password. We reserve the right to remove, reclaim, or change a username you select if we determine, in our sole discretion, that such username is inappropriate, obscene, or otherwise objectionable.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Regular',
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "4. PRIVACY NOTICE",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "This Privacy Notice applies to personal information we collect and process on all AgriPinas forms, website and online services. Personal information refers to any information, whether recorded in material form or not, that will directly ascertain your identity. This includes your address and contact information. Sensitive personal information is personal information that includes your age, date of birth, email, password, and name.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Regular',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text(
                        "registerTermsCondi".tr(),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 85, 113, 83),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form!.validate()) {
                          form.save();
                        }

                        authService.Register(context);
                      },
                      child: Text(
                        "rehisteroComponentText1".tr(),
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF27AE60),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
