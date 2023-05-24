import 'package:capstone/admin/admin_navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'helper.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class Login extends StatelessWidget {
  AuthService authService = AuthService();
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
                    "Sign in",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 113, 83)),
                  )),
              TextField(
                controller: authService.email,
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
                controller: authService.password,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.green),
                        borderRadius: BorderRadius.circular(15))),
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
                      authService.role.text = value as String;
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (authService.email != "" && authService.password != "") {
                    authService.login(context);
                  }
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
  AuthService authService = AuthService();
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
              controller: authService.adminemail,
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
              controller: authService.adminpassword,
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
                      MaterialPageRoute(builder: (context) => Login()));
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
  AuthService authService = AuthService();
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
              controller: authService.fullname,
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
              controller: authService.email,
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
                    authService.role.text = value as String;
                  },
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              obscureText: true,
              controller: authService.password,
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
              controller: authService.password,
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
              onPressed: () {
                if (authService.email != "" && authService.password != "") {
                  authService.Register(context);
                }
              },
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
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
