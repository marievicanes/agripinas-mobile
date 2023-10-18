import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

String formatPostDate(dynamic postDate) {
  DateTime now = DateTime.now();
  DateTime formattedDateTime;

  if (postDate is String && postDate.toLowerCase() == 'just now') {
    return 'Just now';
  } else if (postDate is String) {
    formattedDateTime = DateTime.parse(postDate);
  } else if (postDate is DateTime) {
    formattedDateTime = postDate;
  } else {
    return '';
  }

  Duration difference = now.difference(formattedDateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else {
    return DateFormat('MMM dd, yyyy HH:mm:ss').format(formattedDateTime);
  }
}

class Post {
  final String userName;
  final String postContent;
  final String subtitleContent;
  final String formatPostDate;
  final String imageUrl;
  int upvotes;

  bool isLiked;

  Post({
    required this.userName,
    required this.postContent,
    required this.subtitleContent,
    required this.formatPostDate,
    required this.imageUrl,
    this.upvotes = 0,
    this.isLiked = false,
  });
}

class CommunityForumScreen extends StatefulWidget {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  _CommunityForumScreenState createState() => _CommunityForumScreenState();
}

class _CommunityForumScreenState extends State<CommunityForumScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  bool _isButtonVisible = true;
  File? _selectedImage;
  String imageUrl = '';
  bool _isTitleEmpty = true;
  bool _isImageSelected = false;
  List<Post> posts = [];

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
  final CollectionReference _forum =
      FirebaseFirestore.instance.collection('CommunityForum');
  final currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _timestampController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  Future<void> _post([DocumentSnapshot? documentSnapshot]) async {
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
                            final String userName = _userNameController.text;
                            final String title = _titleController.text;
                            final String content = _contentController.text;

                            FirebaseAuth auth = FirebaseAuth.instance;
                            User? user = auth.currentUser;
                            if (title != null) {
                              String? uid = user?.uid;
                              await _forum.add({
                                "uid": uid,
                                "title": title,
                                "content": content,
                                "timestamp": formatPostDate,
                                "image": imageUrl,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              width: 200.0,
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
                onChanged: searchItem,
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
                  Text(
                    'Community Forum',
                    style:
                        TextStyle(fontSize: 20.0, fontFamily: 'Poppins-Bold'),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: streamSnapshot.data?.docs.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        final Post thisItem = Post(
                          userName: items![index]['userName'] ?? '',
                          postContent: items[index]['title'] ?? '',
                          subtitleContent: items[index]['content'] ?? '',
                          imageUrl: items[index]['image'] ??
                              '', // You need to get subtitle from somewhere
                          formatPostDate: items[index]['formatPostDate'] ?? '',
                          upvotes: items[index]['upvotes'] ?? 0,
                          isLiked: false, // Set initial value
                        );

                        if (widget._searchText.isNotEmpty &&
                            !thisItem.userName
                                .toLowerCase()
                                .contains(widget._searchText.toLowerCase()) &&
                            !thisItem.postContent
                                .toLowerCase()
                                .contains(widget._searchText.toLowerCase())) {
                          return Container();
                        }

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailScreen(post: thisItem),
                              ),
                            );
                          },
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
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('Users')
                                                .where('uid',
                                                    isEqualTo: currentUser?.uid)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot
                                                      .data!.docs.isNotEmpty) {
                                                QueryDocumentSnapshot userData =
                                                    snapshot.data!.docs.first;
                                                String userName = userData
                                                    .get('fullname')
                                                    .toString();
                                                _userNameController.text =
                                                    thisItem.userName;
                                                return Text(
                                                  thisItem.userName,
                                                  style: TextStyle(
                                                    fontSize: 16.5,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                );
                                              } else {
                                                // Handle the case when there is no data or the document is empty
                                                return Text(
                                                    "No data available");
                                              }
                                            },
                                          ),
                                          Text(
                                            thisItem.formatPostDate,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    thisItem.postContent,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    thisItem.subtitleContent,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  ),
                                  SizedBox(height: 0.0),
                                  Image.network(
                                    thisItem.imageUrl,
                                    height: 200.0,
                                    width: 350.0,
                                  ),
                                  SizedBox(height: 0.0),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          thisItem.isLiked
                                              ? Icons.thumb_up
                                              : Icons.thumb_up_outlined,
                                          color: thisItem.isLiked
                                              ? Color.fromARGB(
                                                  255, 184, 192, 125)
                                              : null,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (thisItem.isLiked) {
                                              thisItem.upvotes--;
                                            } else {
                                              thisItem.upvotes++;
                                            }
                                            thisItem.isLiked =
                                                !thisItem.isLiked;
                                          });
                                        },
                                      ),
                                      Text('${thisItem.upvotes}'),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostDetailScreen(
                                                          post: thisItem)));
                                        },
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.black,
                                          ),
                                        ),
                                        child: Icon(Icons.comment),
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

  void searchItem(String text) {
    setState(() {
      widget._searchText = text;
    });
  }
}

class Comment {
  final String commenterText;
  final String commenterUid;
  final String commenterName;
  final DateTime commentertimestamp;

  Comment({
    required this.commenterText,
    required this.commenterUid,
    required this.commenterName,
    required this.commentertimestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'commenterText': commenterText,
      'commenterUid': commenterUid,
      'commenterName': commenterName,
      'commentertimestamp': formatPostDate,
    };
  }
}

class PostDetailScreen extends StatefulWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Post post;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  String formatPostDate(dynamic postDate) {
    DateTime now = DateTime.now();
    DateTime formattedDateTime;

    if (postDate is String && postDate.toLowerCase() == 'just now') {
      return 'Just now';
    } else if (postDate is String) {
      formattedDateTime = DateTime.parse(postDate);
    } else if (postDate is DateTime) {
      formattedDateTime = postDate;
    } else {
      return '';
    }

    Duration difference = now.difference(formattedDateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else {
      return DateFormat('MMM dd, yyyy HH:mm:ss').format(formattedDateTime);
    }
  }

  final CollectionReference _forum =
      FirebaseFirestore.instance.collection('CommunityForum');
  final currentUser = FirebaseAuth.instance.currentUser;

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
        body: StreamBuilder(
            stream:
                _forum.where('uid', isEqualTo: currentUser?.uid).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Center(
                    child: Text('Some error occurred ${streamSnapshot.error}'));
              }
              if (streamSnapshot.hasData) {
                QuerySnapshot<Object?>? querySnapshot = streamSnapshot.data;
                List<QueryDocumentSnapshot<Object?>>? documents =
                    querySnapshot?.docs;
                List<Comment> comments = documents
                        ?.map((e) => Comment(
                              commenterText: e['commenterText'],
                              commenterUid: e['commenterUid'],
                              commenterName: e['commenterName'],
                              commentertimestamp:
                                  (e['commentertimestamp'] as Timestamp)
                                      .toDate(),
                            ))
                        .toList() ??
                    [];

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 30.0),
                                CircleAvatar(
                                  radius: 15.0,
                                  backgroundImage:
                                      AssetImage('assets/user.png'),
                                ),
                                SizedBox(width: 8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              post.postContent,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Poppins-Bold',
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              post.subtitleContent,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Image.network(
                              post.imageUrl,
                              height: 200.0,
                              width: 350.0,
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    post.isLiked
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_outlined,
                                    color: post.isLiked
                                        ? Color.fromARGB(255, 184, 192, 125)
                                        : null,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (post.isLiked) {
                                        post.upvotes--;
                                      } else {
                                        post.upvotes++;
                                      }
                                      post.isLiked = !post.isLiked;
                                    });
                                  },
                                ),
                                Text('${post.upvotes}'),
                                TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                  ),
                                  child: Icon(Icons.comment),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
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
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                Comment comment = comments[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  leading: CircleAvatar(
                                    radius: 15.0,
                                    backgroundImage:
                                        AssetImage('assets/user.png'),
                                  ),
                                  title: Text(comment.commenterName),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible:
                                            false, // Change this condition as needed
                                        child: Text(comment.commenterUid),
                                      ),
                                      Text(
                                        comment.commenterText,
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    formatPostDate(comment.commentertimestamp),
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15.0,
                                  backgroundImage:
                                      AssetImage('assets/user.png'),
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Write a comment...',
                                    ),
                                    onSubmitted: (reply) {
                                      print('Reply: $reply');
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}

void main() {
  runApp(MaterialApp(
    home: CommunityForumScreen(),
  ));
}
