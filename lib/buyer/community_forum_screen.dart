import 'package:capstone/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

String formatPostDate(DateTime postDateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(postDateTime);

  if (difference.inSeconds < 60) {
    return 'just now';
  } else {
    return DateFormat('MMM dd, yyyy HH:mm:ss').format(postDateTime);
  }
}

class Post {
  final String userName;
  final String postContent;
  final String subtitleContent;
  final String postDate;
  int upvotes;

  bool isLiked;

  Post({
    required this.userName,
    required this.postContent,
    required this.subtitleContent,
    required this.postDate,
    this.upvotes = 0,
    this.isLiked = false,
  });
}

class BuyerCommunityForumScreen extends StatefulWidget {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  _BuyerCommunityForumScreenState createState() =>
      _BuyerCommunityForumScreenState();
}

class _BuyerCommunityForumScreenState extends State<BuyerCommunityForumScreen> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  bool _isButtonVisible = true;
  File? _selectedImage;
  bool _isTitleEmpty = true;
  bool _isImageSelected = false;
  List<Post> posts = [];

  void _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _captureImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    posts = [
      Post(
        userName: 'Arriane Gatpo',
        postContent: 'Ano ang SRP ng sibuyas?',
        subtitleContent:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        postDate: formatPostDate(DateTime.now()),
        upvotes: 10,
      ),
      Post(
        userName: 'Daniella Tungol',
        postContent: 'Ano ang SRP ng Tomato?',
        subtitleContent:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        postDate: formatPostDate(DateTime.now()),
        upvotes: 10,
      ),
    ];
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
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community Forum',
              style: TextStyle(fontSize: 20.0, fontFamily: 'Poppins-Bold'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  final Post post = posts[index];

                  if (widget._searchText.isNotEmpty &&
                      !post.userName
                          .toLowerCase()
                          .contains(widget._searchText.toLowerCase()) &&
                      !post.postContent
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
                              BuyerPostDetailScreen(post: post),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.userName,
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      post.postDate,
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
                              post.postContent,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Poppins',
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
                            SizedBox(height: 0.0),
                            Image.asset(
                              'assets/corn.png',
                              height: 200.0,
                              width: 350.0,
                            ),
                            SizedBox(height: 0.0),
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
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BuyerPostDetailScreen(
                                                    post: post)));
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
      ),
      floatingActionButton: AnimatedPositioned(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        right: 16.0,
        bottom: _isButtonVisible ? 16.0 : -100.0,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
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
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(157, 192, 139, 1),
                                primary: Colors.white,
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
                                _pickImageFromGallery();
                                setState(() {
                                  _isImageSelected = true;
                                });
                              },
                              icon: Icon(Icons.file_upload),
                            ),
                            IconButton(
                              onPressed: () async {
                                _captureImageFromCamera();
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
                          controller: _postController,
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
                          controller: _subtitleController,
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
                );
              },
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(157, 192, 139, 1),
        ),
      ),
    );
  }

  void searchItem(String text) {
    setState(() {
      widget._searchText = text;
    });
  }
}

class Comment {
  final String userName;
  final String comment;
  final DateTime commentDate;

  Comment({
    required this.userName,
    required this.comment,
    required this.commentDate,
  });
}

class BuyerPostDetailScreen extends StatefulWidget {
  final Post post;

  BuyerPostDetailScreen({required this.post});

  @override
  _BuyerPostDetailScreenState createState() => _BuyerPostDetailScreenState();
}

class _BuyerPostDetailScreenState extends State<BuyerPostDetailScreen> {
  late Post post;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    post = widget.post;
    comments = [
      Comment(
        userName: 'Jenkins Mesina',
        comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        commentDate: DateTime.now().subtract(Duration(hours: 2)),
      ),
      Comment(
        userName: 'Romeo London',
        comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        commentDate: DateTime.now().subtract(Duration(hours: 1)),
      ),
    ];
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
      body: SingleChildScrollView(
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
                        backgroundImage: AssetImage('assets/user.png'),
                      ),
                      SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.userName,
                            style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            formatPostDate(post.postDate),
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
                  Image.asset(
                    'assets/corn.png',
                    height: 200.0,
                    width: 600.0,
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
                              MaterialStateProperty.all<Color>(Colors.black),
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
                          backgroundImage: AssetImage('assets/user.png'),
                        ),
                        title: Text(comment.userName),
                        subtitle: Text(
                          comment.comment,
                          style: TextStyle(fontSize: 14.0),
                        ),
                        trailing: Text(
                          formatPostDate(comment.commentDate),
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15.0,
                        backgroundImage: AssetImage('assets/user.png'),
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BuyerCommunityForumScreen(),
  ));
}
