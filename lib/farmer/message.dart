import 'package:flutter/material.dart';

void main() {
  runApp(TelegramApp());
}

class TelegramApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Messages'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  title: Text('User ${index + 1}'),
                  subtitle: Text('Hi! Your app is great!'),
                  trailing: Text('12:34 PM'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          userName: 'User ${index + 1}',
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

class ChatDetailScreen extends StatelessWidget {
  final String userName;

  ChatDetailScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        title: Text(userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  'Chat details for $userName',
                  style: TextStyle(fontSize: 18.0),
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
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Send'),
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
