import 'package:flutter/material.dart';
import 'dart:io';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        centerTitle: false,
        title: Row(
          children: [
            SizedBox(width: 8.0),
            Text(
              'Messages',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user.profile),
                  ),
                  title: Text(
                    user.name,
                    style:
                        TextStyle(fontFamily: 'Poppins-Medium', fontSize: 14.5),
                  ),
                  subtitle: Text(
                    user.message,
                    style: TextStyle(
                        fontFamily: 'Poppins-Regular', fontSize: 12.5),
                  ),
                  trailing: Text(user.time),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatAgriScreen(
                          userName: user.name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatAgriScreen extends StatelessWidget {
  final String userName;

  ChatAgriScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        title: Text(
          userName,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  'Chat with $userName',
                  style:
                      TextStyle(fontFamily: 'Poppins-Regular', fontSize: 16.5),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(2.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                        fontFamily: 'Poppins-Regular', fontSize: 13.5),
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9DC08B)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Send',
                    style: TextStyle(fontFamily: 'Poppins-Regular'),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFA9AF7E),
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

class User {
  final String name;
  final String message;
  final String time;
  final String profile;

  User({
    required this.name,
    required this.message,
    required this.time,
    required this.profile,
  });
}

List<User> users = [
  User(
    name: 'Arriane Gatpo',
    message:
        'Musta? Sample sample qui dolorem ipsum, quia dolor sit amet consectetur adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem',
    time: '5:34 PM',
    profile: 'assets/user.png',
  ),
  User(
    name: 'Daniella Marie Tungol',
    message: 'Nice one! Sample oks',
    time: '7:23 PM',
    profile: 'assets/user2.png',
  ),
  User(
    name: 'Marievic Anes',
    message: 'Kamusta? Uy!',
    time: '8:45 PM',
    profile: 'assets/user3.png',
  ),
  User(
    name: 'Jenkins Mesina',
    message: 'Pre',
    time: '9:12 PM',
    profile: 'assets/user4.png',
  ),
  User(
    name: 'Romeo London',
    message: 'Uy pre!',
    time: '10:56 PM',
    profile: 'assets/user5.png',
  ),
];
