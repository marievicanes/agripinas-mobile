import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fil', 'PH')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: ForumActivityArchive(),
    );
  }
}

class ForumActivityArchive extends StatefulWidget {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  _ForumActivityArchiveState createState() => _ForumActivityArchiveState();
}

class _ForumActivityArchiveState extends State<ForumActivityArchive> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isButtonVisible = true;
  File? _selectedImage;
  String imageUrl = '';
  bool _isTitleEmpty = true;
  bool _isImageSelected = false;

  @override
  void initState() {
    super.initState();
    // Call a function to fetch the current user's fullname
    fetchCurrentUserFullname();
  }

  // Function to fetch the current user's fullname
  void fetchCurrentUserFullname() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? uid = user?.uid;

    // Use the user's UID to fetch their fullname from the 'Users' collection
    if (uid != null) {
      DocumentSnapshot userDocument = await _user.doc(uid).get();
      String fullname = userDocument.get('fullname');

      // Now, you can use the 'fullname' variable as needed
      setState(() {
        _fullnameController.text = fullname;
      });
    }
  }

  Future<String> fetchUserFullname(String uid) async {
    DocumentSnapshot userDocument = await _user.doc(uid).get();
    String fullname = userDocument.get('fullname');
    return fullname;
  }

  XFile? file;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile();
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

        uploadFile();
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

        uploadFile();
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

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  final CollectionReference _user =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _like =
      FirebaseFirestore.instance.collection('Likes');
  final CollectionReference _forum =
      FirebaseFirestore.instance.collection('CommunityForum');
  final currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _isLikedController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  Future<void> _delete(
    String postID,
  ) async {
    await _forum.doc(postID).delete();
    ScaffoldMessenger.of(context);
  }

  Future<void> restorePost(DocumentSnapshot documentSnapshot) async {
    // Get the reference to the document
    final documentReference = _forum.doc(documentSnapshot.id);

    try {
      // Update the "archived" field to true
      await documentReference.update({'archived': false});
      print('The product is restores successfully.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The product is restored successfully.'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    } catch (error) {
      print('Error archiving document: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        centerTitle: true,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 32.0,
            ),
            SizedBox(width: 7.0),
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
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: 170.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TextField(
                controller: widget._searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _forum
            .where('uid', isEqualTo: currentUser?.uid)
            .where('archived', isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasError) {
            return Center(
                child: Text('Some error occurred ${streamSnapshot.error}'));
          }
          if (streamSnapshot.hasData) {
            QuerySnapshot<Object?>? querySnapshot = streamSnapshot.data;
            List<QueryDocumentSnapshot<Object?>>? documents =
                querySnapshot?.docs;
            List<Map>? items = documents?.map((e) => e.data() as Map).toList();

            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            'Forum Activity Archive',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins-Bold',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: streamSnapshot.data?.docs.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        final Map thisItem = items![index];

                        int likesCount = thisItem['likes'] != null
                            ? thisItem['likes'].length
                            : 0;

                        return InkWell(
                          onTap: () {},
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CircleAvatar(
                                        radius: 15.0,
                                        backgroundImage:
                                            AssetImage('assets/user.png'),
                                      ),
                                      SizedBox(width: 8.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${thisItem['fullname']}',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '${thisItem['timestamp']}',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: PopupMenuButton<String>(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Color(0xFF9DC08B),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          itemBuilder: (BuildContext context) =>
                                              [
                                            PopupMenuItem<String>(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Color(0xFF9DC08B),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'archive',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.restore,
                                                    color: Color(0xFF9DC08B),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "farmerRestore".tr(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          onSelected: (String value) {
                                            if (value == 'archive') {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "farmerRestoreProduct"
                                                            .tr(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-Regular',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: Text(
                                                        "farmerRestoreProductDialog"
                                                            .tr(),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                          fontSize: 13.8,
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          child: Text(
                                                            "userCancel".tr(),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text(
                                                              "farmerRestore"
                                                                  .tr(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                        0xFF9DC08B)
                                                                    .withAlpha(
                                                                        180),
                                                              )),
                                                          onPressed: () {
                                                            restorePost(
                                                                documentSnapshot);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "CommunityForumDeletePost"
                                                          .tr(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "CommunityForumCantBeUndonePost"
                                                          .tr(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 13.8,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-Regular',
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-Regular',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                    0xFF9DC08B)
                                                                .withAlpha(180),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _delete(
                                                              documentSnapshot
                                                                  .id);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    '${thisItem['title']}',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    '${thisItem['content']}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  ),
                                  SizedBox(height: 0.0),
                                  Image.network(
                                    '${thisItem['image']}',
                                    height: 200.0,
                                    width: 350.0,
                                  ),
                                  SizedBox(height: 0.0),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              thisItem['isLiked'] == true
                                                  ? Icons.thumb_up
                                                  : Icons.thumb_up_outlined,
                                              color: thisItem['isLiked'] == true
                                                  ? Color.fromARGB(
                                                      255, 184, 192, 125)
                                                  : null,
                                            ),
                                            onPressed: () async {
                                              final FirebaseAuth auth =
                                                  FirebaseAuth.instance;
                                              final User? user =
                                                  auth.currentUser;

                                              if (user != null) {
                                                final String uid = user.uid;
                                                final String postId =
                                                    documentSnapshot.id;

                                                // Check if the user has already liked the post
                                                if (thisItem['isLiked'] ==
                                                    true) {
                                                  // If already liked, remove like
                                                  thisItem['isLiked'] = false;
                                                  likesCount--;

                                                  // Remove the user's ID from the 'likes' array in the forum document
                                                  if (thisItem['likes'] !=
                                                      null) {
                                                    thisItem['likes']
                                                        .remove(uid);
                                                  }
                                                } else {
                                                  // If not liked, add like
                                                  thisItem['isLiked'] = true;
                                                  likesCount++;

                                                  // Add the user's ID to the 'likes' array in the forum document
                                                  if (thisItem['likes'] ==
                                                      null) {
                                                    thisItem['likes'] = [uid];
                                                  } else {
                                                    thisItem['likes'].add(uid);
                                                  }
                                                }

                                                // Update the forum post with the new like status and 'likes' array
                                                _forum.doc(postId).update({
                                                  'isLiked':
                                                      thisItem['isLiked'],
                                                  'likes': thisItem['likes'],
                                                }).then((value) {
                                                  print(
                                                      "Like status and 'likes' array updated successfully");
                                                }).catchError((error) {
                                                  print(
                                                      "Error updating like status and 'likes' array: $error");
                                                });

                                                // Update the UI
                                                setState(() {});
                                              }
                                            },
                                          ),
                                          Text(
                                            likesCount
                                                .toString(), // Display the number of likes
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'Poppins-Regular',
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ForumActivityPostDetail(
                                                            postID:
                                                                documentSnapshot
                                                                    .id,
                                                            thisItem: {},
                                                          ) // Pass the document ID to the widget
                                                      ));
                                            },
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.black,
                                              ),
                                            ),
                                            child: Icon(Icons.comment),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return CircularProgressIndicator(); // Return loading indicator while data is loading
        },
      ),
    );
  }

  void _showCommentDialog(documentSnapshot) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add a Comment"),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: "Enter your comment...",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                final String comment = _commentController.text;
                if (comment.isNotEmpty) {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final String uid = user?.uid ?? '';
                  final String fullname = user?.displayName ?? '';

                  final commentData = {
                    'uid': uid,
                    'fullname': fullname,
                    'comment': comment,
                    'dateCommented': DateTime.now().toUtc().toIso8601String(),
                  };

                  final String postID = documentSnapshot.id;
                  final String commentText =
                      _commentController.text; // Get the comment text

                  // Update the comments in the Firestore document for the specific forum post
                  _forum.doc(postID).update({
                    'comments': FieldValue.arrayUnion([
                      {
                        'uid': uid,
                        'dateCommented':
                            DateTime.now().toUtc().toIso8601String(),
                        'commentText': commentText,
                      }
                    ])
                  }).then((value) {
                    print("Comment added to the post");
                  }).catchError((error) {
                    print("Error adding comment: $error");
                  });

                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class ForumActivityPostDetail extends StatefulWidget {
  final Map thisItem;
  final String postID;

  ForumActivityPostDetail({required this.thisItem, required this.postID});

  @override
  _ForumActivityPostDetailState createState() =>
      _ForumActivityPostDetailState();
}

class _ForumActivityPostDetailState extends State<ForumActivityPostDetail> {
  final CollectionReference _forum =
      FirebaseFirestore.instance.collection('CommunityForum');
  final CollectionReference _users = FirebaseFirestore.instance
      .collection('Users'); // Collection for user information
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> comments = [];
  String fullname = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFA9AF7E),
          centerTitle: true,
          title: Row(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 32.0,
              ),
              SizedBox(width: 7.0),
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
        body: StreamBuilder<DocumentSnapshot>(
            stream: _forum.doc(widget.postID).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final postDocument = snapshot.data;

              if (postDocument == null || !postDocument.exists) {
                return Center(child: Text('Post not found.'));
              }

              List<Map<String, dynamic>> comments =
                  List<Map<String, dynamic>>.from(postDocument['comments']);

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Poppins-Bold',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    // Display the list of comments
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: comments.length + 1,
                        itemBuilder: (context, index) {
                          if (index < comments.length) {
                            final comment = comments[index];
                            final String text = comment['text'];
                            final String fullname = comment['fullname'];

                            return ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: CircleAvatar(
                                radius: 15.0,
                                backgroundImage: AssetImage('assets/user.png'),
                              ),
                              title: Text(fullname),
                              subtitle: Text(
                                text,
                                style: TextStyle(fontSize: 14.0),
                              ),
                            );
                          }
                          ;
                        }),
                    SizedBox(height: 16.0),
                    // Textfield to allow users to add comments
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15.0,
                          backgroundImage: AssetImage('assets/user.png'),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Write a comment...',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async {
                            final String text = _commentController.text;
                            if (text.isNotEmpty) {
                              final String postId = widget.postID;
                              final currentUserUid = currentUser!.uid;

                              final userDocSnapshot =
                                  await _users.doc(currentUserUid).get();

                              if (userDocSnapshot.exists) {
                                final userDoc = userDocSnapshot.data()
                                    as Map<String, dynamic>;
                                final fullname = userDoc['fullname'];

                                // Create a comment map
                                Map<String, dynamic> commentMap = {
                                  'text': text,
                                  'fullname': fullname,
                                };

                                // Update the comments array in the post document
                                await _forum.doc(postId).update({
                                  'comments':
                                      FieldValue.arrayUnion([commentMap]),
                                });

                                // Clear the comment text field
                                _commentController.clear();

                                // Reload the comments
                                final updatedPost = await _forum
                                        .doc(postId)
                                        .get()
                                    as DocumentSnapshot<Map<String, dynamic>>;
                                comments = updatedPost
                                        .data()?['comments']
                                        ?.cast<Map<String, dynamic>>() ??
                                    [];
                                setState(() {});
                              } else {
                                print('User document not found');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
