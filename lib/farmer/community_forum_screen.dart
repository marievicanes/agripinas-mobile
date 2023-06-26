import 'package:capstone/farmer/comment_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommunityForumScreen extends StatefulWidget {
  @override
  _CommunityForumScreenState createState() => _CommunityForumScreenState();
}

class _CommunityForumScreenState extends State<CommunityForumScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final _postController = TextEditingController();
  bool _isButtonVisible = true;

  void searchItem(String text) {
    setState(() {
      _searchText = text;
    });
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
                controller: _searchController,
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
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15.0,
                                          backgroundImage:
                                              AssetImage('assets/user.png'),
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(
                                          'Arriane Gatpo',
                                          style: TextStyle(
                                            fontSize: 16.5,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(
                                        Icons.more_horiz,
                                        color: Color(0xFF9DC08B),
                                      ),
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Edit Post',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                                content: TextField(
                                                  maxLines: null,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Regular',
                                                    fontSize: 14.0,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Edit post here...',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    child: Text(
                                                      'Post',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      String postContent =
                                                          _postController.text;
                                                      print(postContent);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Color.fromRGBO(
                                                          157, 192, 139, 1),
                                                      onPrimary: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else if (value == 'delete') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Delete Post?',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Regular',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Text(
                                                  "This can't be undone and it will be removed from your profile",
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
                                                        color: Color(0xFF9DC08B)
                                                            .withAlpha(180),
                                                      ),
                                                    ),
                                                    onPressed: () {
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
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Color(0xFF9DC08B)
                                                    .withAlpha(180),
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                'Edit',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
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
                                                color: Color(0xFF9DC08B),
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'What is the srp of onions?',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Poppins-Regular',
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            DateFormat('MMM dd, yyyy').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up),
                                onPressed: () {},
                              ),
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: CommentSection(),
                                      );
                                    },
                                  );
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Write a Post',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  content: TextField(
                    controller: _postController,
                    maxLines: null,
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 14.0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Something in your mind?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Poppins-Regular'),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: Text('Post',
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                          )),
                      onPressed: () {
                        String postContent = _postController.text;
                        print(postContent);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(157, 192, 139, 1),
                        onPrimary: Colors.white,
                      ),
                    ),
                  ],
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
}
