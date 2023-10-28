import 'dart:io';

import 'package:capstone/buyer/buyer_language.dart';
import 'package:capstone/buyer/buyer_transactiondetails.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'about_us.dart';
import 'buyer_notif.dart';
import 'buyer_profilepage.dart';
import 'contact_us.dart';
import 'message.dart';

class MarketplaceItem {
  final String pendingitemname;
  final String rcategory;
  final String dateordered;
  final String unitprice;
  final String quantity;
  final String totalamount;
  final String buyername;
  final String imageUrl;

  MarketplaceItem({
    required this.pendingitemname,
    required this.rcategory,
    required this.dateordered,
    required this.unitprice,
    required this.quantity,
    required this.totalamount,
    required this.buyername,
    required this.imageUrl,
  });
}

class CancelledMarketplaceItem {
  final String cancelitemname;
  final String cancategory;
  final String dateordered;
  final String unitprice;
  final String quantity;
  final String totalamount;
  final String buyername;
  final String imageUrl1;

  CancelledMarketplaceItem({
    required this.cancelitemname,
    required this.cancategory,
    required this.dateordered,
    required this.unitprice,
    required this.quantity,
    required this.totalamount,
    required this.buyername,
    required this.imageUrl1,
  });
}

class CompleteMarketplaceItem {
  final String completeitemname;
  final String comcategory;
  final String dateordered;
  final String unitprice;
  final String quantity;
  final String totalamount;
  final String buyername;
  final String imageUrl2;

  CompleteMarketplaceItem({
    required this.completeitemname,
    required this.comcategory,
    required this.dateordered,
    required this.unitprice,
    required this.quantity,
    required this.totalamount,
    required this.buyername,
    required this.imageUrl2,
  });
}

class TransactionBuyer extends StatefulWidget {
  @override
  _TransactionBuyerState createState() => _TransactionBuyerState();
}

class _TransactionBuyerState extends State<TransactionBuyer>
    with SingleTickerProviderStateMixin {
  String? selectedStatus;
  bool _isButtonVisible = true;
  late TabController _tabController;
  final _postController = TextEditingController();

  final List<MarketplaceItem> items = [
    MarketplaceItem(
      pendingitemname: 'Onion',
      rcategory: 'Vegetable',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '5',
      totalamount: '₱2,000',
      buyername: 'Ryan Amador',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      pendingitemname: 'Rice',
      rcategory: 'Grain',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱500',
      quantity: '9',
      totalamount: '₱3,600',
      buyername: 'Daniel Ribaya',
      imageUrl: 'assets/rice.png',
    ),
    MarketplaceItem(
      pendingitemname: 'Pechay',
      rcategory: 'Vegetable',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱600',
      quantity: '2',
      totalamount: 'Php 1200',
      buyername: 'Ryan Amador',
      imageUrl: 'assets/pechay.png',
    ),
    MarketplaceItem(
      pendingitemname: 'Corn',
      rcategory: 'Fruit',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '10',
      totalamount: '₱4,000',
      buyername: 'Jenkins Mesina',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      pendingitemname: 'Tomato',
      rcategory: 'Fruit',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '11',
      totalamount: '₱4,400',
      buyername: 'Ryan Amador',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      pendingitemname: 'Calamansi',
      rcategory: 'Fruit',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '12',
      totalamount: '₱4,800',
      buyername: 'Ryan Amador',
      imageUrl: 'assets/calamansi.png',
    ),
  ];
  final List<CancelledMarketplaceItem> cancelitems = [
    CancelledMarketplaceItem(
      cancelitemname: 'Pechay',
      cancategory: 'Vegetable',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '5',
      totalamount: '₱2,000',
      buyername: 'Marievic Anes',
      imageUrl1: 'assets/pechay.png',
    ),
    CancelledMarketplaceItem(
      cancelitemname: 'Onion',
      cancategory: 'Vegetable',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱500',
      quantity: '9',
      totalamount: '₱3,600',
      buyername: 'Daniel Ribaya',
      imageUrl1: 'assets/onion.png',
    ),
    CancelledMarketplaceItem(
      cancelitemname: 'Squash',
      cancategory: 'Vegetable',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱600',
      quantity: '2',
      totalamount: 'Php 1200',
      buyername: 'Daniella Tungol',
      imageUrl1: 'assets/kalabasa.png',
    ),
    CancelledMarketplaceItem(
      cancelitemname: 'Corn',
      cancategory: 'Fruit',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '10',
      totalamount: '₱4,000',
      buyername: 'Romeo London III',
      imageUrl1: 'assets/corn.png',
    ),
    CancelledMarketplaceItem(
      cancelitemname: 'Calamansi',
      cancategory: 'Fruit',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '11',
      totalamount: '₱4,400',
      buyername: 'Jenkins Mesina',
      imageUrl1: 'assets/calamansi.png',
    ),
    CancelledMarketplaceItem(
      cancelitemname: 'Siling Labuyo',
      cancategory: 'Fruit',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '12',
      totalamount: '₱4,800',
      buyername: 'Ryan Amador',
      imageUrl1: 'assets/sili.png',
    ),
  ];
  final List<CompleteMarketplaceItem> completeitems = [
    CompleteMarketplaceItem(
      completeitemname: 'Squash',
      comcategory: 'Vegetbale',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '5',
      totalamount: '₱2,000',
      buyername: 'Marievic Anes',
      imageUrl2: 'assets/kalabasa.png',
    ),
    CompleteMarketplaceItem(
      completeitemname: 'Watermelon',
      comcategory: 'Fruit',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱500',
      quantity: '9',
      totalamount: '₱3,600',
      buyername: 'Daniel Ribaya',
      imageUrl2: 'assets/pakwan.png',
    ),
    CompleteMarketplaceItem(
      completeitemname: 'Corn',
      comcategory: 'Fruit',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱600',
      quantity: '2',
      totalamount: 'Php 1200',
      buyername: 'Daniella Tungol',
      imageUrl2: 'assets/corn.png',
    ),
    CompleteMarketplaceItem(
      completeitemname: 'Pechay',
      comcategory: 'Vegetbale',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '10',
      totalamount: '₱4,000',
      buyername: 'Romeo London III',
      imageUrl2: 'assets/pechay.png',
    ),
    CompleteMarketplaceItem(
      completeitemname: 'Calamansi',
      comcategory: 'Fruit',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '11',
      totalamount: '₱4,400',
      buyername: 'Jenkins Mesina',
      imageUrl2: 'assets/calamansi.png',
    ),
    CompleteMarketplaceItem(
      completeitemname: 'Siling Labuyo',
      comcategory: 'Fruit',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '12',
      totalamount: '₱4,800',
      buyername: 'Ryan Amador',
      imageUrl2: 'assets/sili.png',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String imageUrl = '';

  XFile? file;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
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

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final currentUser = FirebaseAuth.instance;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        key: _formKey,
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
                            backgroundImage: AssetImage('assets/user.png'),
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
                                      builder: (context) => BuyerAgriNotif()));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.message),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Message()));
                            },
                          ),
                        ],
                      ),
                      ListTile(
                        leading: Icon(Icons.person_2_outlined),
                        title: Text(
                          'Profile',
                          style: TextStyle(fontFamily: 'Poppins-Medium'),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()));
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
                                  builder: (context) => BuyerAboutUsScreen()));
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
                                  builder: (context) =>
                                      BuyerContactUsScreen()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.language_outlined),
                        title: Text(
                          'Wika / Langauge',
                          style: TextStyle(fontFamily: 'Poppins-Medium'),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuyerLanguage(),
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Logout your account?',
                                  style: TextStyle(fontFamily: "Poppins"),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      AuthService authService = AuthService();
                                      authService.logOutUser(context);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF9DC08B).withAlpha(180),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator(); // Add loading indicator
                }
              }, // Add a closing parenthesis here
            ), // Add a closing parenthesis here
          ),
          body: Column(children: [
            TabBar(
              indicatorColor: Color(0xFF557153),
              tabs: [
                Tab(
                  child: Text(
                    'To Receive',
                    style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        color: Color(0xFF718C53)),
                  ),
                ),
                Tab(
                  child: Text(
                    'Completed',
                    style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        color: Color(0xFF718C53)),
                  ),
                ),
                Tab(
                  child: Text(
                    'Cancelled',
                    style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        color: Color(0xFF718C53)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '     Transactions',
                    style:
                        TextStyle(fontSize: 20.0, fontFamily: 'Poppins-Bold'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [],
            ),
            Expanded(
                child: TabBarView(
              children: [
                ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.pendingitemname,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF718C53),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          "Category: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.rcategory,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          "Farmer's Name: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.buyername,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Date Ordered: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.dateordered,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Price: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.unitprice,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.quantity,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.totalamount,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: completeitems.length,
                  itemBuilder: (context, index) {
                    final item = completeitems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuyerTransactionDetails(
                                productData: {}, // Pass your product data here
                                item: item, // Pass the selected item
                              ),
                            ));
                      },
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.completeitemname,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        item.imageUrl2,
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF718C53),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          "Category: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.comcategory,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          "Farmer's Name: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.buyername,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Date Ordered: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.dateordered,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Price: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.unitprice,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.quantity,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.totalamount,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: cancelitems.length,
                  itemBuilder: (context, index) {
                    final item = cancelitems[index];
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.cancelitemname,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        item.imageUrl1,
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF718C53),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          "Category: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.cancategory,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          "Farmer's Name: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.buyername,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          'Date Ordered: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.dateordered,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Price: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.unitprice,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.quantity,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.totalamount,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )),
          ]),
        ));
  }

  void _saveInformation() {}

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
    } catch (error) {
      print('Error updating profile image: $error');
    }
  }
}
