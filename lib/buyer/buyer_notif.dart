import 'package:flutter/material.dart';

void main() {
  runApp(BuyerAgriNotif());
}

class BuyerAgriNotif extends StatelessWidget {
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
            return Column(
              children: [
                SizedBox(height: 20.0),
                ListTile(
                  leading: Container(
                    width: 80.0,
                    height: 80.0,
                    child: Image.asset(
                      notification.icon,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    notification.title,
                    style:
                        TextStyle(fontFamily: 'Poppins-Medium', fontSize: 14.5),
                  ),
                  subtitle: Text(
                    notification.description,
                    style: TextStyle(
                        fontFamily: 'Poppins-Regular', fontSize: 12.5),
                  ),
                  trailing: Text(
                    notification.time,
                    style: TextStyle(
                        fontFamily: 'Poppins-Regular', fontSize: 10.0),
                  ),
                  onTap: () {},
                ),
              ],
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
    title: 'Parcel Delivered',
    description: 'Parcel for your order has been delivered',
    icon: 'assets/tomato.png',
    time: '2 hours ago',
  ),
  NotificationItem(
    title: 'Parcel Delivered',
    description: 'Parcel for your order has been delivered',
    icon: 'assets/onion.png',
    time: '1 day ago',
  ),
  NotificationItem(
    title: 'Parcel Delivered',
    description: 'Parcel for your order has been delivered',
    icon: 'assets/pechay.png',
    time: '2 days ago',
  ),
  NotificationItem(
    title: 'Parcel Delivered',
    description: 'Parcel for your order has been delivered',
    icon: 'assets/kalabasa.png',
    time: '3 days ago',
  ),
];
