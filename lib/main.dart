import 'package:capstone/admin/admin_navbar.dart';
import 'package:flutter/material.dart';
import 'package:capstone/farmer/farmer_nav.dart';
import 'package:capstone/buyer/buyer_nav.dart';
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
                  'Fresh from the farm,\ndelivered to your door.',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 85, 113, 83),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.people),
                labelText: "E-mail",
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.green),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.password),
                labelText: "Password",
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.green),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavBar()),
                    );
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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      color: Color(0xFF27AE60),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _birthDateController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
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
                TextField(
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
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
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
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                        : "",
                  ),
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
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
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
                        "Farmer",
                        style: TextStyle(fontFamily: 'Poppins-Regular'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Buyer",
                      child: Text(
                        "Buyer",
                        style: TextStyle(fontFamily: 'Poppins-Regular'),
                      ),
                    ),
                  ],
                  onChanged: (value) {},
                ),
                SizedBox(height: 15),
                TextField(
                  obscureText: true,
                  maxLength: 16,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
                      color: Color(0xFF9DC08B),
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins-Regular',
                      fontSize: 14,
                    ),
                    helperText:
                        "Use a strong password with 16 characters, uppercase, lowercase, number, and symbol",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) {
                    bool isValid = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9!#%]).{16}$',
                    ).hasMatch(value);
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
                      color: Color(0xFF9DC08B),
                    ),
                    labelText: "Confirm Password",
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
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {},
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
        ));
  }
}
