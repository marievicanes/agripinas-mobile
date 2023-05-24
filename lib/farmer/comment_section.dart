import 'package:flutter/material.dart';

class Comment {
  final String username;
  final String comment;
  final String imageUrl;
  final DateTime time;

  Comment({
    required this.username,
    required this.comment,
    required this.imageUrl,
    required this.time,
  });
}

class CommentSection extends StatefulWidget {
  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFA9AF7E),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: comments.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
                height: 0,
              ),
              itemBuilder: (context, index) {
                Comment comment = comments[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/user.png'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  comment.comment,
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              comment.time.toString(),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 0),
                  ElevatedButton(
                    onPressed: () {
                      String commentText = commentController.text.trim();
                      if (commentText.isNotEmpty) {
                        Comment newComment = Comment(
                          username: 'Arriane Gatpo',
                          comment: commentText,
                          imageUrl: 'https://example.com/avatar.png',
                          time: DateTime.now(),
                        );
                        setState(() {
                          comments.add(newComment);
                          commentController.clear();
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(157, 192, 139, 1),
                      ),
                    ),
                    child: Text('Post'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
