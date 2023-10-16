import 'dart:io';

import 'package:capstone/farmer/forum_activity.dart';
import 'package:capstone/farmer/profile_marketplace.dart';
import 'package:capstone/farmer/profile_screen.dart';
import 'package:flutter/services.dart';
import 'package:capstone/farmer/crop_tracker_screen.dart';
import 'package:capstone/farmer/message.dart';
import 'package:capstone/farmer/transactions_screen.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'about_us.dart';
import 'announcement.dart';
import 'contact_us.dart';
import 'notification.dart';
import 'profile_screen.dart';

class MarketplaceItem {
  final String title;
  final String price;
  final String farmer;
  final String location;
  final String description;
  final String imageUrl;

  MarketplaceItem({
    required this.title,
    required this.price,
    required this.farmer,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}

class ProfileWall extends StatefulWidget {
  @override
  _ProfileWallState createState() => _ProfileWallState();
}

class _ProfileWallState extends State<ProfileWall> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonVisible = true;
  final _postController = TextEditingController();
  File? _selectedImage;
  String selectedCategory = "Fruits";
  String selectedUnit = "Sacks";
  bool _isImageSelected = false;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

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

  final List<Map<String, dynamic>> listViewitems = [
    {
      'title': 'Crop Tracker',
      'icon': Icons.agriculture_outlined,
    },
    {
      'title': 'Transactions',
      'icon': Icons.money_outlined,
    },
    {
      'title': 'Forum Activity',
      'icon': Icons.forum_outlined,
    },
    {
      'title': 'Posted Products',
      'icon': Icons.store_mall_directory_outlined,
    },
  ];

  final List<MarketplaceItem> gridViewitems = [
    MarketplaceItem(
      title: 'Tomato',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      location: 'Brgy. Bagong Buhay',
      description:
          'The tomato is the edible berry of the plant, commonly known as the tomato plant.',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      farmer: 'Marievic Añes',
      location: 'Brgy. Bagong Silang',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      title: 'Calamansi',
      price: '₱400',
      farmer: 'Jenkins Mesina',
      location: 'Brgy. Concepcion',
      description:
          'Calamansi tastes sour with a hint of sweetness, like a mix between a lime and a mandarin',
      imageUrl: 'assets/calamansi.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      farmer: 'Marievic Añes',
      location: 'Brgy. Bagong Silang',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
  ];

  final currentUser = FirebaseAuth.instance;
  AuthService authService = AuthService();
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
        drawer: Drawer(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .where("uid", isEqualTo: currentUser.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.docs[0];
                return ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(data['fullname']),
                      accountEmail: Text(data['email']),
                      currentAccountPicture: CircleAvatar(
                        radius: 10.0,
                        backgroundImage: AssetImage('assets/user.png'),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFA9AF7E),
                      ),
                      otherAccountsPictures: [
                        IconButton(
                          icon: Icon(Icons.notifications),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AgriNotif(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Message(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      leading: Icon(Icons.person_outlined),
                      title: Text(
                        'Profile',
                        style: TextStyle(fontFamily: 'Poppins-Medium'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.announcement_outlined),
                      title: Text(
                        'Announcement',
                        style: TextStyle(fontFamily: 'Poppins-Medium'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnouncementScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outlined),
                      title: Text(
                        'About Us',
                        style: TextStyle(fontFamily: 'Poppins-Medium'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutUsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.contact_mail_outlined),
                      title: Text(
                        'Contact Us',
                        style: TextStyle(fontFamily: 'Poppins-Medium'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactUsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout_outlined),
                      title: Text(
                        'Logout',
                        style: TextStyle(fontFamily: 'Poppins-Medium'),
                      ),
                      onTap: () {
                        AuthService authService = AuthService();
                        authService.logOutUser(context);
                      },
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            child: ListView.builder(
              itemCount: listViewitems.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final item = listViewitems[index];

                return Card(
                  elevation: 3,
                  child: SizedBox(
                    child: ListTile(
                      leading: Icon(
                        item['icon'],
                        size: 50,
                      ),
                      title: Text(
                        listViewitems[index]['title'],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins-Medium'),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CropTrackerScreen()),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionsScreen()),
                          );
                        } else if (index == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForumActivity()),
                          );
                        } else if (index == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostedProducts()),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ])));
  }
}
