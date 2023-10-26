import 'dart:io';

import 'package:capstone/buyer/message.dart';
import 'package:capstone/farmer/crop_tracker_screen.dart';
import 'package:capstone/farmer/forum_activity.dart';
import 'package:capstone/farmer/profile_marketplace.dart';
import 'package:capstone/farmer/profile_screen.dart';
import 'package:capstone/farmer/transactions_screen.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'about_us.dart';
import 'announcement.dart';
import 'contact_us.dart';
import 'notification.dart';

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
  String selectedCategory = "Fruits";
  String selectedUnit = "Sacks";

  String imageUrl = '';

  XFile? file;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile().then((imageUrl) {
          if (imageUrl != null) {
            setState(() {
              // Update the imageUrl in Firestore
              updateProfileImageUrl(imageUrl);

              // Set the imageUrl for displaying
              this.imageUrl = imageUrl;
            });
          }
        });
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

        uploadFile().then((imageUrl) {
          if (imageUrl != null) {
            setState(() {
              // Update the imageUrl in Firestore
              updateProfileImageUrl(imageUrl);

              // Set the imageUrl for displaying
              this.imageUrl = imageUrl;
            });
          }
        });
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> uploadFile() async {
    if (file == null) return null;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      String imageUrl = await referenceImageToUpload.getDownloadURL();
      return imageUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
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
                      currentAccountPicture: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: CircleAvatar(
                          radius: 10.0,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : NetworkImage(data['image']),
                        ),
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
                    imgFromGallery().then((imageUrl) {
                      if (imageUrl != null) {
                        setState(() {
                          // Update the imageUrl in Firestore
                          updateProfileImageUrl(imageUrl);

                          // Set the imageUrl for displaying
                          this.imageUrl = imageUrl;
                        });
                      }
                      Navigator.of(context).pop();
                    });
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    imgFromCamera().then((imageUrl) {
                      if (imageUrl != null) {
                        setState(() {
                          // Update the imageUrl in Firestore
                          updateProfileImageUrl(imageUrl);

                          // Set the imageUrl for displaying
                          this.imageUrl = imageUrl;
                        });
                      }
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateProfileImageUrl(String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.currentUser!.uid) // Use the user's UID
          .update({'image': imageUrl});
      setState(() {
        this.imageUrl = imageUrl;
      });
    } catch (error) {
      print('Error updating profile image: $error');
    }
  }
}
