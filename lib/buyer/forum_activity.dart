import 'dart:io';

import 'package:capstone/buyer/forum_archive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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
      home: ForumActivity(),
    );
  }
}

class ForumActivity extends StatefulWidget {
  @override
  _ForumActivityState createState() => _ForumActivityState();
}

class _ForumActivityState extends State<ForumActivity> {
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

  Future<void> _post([DocumentSnapshot? documentSnapshot]) async {
    final String uid = currentUser!.uid;

    if (uid == null) {
      // Handle the case where the user is not authenticated
      return;
    }
    final String fullname = await fetchUserFullname(uid);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final String title = _titleController.text;
                            final String content = _contentController.text;
                            final String isLiked = _isLikedController.text;

                            String postID = const Uuid().v4();

                            DateTime currentDate = DateTime.now();
                            String formattedDate =
                                DateFormat('MM-dd-yyyy HH:mm:ss a')
                                    .format(currentDate);

                            FirebaseAuth auth = FirebaseAuth.instance;
                            User? user = auth.currentUser;
                            if (title != null) {
                              String? uid = user?.uid;
                              await _forum.add({
                                "uid": uid,
                                "postID": postID,
                                "title": title,
                                "content": content,
                                "isLiked": isLiked,
                                "fullname": fullname,
                                "timestamp": formattedDate,
                                "image": imageUrl,
                                "comments": [],
                              });
                              _titleController.text = '';
                              _contentController.text = '';
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromRGBO(157, 192, 139, 1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Post',
                          style: TextStyle(fontFamily: 'Poppins-Regular'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 9.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '',
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 15.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          _showPicker(context);
                          setState(() {
                            _isImageSelected = true;
                          });
                        },
                        icon: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  TextField(
                    controller: _titleController,
                    maxLines: 2,
                    onChanged: (value) {
                      setState(() {
                        _isTitleEmpty = value.trim().isEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Title",
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: 15.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _contentController,
                    maxLines: 100,
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 14.0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Something in your mind? (Optional)',
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _updatePost([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot == null) {
      // Handle the case where the documentSnapshot is null
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final String title = _titleController.text;
                            final String content = _contentController.text;

                            // Update the specific post with new data
                            await documentSnapshot.reference.update({
                              "title": title,
                              "content": content,
                              "image": imageUrl,
                            });

                            _titleController.text = '';
                            _contentController.text = '';

                            // Close the bottom sheet
                            Navigator.of(context).pop();
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromRGBO(157, 192, 139, 1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(fontFamily: 'Poppins-Regular'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 9.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '',
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 15.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          _showPicker(context);
                          setState(() {
                            _isImageSelected = true;
                          });
                        },
                        icon: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  TextField(
                    controller: _titleController,
                    maxLines: 2,
                    onChanged: (value) {
                      setState(() {
                        _isTitleEmpty = value.trim().isEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Title",
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: 15.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _contentController,
                    maxLines: 100,
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 14.0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Something in your mind? (Optional)',
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(
    String postID,
  ) async {
    await _forum.doc(postID).delete();
    ScaffoldMessenger.of(context);
  }

  Future<void> archivePost(DocumentSnapshot documentSnapshot) async {
    // Get the reference to the document
    final documentReference = _forum.doc(documentSnapshot.id);

    try {
      // Update the "archived" field to true
      await documentReference.update({'archived': true});
      print('Your post is archived successfully.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your post is archived successfully.'),
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
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: 180.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TextField(
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
        stream: _forum.where('uid', isEqualTo: currentUser?.uid).snapshots(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(1.0),
                            child: Text(
                              'Forum Activity',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins-Bold',
                              ),
                            ),
                          ),
                          SizedBox(width: 160.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForumActivityArchive(),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/archiveicon.png',
                                  width: 30,
                                  height: 30,
                                  color: Color(0xFF5c9348),
                                ),
                              ),
                              Text(
                                'Archive',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins-Regular',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
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

                            return Stack(children: [
                              InkWell(
                                onTap: () {},
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
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
                                            PopupMenuButton<String>(
                                              icon: Icon(
                                                Icons.more_horiz,
                                                color: Color(0xFF9DC08B),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                PopupMenuItem<String>(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: Color(0xFF9DC08B)
                                                            .withAlpha(180),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        "userEdit".tr(),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color:
                                                            Color(0xFF9DC08B),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        "userDelete".tr(),
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
                                                        Icons.archive,
                                                        color:
                                                            Color(0xFF9DC08B),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        "farmerArchive".tr(),
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
                                                if (value == 'edit') {
                                                  _updatePost(documentSnapshot);
                                                } else if (value == 'delete') {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            "farmerDeleteProduct"
                                                                .tr(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: Text(
                                                            "farmerDeleteProductCantBeUndone"
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
                                                                "userCancel"
                                                                    .tr(),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-Regular',
                                                                  color: Colors
                                                                      .black,
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
                                                                  "userDelete"
                                                                      .tr(),
                                                                  style:
                                                                      TextStyle(
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
                                                                _delete(
                                                                    documentSnapshot
                                                                        .id);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                } else if (value == 'archive') {
                                                  archivePost(documentSnapshot);
                                                }
                                              },
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
                                                        : Icons
                                                            .thumb_up_outlined,
                                                    color:
                                                        thisItem['isLiked'] ==
                                                                true
                                                            ? Color.fromARGB(
                                                                255,
                                                                184,
                                                                192,
                                                                125)
                                                            : null,
                                                  ),
                                                  onPressed: () async {
                                                    final FirebaseAuth auth =
                                                        FirebaseAuth.instance;
                                                    final User? user =
                                                        auth.currentUser;

                                                    if (user != null) {
                                                      final String uid =
                                                          user.uid;
                                                      final String postId =
                                                          documentSnapshot.id;

                                                      // Check if the user has already liked the post
                                                      if (thisItem['isLiked'] ==
                                                          true) {
                                                        // If already liked, remove like
                                                        thisItem['isLiked'] =
                                                            false;
                                                        likesCount--;

                                                        // Remove the user's ID from the 'likes' array in the forum document
                                                        if (thisItem['likes'] !=
                                                            null) {
                                                          thisItem['likes']
                                                              .remove(uid);
                                                        }
                                                      } else {
                                                        // If not liked, add like
                                                        thisItem['isLiked'] =
                                                            true;
                                                        likesCount++;

                                                        // Add the user's ID to the 'likes' array in the forum document
                                                        if (thisItem['likes'] ==
                                                            null) {
                                                          thisItem['likes'] = [
                                                            uid
                                                          ];
                                                        } else {
                                                          thisItem['likes']
                                                              .add(uid);
                                                        }
                                                      }

                                                      // Update the forum post with the new like status and 'likes' array
                                                      _forum
                                                          .doc(postId)
                                                          .update({
                                                        'isLiked':
                                                            thisItem['isLiked'],
                                                        'likes':
                                                            thisItem['likes'],
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
                                                    fontFamily:
                                                        'Poppins-Regular',
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PostDetailScreen(
                                                                  postID:
                                                                      documentSnapshot
                                                                          .id,
                                                                  thisItem: {},
                                                                ) // Pass the document ID to the widget
                                                            ));
                                                  },
                                                  style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
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
                              )
                            ]);
                          },
                        ),
                      ),
                    ]));
          }
          return CircularProgressIndicator(); // Return loading indicator while data is loading
        },
      ),
      floatingActionButton: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.only(
            right: 16.0, bottom: _isButtonVisible ? 16.0 : -100.0),
        child: FloatingActionButton(
          onPressed: () => _post(),
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(157, 192, 139, 1),
        ),
      ),
    );
  }

  void _UshowPicker(context) {
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

class PostDetailScreen extends StatefulWidget {
  final Map thisItem;
  final String postID;

  PostDetailScreen({required this.thisItem, required this.postID});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
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
                      "farmerCommunityPostText6".tr(),
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
                              hintText: "mobfarmerCommunityWriteComment".tr(),
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
