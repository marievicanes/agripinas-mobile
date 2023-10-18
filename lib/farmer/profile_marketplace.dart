import 'dart:io';

import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostedProducts extends StatefulWidget {
  @override
  _PostedProductsState createState() => _PostedProductsState();
}

class _PostedProductsState extends State<PostedProducts> {
  bool _isButtonVisible = true;
  final _postController = TextEditingController();
  File? _selectedImage;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final currentUser = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();

  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');

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
                width: 170.0,
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
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: _marketplace
                .where('uid', isEqualTo: currentUser?.uid)
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
                List<Map>? items =
                    documents?.map((e) => e.data() as Map).toList();

                return SingleChildScrollView(
                    child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            'Posted Products',
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
                  GridView.builder(
                    itemCount: streamSnapshot.data?.docs.length ?? 0,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(3),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2 / 4,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      // Get the item at this index from streamSnapshot
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      final Map thisItem = items![index];
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            '${thisItem['image']}',
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 150,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            '${thisItem['cropName']}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              'Price: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${thisItem['price']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Location:',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${thisItem['location']}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Description:',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${thisItem['description']}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 8,
                                child: PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Color(0xFF9DC08B),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  itemBuilder: (BuildContext context) => [
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
                                          SizedBox(width: 8),
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
                                  onSelected: (String value) {
                                    if (value == 'edit') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Center(
                                              child: Text(
                                                'Edit Details',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Add photo: ',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 15.5,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.image),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                _selectedImage != null
                                                    ? Image.file(
                                                        _selectedImage!,
                                                        width: 100,
                                                        height: 100,
                                                      )
                                                    : SizedBox(height: 8),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: "Crop's Name",
                                                    labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 15.5,
                                                        color: Colors.black),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFFA9AF7E)),
                                                    ),
                                                  ),
                                                ),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: 'Price',
                                                    labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 15.5,
                                                        color: Colors.black),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFFA9AF7E)),
                                                    ),
                                                  ),
                                                ),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: "Farmer's Name",
                                                    labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 15.5,
                                                        color: Colors.black),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFFA9AF7E)),
                                                    ),
                                                  ),
                                                ),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: 'Description',
                                                    labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 15.5,
                                                        color: Colors.black),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFFA9AF7E)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 16.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                          fontSize: 15.5,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        String postContent =
                                                            _postController
                                                                .text;
                                                        print(postContent);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Save',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            Color.fromRGBO(157,
                                                                192, 139, 1),
                                                        primary: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ]));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
