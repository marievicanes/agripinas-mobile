import 'package:capstone/farmer/farmer_nav.dart';
import 'package:flutter/material.dart';
import 'package:capstone/buyer/buyer_nav.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() async {
  runApp(MaterialApp(
    home: WelcomePage(),
  ));
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 70,
                  height: 200,
                ),
                Text(
                  'AgriPinas',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: Color.fromARGB(255, 85, 113, 83),
                  ),
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
                  '     Let’s help farmers! \n     Direct link between farmers and consumers.',
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
                    'More',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF27AE60),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                child: Hero(
                  tag: 'hero',
                  child: SizedBox(
                    height: 250,
                    width: 300,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  "AgriPinas",
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    color: Color.fromARGB(255, 85, 113, 83),
                  ),
                ),
              ),
              TextFormField(
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
              SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
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
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavBar()),
                        );
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF27AE60),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
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
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Register",
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              color: Color(0xFF27AE60),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Colors.transparent, // Set the background color to transparent
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Row(
              children: [
                BackButton(color: Colors.black), // Back button
                SizedBox(width: 10.0),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 0),
                Text(
                  'Forgot your password?',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    color: Color.fromARGB(255, 85, 113, 83),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  '   Enter your registered email below \n to receive password reset instruction ',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins-Medium',
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 80),
                Image.asset(
                  'assets/email.png',
                  width: 700,
                  height: 150,
                ),
                SizedBox(height: 40),
                Container(
                  width: 350,
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
                SizedBox(height: 10),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Send Code',
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

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isChecked = false;
  String? _selectedRole;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  DateTime? _selectedDate;
  String? _fullName;
  String? _contactNumber;
  String? _address;
  String? _age;
  String? _email;
  String? _password;
  String? _confirmPassword;
  String? _role;
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
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _birthDateController.text =
            "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
        _ageController.text = _calculateAge(_selectedDate).toString();
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
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                        "Let's get started!",
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 85, 113, 83),
                        ),
                      ),
                    ),
                    TextFormField(
                      //binago ko to arr
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "Full Name",
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _fullName = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      //binago ko rin to
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
                        _contactNumber = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.house,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "Address",
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
                      onSaved: (value) {
                        _address = value;
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
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "Birth Date",
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
                      controller: _birthDateController,
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
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.hourglass_bottom_outlined,
                          color: Color(0xFF9DC08B),
                        ),
                        labelText: "Age",
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
                      controller: _ageController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
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
                        if (!RegExp(
                                r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _email = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: true,
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
                    SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<String>(
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
                      value: _selectedRole,
                      items: [
                        DropdownMenuItem<String>(
                          value: "farmer",
                          child: Text(
                            "Farmer",
                            style: TextStyle(fontFamily: 'Poppins-Regular'),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: "buyer",
                          child: Text(
                            "Buyer",
                            style: TextStyle(fontFamily: 'Poppins-Regular'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a role';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "By clicking Register, you are agreeing to AgriPinas'",
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
                                      Text("Terms and Conditions"),
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
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "By accessing this app, we assume you accept these terms and conditions. Do not continue to use the AgriApp if you do not agree to all of the terms and conditions stated on this page.",
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "The following terminology applies to these Terms and Conditions, Privacy Statement, and Disclaimer Notice and all Agreements: 'Client', 'You' and 'Your' refer to you, the person log in to this app and compliant to the Company’s terms and conditions. 'The Company', 'Ourselves', 'We', 'Our' and 'Us', refer to our Company. 'Party', 'Parties', or 'Us', refers to both the Client and ourselves.",
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "1. INTELLECTUAL PROPERTY RIGHTS",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Unless otherwise indicated, we retain all right, title, and interest in and to the Software and the Website, including without limitation all graphics, user interfaces, databases, functionality, software, website designs, audio, video, text, photographs, graphics, logos, and trademarks or service marks reproduced through the System. These Terms of Use do not grant you any intellectual property license or rights in or to the Software and the Website or any of its components, except to the limited extent that these Terms of Use specifically sets forth your license rights to it. You recognize that the Software and the Website and their components are protected by copyright and other laws.",
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "2. USER REPRESENTATIONS",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "By using the AgriPinas, you represent and warrant that: (1) all registration information you submit will be true, accurate, current, and complete; (2) you will maintain the accuracy of such information and promptly update such registration information as necessary; (3) you have the legal capacity and you agree to comply with these Terms of Use; (4) you are not a minor in the jurisdiction in which you reside; (5) you will not access the AgriPinas through automated or non-human means, whether through a bot, script or otherwise; (6) you will not use the Services for any illegal or unauthorized purpose; and (7) your use of the AgriPinas will not violate any applicable law or regulation.",
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "3. USER REGISTRATION",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "You may be required to register with the Services. You agree to keep your password confidential and will be responsible for all use of your account and password. We reserve the right to remove, reclaim, or change a username you select if we determine, in our sole discretion, that such username is inappropriate, obscene, or otherwise objectionable.",
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "4. PRIVACY NOTICE",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "This Privacy Notice applies to personal information we collect and process on all AgriPinas forms, website and online services. Personal information refers to any information, whether recorded in material form or not, that will directly ascertain your identity. This includes your address and contact information. Sensitive personal information is personal information that includes your age, date of birth, email, password, and name.",
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
                        "Terms and Conditions",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 85, 113, 83),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form!.validate()) {
                          form.save();
                        }
                      },
                      child: Text(
                        'Register',
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
