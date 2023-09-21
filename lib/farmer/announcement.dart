import 'package:flutter/material.dart';

void main() {
  runApp(AnnouncementScreen());
}

class AnnouncementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnnouncementPage(),
    );
  }
}

class AnnouncementPage extends StatelessWidget {
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
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 32.0,
            ),
            SizedBox(width: 8.0),
            Text(
              'AgriPinas',
              style: TextStyle(
                fontSize: 17.0,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          AnnouncementCard(
            adminName: 'Admin',
            title: 'Meeting on July 14, 2023',
            content:
                'Dear Cabiao farmers,\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Integer lacinia pretium aliquet. Quisque euismod suscipit mi id accumsan. Quisque molestie varius nisl, eget dictum nunc eleifend quis. Mauris massa est, tincidunt vel venenatis venenatis, fringilla sed orci. Integer et rutrum est, quis venenatis mi. Vestibulum dictum posuere quam, facilisis convallis nunc auctor eu. Etiam iaculis eleifend lorem, ut consequat lacus efficitur rutrum. Sed porta tortor nec velit luctus ullamcorper. Aenean rutrum lectus id tristique tempor. Fusce non ligula varius orci euismod imperdiet at eu ipsum. Maecenas mollis ac est ac vehicula. Donec sit amet orci risus. Nunc malesuada ut ante ac pretium. In hac habitasse platea dictumst. Integer dapibus sodales tortor, et dapibus magna ullamcorper pretium.',
            dateTime: DateTime.now(),
          ),
          AnnouncementCard(
            adminName: 'Admin',
            title: 'Meeting on August 14, 2023',
            content:
                'Dear Cabiao farmers,\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Integer lacinia pretium aliquet. Quisque euismod suscipit mi id accumsan. Quisque molestie varius nisl, eget dictum nunc eleifend quis. Mauris massa est, tincidunt vel venenatis venenatis, fringilla sed orci. Integer et rutrum est, quis venenatis mi. Vestibulum dictum posuere quam, facilisis convallis nunc auctor eu. Etiam iaculis eleifend lorem, ut consequat lacus efficitur rutrum. Sed porta tortor nec velit luctus ullamcorper. Aenean rutrum lectus id tristique tempor. Fusce non ligula varius orci euismod imperdiet at eu ipsum. Maecenas mollis ac est ac vehicula. Donec sit amet orci risus. Nunc malesuada ut ante ac pretium. In hac habitasse platea dictumst. Integer dapibus sodales tortor, et dapibus magna ullamcorper pretium.',
            dateTime: DateTime.now().subtract(Duration(days: 1)),
          ),
        ],
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final String adminName;
  final String title;
  final String content;
  final DateTime dateTime;

  const AnnouncementCard({
    required this.adminName,
    required this.title,
    required this.content,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Posted by $adminName',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 20),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-Regular',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
