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
  bool _isButtonVisible = true;
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
      title: 'Tomato',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      description:
          'The tomato is the edible berry of the plant, commonly known as the tomato plant.',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: '₱400',
      farmer: 'Daniella Tungol',
      description:
          'An onion is a round vegetable with a brown skin that grows underground. ',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      farmer: 'Marievic Añes',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      title: 'Calamansi',
      price: '₱400',
      farmer: 'Jenkins Mesina',
      description:
          'Calamansi tastes sour with a hint of sweetness, like a mix between a lime and a mandarin',
      imageUrl: 'assets/calamansi.png',
    ),
    MarketplaceItem(
      title: 'Pechay',
      price: '₱400',
      farmer: 'Romeo London',
      description:
          'Pechay is a leafy, shallow-rooted, cool-season crop but can stand higher temperatures',
      imageUrl: 'assets/pechay.png',
    ),
    MarketplaceItem(
      title: 'Rice',
      price: '₱400',
      farmer: 'Mavic Anes',
      description:
          'Rice is edible starchy cereal grain and the grass plant (family Poaceae) by which it is produced.',
      imageUrl: 'assets/rice.png',
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
                    leading: Icon(Icons.settings_accessibility),
                    title: Text(
                      'Profile Information',
                      style: TextStyle(fontFamily: 'Poppins-Medium'),
                    ),
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
                    leading: Icon(Icons.edit),
                    title: Text(
                      'Edit Information',
                      style: TextStyle(fontFamily: 'Poppins-Medium'),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEdit(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(
                      'About us',
                      style: TextStyle(fontFamily: 'Poppins-Medium'),
                    ),
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
                    title: Text(
                      'Contact Us',
                      style: TextStyle(fontFamily: 'Poppins-Medium'),
                    ),
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
                    title: Text(
                      'Logout',
                      style: TextStyle(fontFamily: 'Poppins-Medium'),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            body: Column(children: [
              TabBar(
                indicatorColor: Color(0xFF557153),
                tabs: [
                  Tab(
                    child: Text(
                      'Marketplace Wall',
                      style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF718C53)),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Community Forum Wall',
                      style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF718C53)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  Stack(
                    children: [
                      GridView.builder(
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2 / 3.5,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                item.imageUrl,
                                                fit: BoxFit.cover,
                                                width: 200,
                                                height: 150,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text(
                                                item.title,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Poppins',
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
                                                  fontSize: 13,
                                                  fontFamily:
                                                      'Poppins-Regular'),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              item.description,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'Poppins-Regular'),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
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
                                                          onPressed:
                                                              _selectImage,
                                                          icon:
                                                              Icon(Icons.image),
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
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Crop's Name",
                                                        labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Poppins-Regular',
                                                            fontSize: 15.5,
                                                            color:
                                                                Colors.black),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFFA9AF7E)),
                                                        ),
                                                      ),
                                                    ),
                                                    TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Price',
                                                        labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Poppins-Regular',
                                                            fontSize: 15.5,
                                                            color:
                                                                Colors.black),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFFA9AF7E)),
                                                        ),
                                                      ),
                                                    ),
                                                    TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Farmer's Name",
                                                        labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Poppins-Regular',
                                                            fontSize: 15.5,
                                                            color:
                                                                Colors.black),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFFA9AF7E)),
                                                        ),
                                                      ),
                                                    ),
                                                    TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Description',
                                                        labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Poppins-Regular',
                                                            fontSize: 15.5,
                                                            color:
                                                                Colors.black),
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Save',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                            ),
                                                          ),
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    157,
                                                                    192,
                                                                    139,
                                                                    1),
                                                            primary:
                                                                Colors.white,
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
                      Positioned(
                        bottom: 16.0,
                        right: 16.0,
                        child: FloatingActionButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 16.0),
                                        Center(
                                          child: Text(
                                            'Add New Product',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Add photo: ',
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 15.5,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: _selectImage,
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
                                              color: Colors.black,
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 15.5,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFA9AF7E)),
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Price',
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 15.5,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFA9AF7E)),
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: "Farmer's Name",
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 15.5,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFA9AF7E)),
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Description',
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 15.5,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFA9AF7E)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 13.5,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            ElevatedButton(
                                              child: Text(
                                                'Add',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                              ),
                                              onPressed: () {
                                                String postContent =
                                                    _postController.text;
                                                print(postContent);
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Color.fromRGBO(
                                                    157, 192, 139, 1),
                                                onPrimary: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
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
                    ],
                  ),
                  Stack(
                    children: [
                      ListView.builder(
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
                                                  backgroundImage: AssetImage(
                                                      'assets/user.png'),
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  'Arriane Gatpo',
                                                  style: TextStyle(
                                                      fontSize: 16.5,
                                                      fontFamily: 'Poppins'),
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
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Edit Post',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
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
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins-Regular'),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
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
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else if (value == 'delete') {}
                                              },
                                              itemBuilder:
                                                  (BuildContext context) =>
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
                                                          fontFamily:
                                                              'Poppins-Regular',
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
                                                        color:
                                                            Color(0xFF9DC08B),
                                                      ),
                                                      SizedBox(width: 8.0),
                                                      Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
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
                                    'This is the content of the post.',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Poppins-Regular'),
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
                      Positioned(
                        bottom: 16.0,
                        right: 16.0,
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
                                            color: Colors.black,
                                            fontFamily: 'Poppins-Regular'),
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
                    ],
                  )
                ]),
              )
            ])));
  }

  void _saveInformation() {}
}
