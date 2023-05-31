import 'package:capstone/farmer/profile_screen.dart';
import 'package:capstone/farmer/comment_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'about_us.dart';
import 'contact_us.dart';

class MarketplaceItem {
  final String title;
  final String price;
  final String farmer;
  final String description;
  final String imageUrl;

  MarketplaceItem({
    required this.title,
    required this.price,
    required this.farmer,
    required this.description,
    required this.imageUrl,
  });
}

class ProfileWall extends StatefulWidget {
  @override
  _ProfileWallState createState() => _ProfileWallState();
}

class _ProfileWallState extends State<ProfileWall>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _postController = TextEditingController();
  File? _selectedImage;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  final List<MarketplaceItem> items = [
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Ryan Amador',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Ryan Amador',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 4500',
      farmer: 'Ryan Amador',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Ryan Amador',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Ryan Amador',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Daniella Marie Tungol',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('Arriane Gatpo'),
                accountEmail: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Farmer'),
                    Text('ag@gatpo.com'),
                  ],
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 12.0,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFA9AF7E),
                ),
                otherAccountsPictures: [
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {},
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.settings_accessibility),
                title: Text('Profile Information'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('About us'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Contact Us'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactUsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: Color(0xFF557153),
              tabs: [
                Tab(
                  child: Text(
                    'Marketplace Wall',
                    style: TextStyle(color: Color(0xFF718C53)),
                  ),
                ),
                Tab(
                  child: Text(
                    'Community Forum Wall',
                    style: TextStyle(color: Color(0xFF718C53)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      childAspectRatio: 4 / 6,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
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
                                      child: Image.asset(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            item.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.price,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.farmer,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.description,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: PopupMenuButton<String>(
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
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Delete'),
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
                                            title: Text('Edit Details'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: _selectImage,
                                                  child: Text('Select Image'),
                                                ),
                                                SizedBox(height: 8),
                                                _selectedImage != null
                                                    ? Image.file(
                                                        _selectedImage!,
                                                        width: 100,
                                                        height: 100,
                                                      )
                                                    : SizedBox(height: 8),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: 'Crops Name',
                                                  ),
                                                ),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: 'Price',
                                                  ),
                                                ),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: "Farmer's Name",
                                                  ),
                                                ),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: 'Description',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if (value == 'delete') {
                                      // Handle delete functionality
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
                  Column(
                    children: [
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              PopupMenuButton<String>(
                                                onSelected: (value) {
                                                  if (value == 'edit') {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Edit Post'),
                                                          content: TextField(
                                                            maxLines: null,
                                                            decoration:
                                                                InputDecoration(
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
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            ElevatedButton(
                                                              child:
                                                                  Text('Post'),
                                                              onPressed: () {
                                                                String
                                                                    postContent =
                                                                    _postController
                                                                        .text;
                                                                print(
                                                                    postContent);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Color
                                                                    .fromRGBO(
                                                                        157,
                                                                        192,
                                                                        139,
                                                                        1),
                                                                onPrimary:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else if (value ==
                                                      'delete') {}
                                                },
                                                itemBuilder: (BuildContext
                                                        context) =>
                                                    <PopupMenuEntry<String>>[
                                                  PopupMenuItem<String>(
                                                    value: 'edit',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.edit,
                                                          color: Color(
                                                                  0xFF9DC08B)
                                                              .withAlpha(180),
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Text('Edit Post'),
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
                                                        SizedBox(width: 8.0),
                                                        Text('Delete Post'),
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
                                      'This is the content of the post.',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 10.0,
                                          backgroundImage:
                                              AssetImage('assets/user.png'),
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(
                                          'Posted by: Arriane Gatpo',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ],
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
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black),
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
                      SizedBox(height: 16.0),
                      Center(
                        child: MaterialButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Write a Post'),
                                  content: TextField(
                                    controller: _postController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: 'Something in your mind?',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text('Post'),
                                      onPressed: () {
                                        String postContent =
                                            _postController.text;
                                        print(postContent);
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromRGBO(157, 192, 139, 1),
                                        onPrimary: Colors.white,
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('Write a Post'),
                          color: Color.fromRGBO(157, 192, 139, 1),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              //
            ),
          ],
        ),
      ),
    );
  }

  void _saveInformation() {}
}
