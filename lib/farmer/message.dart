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
        final buyerUids = <String>{};

        for (final messageDoc in querySnapshot.docs) {
          final room = messageDoc['room'] as String;
          final uids = room.split(' and ');

          if (uids.contains(currentUserUid)) {
            // This conversation involves the currentUserUid
            uids.remove(currentUserUid);
            buyerUids.add(uids[0]);
          }
        }

        final uniqueBuyerUids = buyerUids.toSet().toList(); // Remove duplicates
        controller.add(uniqueBuyerUids);
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
  Stream<String> getBuyerFullName(String buyerUid) {
    final controller = StreamController<String>();

    FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: buyerUid)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        final buyerFullName = userData['fullname'] as String;
        controller.add(buyerFullName);
      } else {
        controller.add('Unknown Buyer');
      }
    }, onError: (error) {
      print('Error fetching buyer full name: $error');
      controller.addError(error);
    });

    return controller.stream;
  }

  Future<String> fetchRoomName(String buyerUid, String currentUserUid) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('room', isEqualTo: '$currentUserUid and $buyerUid')
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

                      final List<String> buyerUids = snapshot.data ?? [];
                      print('Error fetching buyer full name: $buyerUids');
                      if (buyerUids.isEmpty) {
                        return Text('No conversations found');
                      }

                      return ListView.builder(
                        itemCount: buyerUids.length,
                        itemBuilder: (context, index) {
                          final buyerUid = buyerUids[index];
                          return StreamBuilder<String>(
                            stream: getBuyerFullName(buyerUid),
                            builder: (context, buyerSnapshot) {
                              if (buyerSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (buyerSnapshot.hasError) {
                                return Text('Error: ${buyerSnapshot.error}');
                              }
                              final buyerFullName =
                                  buyerSnapshot.data ?? 'Unknown Buyer';

                              return ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/user.png') // Add the farmer's image
                                    ),
                                title: Text(
                                  buyerFullName,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    fontSize: 14.5,
                                  ),
                                ),
                                trailing: Text(''),
                                onTap: () {
                                  // Fetch the roomName based on the farmerUid and currentUserUid
                                  fetchRoomName(buyerUid, currentUserUid!)
                                      .then((roomName) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatAgriScreen(
                                          fullname: buyerFullName,
                                          roomName:
                                              roomName, // Pass the roomName here
                                          currentUserUid: currentUserUid!,
                                          buyerUid: buyerUid,
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
  final String buyerUid;
  final String fullname;
  final String roomName;
  final TextEditingController _messageController = TextEditingController();

  ChatAgriScreen(
      {required this.fullname,
      required this.roomName,
      required this.currentUserUid,
      required this.buyerUid});

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: messageStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data?.docs;

                  return Column(
                    children: messages?.map((messageDoc) {
                          final message =
                              messageDoc.data() as Map<String, dynamic>;
                          final isCurrentUser = message['user'] == fullname;

                          return Align(
                            alignment: isCurrentUser
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isCurrentUser
                                      ? const Color(0xFFA9AF7E)
                                      : Colors.white,
                                  width: 1.5,
                                ),
                                color: isCurrentUser
                                    ? Colors.white
                                    : Color.fromARGB(255, 201, 207, 154),
                                borderRadius: isCurrentUser
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      )
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(8),
                                      ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Text(
                                    message['text'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                      fontSize: 14,
                                      color: isCurrentUser
                                          ? Colors.black
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 13.5,
                    ),
                    maxLines: null,
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
        ],
      ),
    );
  }
}
