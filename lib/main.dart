import 'package:capstone/admin/admin_navbar.dart';
import 'package:flutter/material.dart';
import 'package:capstone/farmer/farmer_nav.dart';

main() async {
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                      fontSize: 28,
                      fontFamily: 'Averta-Regular',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 113, 83)),
                ),
                SizedBox(height: 30),
                Text(
                  '                   Let’s help farmers! \nDirect link between farmers and consumers.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
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
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  child: Text('More'),
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

class SignInAs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
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
                    height: 100,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  "Sign in as",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 85, 113, 83),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  "Select your account type",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(39, 174, 96, 1),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginBuyer()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFFA9AF7E),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                  child: Text(
                    'BUYER',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginFarmer()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFFA9AF7E),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                  child: Text(
                    'FARMER',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminLogin()));
                },
                child: Text("Login as Admin",
                    style: TextStyle(
                        color: Color.fromARGB(
                      255,
                      85,
                      113,
                      83,
                    ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginBuyer extends StatelessWidget {
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
                    )),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    "Login as Buyer",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 113, 83)),
                  )),
              TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.people),
                    labelText: "E-mail",
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.green),
                        borderRadius: BorderRadius.circular(15))),
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
                        borderSide:
                            const BorderSide(width: 3, color: Colors.green),
                        borderRadius: BorderRadius.circular(15))),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF27AE60),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(color: Color(0xFF27AE60)),
                  )),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminLogin()));
                },
                child: Text("Login as Admin",
                    style: TextStyle(
                        color: Color.fromARGB(
                      255,
                      85,
                      113,
                      83,
                    ))),
              ),
            ]),
      ),
    );
  }
}

class LoginFarmer extends StatelessWidget {
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
                    )),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    "Login as Farmer",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 113, 83)),
                  )),
              TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.people),
                    labelText: "E-mail",
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.green),
                        borderRadius: BorderRadius.circular(15))),
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
                        borderSide:
                            const BorderSide(width: 3, color: Colors.green),
                        borderRadius: BorderRadius.circular(15))),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BottomNavBar()));
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF27AE60),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(color: Color(0xFF27AE60)),
                  )),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminLogin()));
                },
                child: Text("Login as Admin",
                    style: TextStyle(
                        color: Color.fromARGB(
                      255,
                      85,
                      113,
                      83,
                    ))),
              ),
            ]),
      ),
    );
  }
}

class AdminLogin extends StatelessWidget {
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
                    height: 100,
                    width: 300,
                    child: Image.asset('assets/logo.png'),
                  )),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  "Login as Admin",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 113, 83)),
                )),
            TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.people),
                  labelText: "E-mail",
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15))),
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
                      borderSide:
                          const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminNavBar()));
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF27AE60),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInAs()));
                },
                child: Text(
                  "Not Admin?",
                  style: TextStyle(color: Color(0xFF27AE60)),
                )),
          ],
        ),
      ),
    );
  }
}

class Register extends StatelessWidget {
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
                    height: 100,
                    child: Image.asset('assets/logo.png'),
                  )),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  "Let's get started!",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 113, 83)),
                )),
            TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Full Name",
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "E-mail",
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(height: 15),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.arrow_drop_down),
                    labelText: "Roles",
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "Farmer",
                      child: Text("Farmer"),
                    ),
                    DropdownMenuItem(
                      value: "Buyer",
                      child: Text("Buyer"),
                    ),
                  ],
                  onChanged: (value) {
                    // Handle the selected value
                  },
                ),
              ],
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
                      borderSide:
                          const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: Text('Register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF27AE60),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInAs()));
              },
              child: Text("Already have an account? Login",
                  style: TextStyle(
                      color: Color.fromARGB(
                    255,
                    85,
                    113,
                    83,
                  ))),
            )
          ],
        ),
      ),
    );
  }
}
