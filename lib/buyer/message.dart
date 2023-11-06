import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentUserUid;
  bool isCurrentUserUidFetched = false;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserUid();
  }

  Stream<String> fetchCurrentUserUid() {
    final userUID = _auth.currentUser?.uid;
    final controller = StreamController<String>();

    if (userUID != null) {
      setState(() {
        currentUserUid = userUID;
        isCurrentUserUidFetched = true;
      });
      controller.add(currentUserUid!);
    } else {
      controller.addError('User not authenticated');
    }

    return controller.stream;
  }

  Stream<List<String>> fetchConversations() {
    final controller = StreamController<List<String>>();

    if (currentUserUid != null) {
      FirebaseFirestore.instance
          .collection('messages')
          .where('room')
          .orderBy('createdAt')
          .snapshots()
          .listen((querySnapshot) {
        final farmerUids = <String>{};

        for (final messageDoc in querySnapshot.docs) {
          final room = messageDoc['room'] as String;
          final uids = room.split(' and ');

          if (uids.contains(currentUserUid)) {
            // This conversation involves the currentUserUid
            // Add the other UID (farmer) to the list

            farmerUids.add(uids[0]);
          }
        }

        final uniqueFarmerUids =
            farmerUids.toSet().toList(); // Remove duplicates
        controller.add(uniqueFarmerUids);
      }, onError: (error) {
        print('Error fetching conversations: $error');
        controller.addError(error);
      });
    } else {
      controller.addError('User UID not fetched');
    }

    return controller.stream;
  }

  // Function to fetch the fullname of the farmer based on UID
  Stream<String> getFarmerFullName(String farmerUid) {
    final controller = StreamController<String>();

    FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: farmerUid)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        final farmerFullName = userData['fullname'] as String;
        controller.add(farmerFullName);
      } else {
        controller.add('Unknown Farmer');
      }
    }, onError: (error) {
      print('Error fetching farmer full name: $error');
      controller.addError(error);
    });

    return controller.stream;
  }

  Future<String> fetchRoomName(String farmerUid, String currentUserUid) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('room', isEqualTo: '$farmerUid and $currentUserUid')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final roomName = querySnapshot.docs[0]['room']
          as String; // Adjust this to your actual field name
      return roomName;
    } else {
      return 'DefaultRoomName'; // Replace with a default name if the room is not found
    }
  }

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
          isCurrentUserUidFetched
              ? Expanded(
                  child: StreamBuilder<List<String>>(
                    stream: fetchConversations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final List<String> farmerUids = snapshot.data ?? [];

                      if (farmerUids.isEmpty) {
                        return Text('No conversations found');
                      }

                      return ListView.builder(
                        itemCount: farmerUids.length,
                        itemBuilder: (context, index) {
                          final farmerUid = farmerUids[index];
                          return StreamBuilder<String>(
                            stream: getFarmerFullName(farmerUid),
                            builder: (context, farmerSnapshot) {
                              if (farmerSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (farmerSnapshot.hasError) {
                                return Text('Error: ${farmerSnapshot.error}');
                              }
                              final farmerFullName =
                                  farmerSnapshot.data ?? 'Unknown Farmer';

                              return ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/user.png') // Add the farmer's image
                                    ),
                                title: Text(
                                  farmerFullName,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    fontSize: 14.5,
                                  ),
                                ),
                                trailing: Text(''),
                                onTap: () {
                                  // Fetch the roomName based on the farmerUid and currentUserUid
                                  fetchRoomName(farmerUid, currentUserUid!)
                                      .then((roomName) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatAgriScreen(
                                          fullname: farmerFullName,
                                          roomName:
                                              roomName, // Pass the roomName here
                                          currentUserUid: currentUserUid!,
                                          farmerUid: farmerUid,
                                        ),
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class ChatAgriScreen extends StatelessWidget {
  final String currentUserUid;
  final String farmerUid;
  final String fullname;
  final String roomName;
  final TextEditingController _messageController = TextEditingController();

  ChatAgriScreen(
      {required this.fullname,
      required this.roomName,
      required this.currentUserUid,
      required this.farmerUid});

  Stream<QuerySnapshot> getMessageStream(String roomName) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('room', isEqualTo: roomName)
        .orderBy('createdAt')
        .snapshots();
  }

  void sendMessage(String text, String currentUserUID, String roomName) async {
    String userFirstName = await getUserFirstName(currentUserUID);

    FirebaseFirestore.instance.collection('messages').add({
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
      'user': userFirstName,
      'room': roomName,
    });
  }

  Future<String> getUserFirstName(String userUID) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        return userSnapshot.docs[0].get('fullname') as String;
      } else {
        return "Unknown User";
      }
    } catch (error) {
      print("Error fetching user's first name: $error");
      return "Error Fetching Name";
    }
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> messageStream = getMessageStream(roomName);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        title: Text(
          fullname,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16.5),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: messageStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data?.docs;

          return ListView.builder(
            itemCount: messages?.length,
            itemBuilder: (context, index) {
              final message = messages?[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(message['user']),
                subtitle: Text(message['text']),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(2.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 13.5),
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
              onPressed: () {
                String newMessage = _messageController.text;
                if (newMessage.isNotEmpty) {
                  sendMessage(newMessage, fullname, roomName);
                  _messageController.clear();
                }
              },
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
    );
  }
}
