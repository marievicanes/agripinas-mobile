import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AgriNotification());
}

class AgriNotification extends StatelessWidget {
  final CollectionReference _notif =
      FirebaseFirestore.instance.collection('Notification');
  final currentUser = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();

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
        body: StreamBuilder(
          stream: _notif.where('uid', isEqualTo: currentUser!.uid).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasError) {
              return Center(
                child: Text('Error: ${streamSnapshot.error}'),
              );
            }

            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'There are no notifications.',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }

            QuerySnapshot<Object?>? querySnapshot = streamSnapshot.data;
            List<QueryDocumentSnapshot<Object?>>? documents =
                querySnapshot?.docs;
            List<Map>? items = documents?.map((e) => e.data() as Map).toList();

            return ListView.builder(
              itemCount: items?.length ?? 0,
              itemBuilder: (context, index) {
                // Access the data from Firestore document
                final Map notificationData = items![index];

                if (notificationData != null) {
                  final String title = notificationData['title'];
                  final String message = notificationData['message'];
                  final Timestamp timestamp = notificationData['timestamp'];

                  // Format timestamp as a string (you may want to customize the formatting)
                  final String formattedTimestamp =
                      timestamp.toDate().toString();

                  return ListTile(
                    title: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Poppins-Medium',
                        fontSize: 14.5,
                      ),
                    ),
                    subtitle: Text(
                      message,
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 12.5,
                      ),
                    ),
                    trailing: Text(
                      formattedTimestamp,
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 10.0,
                      ),
                    ),
                    onTap: () {
                      // Handle notification tap
                    },
                  );
                } else {
                  return Container(); // Placeholder for empty data
                }
              },
            );
          },
        ),
      ),
    );
  }
}
