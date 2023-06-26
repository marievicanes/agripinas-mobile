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
                        backgroundImage: AssetImage('assets/user2.png'),
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
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    comment.comment,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                      fontSize: 13,
                                    ),
                                    maxLines: 5000,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                      maxLines: null,
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Reply here...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9DC08B)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9DC08B)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String commentText = commentController.text.trim();
                      if (commentText.isNotEmpty) {
                        Comment newComment = Comment(
                          username: 'Arriane Gatpo',
                          comment: commentText,
                          imageUrl: 'assets/user2.png',
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
