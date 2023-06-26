import 'package:capstone/farmer/message.dart';
import 'package:capstone/farmer/profile_edit.dart';
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
  final String? imageUrl;

  MarketplaceItem({
    required this.title,
    required this.price,
    required this.farmer,
    required this.description,
    this.imageUrl,
  });
}

class ProfileWall extends StatefulWidget {
  @override
  _ProfileWallState createState() => _ProfileWallState();
}

class _ProfileWallState extends State<ProfileWall> {
  bool _isButtonVisible = true;
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
      title: 'Tomato',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      description:
          'The tomato is the edible berry of the plant, commonly known as the tomato plant.',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      title: 'Carrot',
      price: '₱300',
      farmer: 'John Doe',
      description: 'The carrot is a root vegetable, usually orange in color.',
      imageUrl: null,
    ),
  ];

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
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                '',
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 0,
                ),
              ),
              accountEmail: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arriane Gatpo',
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    'Farmer',
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
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
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Message()),
                    );
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Profile',
                style: TextStyle(fontFamily: 'Poppins-Medium'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(
                'Edit Profile',
                style: TextStyle(fontFamily: 'Poppins-Medium'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileEdit()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text(
                'Marketplace',
                style: TextStyle(fontFamily: 'Poppins-Medium'),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.comment),
              title: Text(
                'Comment Section',
                style: TextStyle(fontFamily: 'Poppins-Medium'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommentSection()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                'About Us',
                style: TextStyle(fontFamily: 'Poppins-Medium'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text(
                'Contact Us',
                style: TextStyle(fontFamily: 'Poppins-Medium'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2.0,
                  blurRadius: 5.0,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  title: Text(
                    item.farmer,
                    style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 12.0,
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                if (item.imageUrl != null)
                  Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200.0,
                  )
                else
                  Container(),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.0),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
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
                              foregroundColor: MaterialStateProperty.all<Color>(
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
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileWall(),
  ));
}
