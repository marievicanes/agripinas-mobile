import 'package:flutter/material.dart';

void main() {
  runApp(AgriNotification());
}

class AgriNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color(0xFFA9AF7E),
          title: Text(
            'Notifications',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
        body: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            NotificationItem notification = notifications[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(notification.icon),
              ),
              title: Text(
                notification.title,
                style: TextStyle(fontFamily: 'Poppins-Medium', fontSize: 14.5),
              ),
              subtitle: Text(
                notification.description,
                style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 12.5),
              ),
              trailing: Text(
                notification.time,
                style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 10.0),
              ),
              onTap: () {
                // Handle notification tap
              },
            );
          },
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String icon;
  final String time;

  NotificationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.time,
  });
}

List<NotificationItem> notifications = [
  NotificationItem(
    title: 'Jenkins Mesina',
    description: 'Received his order',
    icon: 'assets/user4.png',
    time: '2 hours ago',
  ),
  NotificationItem(
    title: 'Daniella Tungol',
    description: 'Received her order',
    icon: 'assets/user2.png',
    time: '1 day ago',
  ),
  NotificationItem(
    title: 'Ryan Amador',
    description: 'Received his order',
    icon: 'assets/user5.png',
    time: '2 days ago',
  ),
  NotificationItem(
    title: 'Romeo London',
    description: 'Received his order',
    icon: 'assets/user4.png',
    time: '3 days ago',
  ),
];
