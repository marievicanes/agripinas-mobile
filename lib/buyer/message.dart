import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

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

class ChatAgriScreen extends StatefulWidget {
  final String currentUserUid;
  final String farmerUid;
  final String fullname;
  final String roomName;
  final TextEditingController messageController = TextEditingController();

  ChatAgriScreen(
      {required this.fullname,
      required this.roomName,
      required this.currentUserUid,
      required this.farmerUid});

  @override
  _ChatAgriScreenState createState() => _ChatAgriScreenState(
        fullname: fullname,
        roomName: roomName,
        messageController: messageController,
        currentUserUID: '',
        image: '',
        files: '',
      );
}

class _ChatAgriScreenState extends State<ChatAgriScreen> {
  final String fullname;
  final String roomName;
  final String currentUserUID;
  final String image;
  final String files;
  final TextEditingController messageController;

  _ChatAgriScreenState({
    required this.currentUserUID,
    required this.image,
    required this.files,
    required this.fullname,
    required this.roomName,
    required this.messageController,
  });

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

  String imageUrl = '';
  String fileUrl = '';
  XFile? file;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile(currentUserUID, roomName, image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future UimgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile(currentUserUID, roomName, image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future UimgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile(currentUserUID, roomName, image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile(currentUserUID, roomName, image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(
      String currentUserUID, String roomName, String image) async {
    String userFirstName = await getUserFirstName(currentUserUID);

    if (file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      FirebaseFirestore.instance.collection('messages').add({
        'createdAt': FieldValue.serverTimestamp(),
        'user': userFirstName,
        'room': roomName,
        'imageUrl': imageUrl,
      });
    } catch (error) {}
  }

  Future pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Set to true if you want to allow multiple files
      type: FileType.custom, // Specify the allowed file types
      allowedExtensions: ['pdf', 'doc', 'docx'], // Add the allowed extensions
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String? userFirstName = await getUserFirstName(currentUserUID);

      if (file.name != null) {
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        String fileName = file.name; // Get the file name

        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirFiles = referenceRoot.child('files');
        Reference referenceFileToUpload =
            referenceDirFiles.child('$uniqueFileName$fileName');

        try {
          await referenceFileToUpload.putFile(File(file.path!));
          fileUrl = await referenceFileToUpload.getDownloadURL();

          FirebaseFirestore.instance.collection('messages').add({
            'createdAt': FieldValue.serverTimestamp(),
            'user': userFirstName,
            'room': roomName,
            'file_name': fileName, // Store the file name in the database
            'fileUrl': fileUrl, // Store the file URL in the database
          });
        } catch (error) {
          print("Error uploading file: $error");
        }
      }
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
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(-20),
                                      ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  if (message['text'] != null)
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 250,
                                      ),
                                      child: Text(
                                        message['text'],
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 14,
                                          color: isCurrentUser
                                              ? Colors.black
                                              : Colors.black,
                                        ),
                                        maxLines: null,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  if (message['imageUrl'] !=
                                      null) // Check if the message has an image
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ZoomableImage(
                                              message['imageUrl']);
                                        }));
                                      },
                                      child: Image.network(
                                        message['imageUrl'],
                                        width: 150,
                                        height: 150,
                                      ),
                                    ),
                                  if (message['fileUrl'] !=
                                      null) // Check if the message has a file
                                    ElevatedButton(
                                      onPressed: () {
                                        // Implement logic to download the file
                                      },
                                      child: Text('${message['file_name']}'),
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
                  onPressed: () {
                    _showPicker(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    pickAndUploadFile();
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
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
                    String newMessage = messageController.text;
                    if (newMessage.isNotEmpty) {
                      sendMessage(newMessage, fullname, roomName);
                      messageController.clear();
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

  void _UshowPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        UimgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      UimgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ZoomableImage extends StatelessWidget {
  final String imageUrl;

  ZoomableImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        title: Text(
          'Image',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16.5),
        ),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
      ),
    );
  }
}
