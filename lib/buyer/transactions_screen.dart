import 'dart:io';

import 'package:capstone/buyer/buyer_language.dart';
import 'package:capstone/buyer/buyer_transactiondetails.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'about_us.dart';
import 'buyer_notif.dart';
import 'buyer_profilepage.dart';
import 'contact_us.dart';
import 'message.dart';

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

  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('Transaction');

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
          body: StreamBuilder(
              stream: _transaction
                  .where('buid', isEqualTo: currentUser.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasError) {
                  return Center(
                      child:
                          Text('Some error occurred ${streamSnapshot.error}'));
                }
                if (streamSnapshot.hasData) {
                  QuerySnapshot<Object?>? querySnapshot = streamSnapshot.data;
                  List<QueryDocumentSnapshot<Object?>>? documents =
                      querySnapshot?.docs;
                  List<Map>? items =
                      documents?.map((e) => e.data() as Map).toList();

                  return Column(
                    children: [
                      TabBar(
                        indicatorColor: Color(0xFF557153),
                        tabs: [
                          Tab(
                            child: Text(
                              'Pending',
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
                              style: TextStyle(
                                  fontSize: 20.0, fontFamily: 'Poppins-Bold'),
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
                              itemCount: streamSnapshot.data?.docs.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                // Get the item at this index from streamSnapshot
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                final Map thisItem = items![index];

                                Timestamp dateOrdered = thisItem['dateBought'];
                                DateTime dateTime = dateOrdered.toDate();
                                String formattedDate =
                                    DateFormat.yMMMMd().format(dateTime);

                                List<Map<dynamic, dynamic>> pendingCartItems =
                                    (thisItem['cartItems'] as List)
                                        .where((cartItem) =>
                                            cartItem['status'] == 'Pending')
                                        .map((cartItem) =>
                                            cartItem as Map<dynamic, dynamic>)
                                        .toList();

                                return Column(
                                  children: [
                                    // Display transaction information here
                                    // ...

                                    // Use another ListView.builder to display pending cart items
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: pendingCartItems.length,
                                      itemBuilder: (BuildContext context,
                                          int cartIndex) {
                                        Map cartItem =
                                            pendingCartItems[cartIndex];
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Card(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${cartItem['cropName']}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Image.network(
                                                            '${cartItem['imageUrl']}',
                                                            fit: BoxFit.cover,
                                                            width: 80,
                                                            height: 80,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(height: 8),
                                                        Text(
                                                          '',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xFF718C53),
                                                          ),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Farmer's Name: ",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${cartItem['fullname']}',
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
                                                              "Location: ",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${cartItem['location']}',
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              formattedDate
                                                                  .toString(),
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${cartItem['price']}',
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${cartItem['boughtQuantity']}',
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${cartItem['totalCost']}',
                                                              style: TextStyle(
                                                                fontSize: 14.5,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            ListView.builder(
                                padding: EdgeInsets.all(10),
                                itemCount:
                                    streamSnapshot.data?.docs.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  // Get the item at this index from streamSnapshot
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  final Map thisItem = items![index];

                                  if (thisItem['status'] == 'Cancelled') {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${thisItem['cropName']}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        '${thisItem['image']}',
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 8),
                                                    Text(
                                                      '',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF718C53),
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Farmer's Name: ",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['fullname']}',
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
                                                          "Location: ",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['location']}',
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['dateBought']}',
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['price']}',
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['boughtQuantity']}',
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['totalCost']}',
                                                          style: TextStyle(
                                                            fontSize: 14.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          [
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
                                                          SizedBox(width: 8),
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
                                                            color: Color(
                                                                0xFF9DC08B),
                                                          ),
                                                          SizedBox(width: 8),
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
                                                  onSelected: (String value) {
                                                    if (value == 'edit') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                              title: Center(
                                                                child: Text(
                                                                  'Edit Details',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20.0,
                                                                      fontFamily:
                                                                          'Poppins'),
                                                                ),
                                                              ),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          16.0),
                                                                  DropdownButtonFormField<
                                                                      String>(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Status',
                                                                      labelStyle: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'Poppins-Regular'),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Color(0xFFA9AF7E)),
                                                                      ),
                                                                    ),
                                                                    value:
                                                                        selectedStatus,
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        selectedStatus =
                                                                            newValue;
                                                                      });
                                                                    },
                                                                    items: <String>[
                                                                      'Pending',
                                                                      'Cancelled',
                                                                      'Completed'
                                                                    ].map<
                                                                        DropdownMenuItem<
                                                                            String>>((String
                                                                        value) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            value,
                                                                        child:
                                                                            Text(
                                                                          value,
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-Regular',
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          16.0),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: 'Poppins-Regular'),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          String
                                                                              postContent =
                                                                              _postController.text;
                                                                          print(
                                                                              postContent);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Save',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-Regular',
                                                                          ),
                                                                        ),
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          backgroundColor: Color.fromRGBO(
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
                                                              ));
                                                        },
                                                      );
                                                    } else if (value ==
                                                        'delete') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Delete Transaction?',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-Regular',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            content: Text(
                                                              "This can't be undone and it will be removed from your transactions.",
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
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Poppins-Regular',
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                    'Delete',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Poppins-Regular',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                              0xFF9DC08B)
                                                                          .withAlpha(
                                                                              180),
                                                                    )),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
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
                                      ),
                                    );
                                  }
                                  ;
                                }),
                            ListView.builder(
                                padding: EdgeInsets.all(10),
                                itemCount:
                                    streamSnapshot.data?.docs.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  // Get the item at this index from streamSnapshot
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  final Map thisItem = items![index];

                                  if (thisItem['status'] == 'Cancelled') {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BuyerTransactionDetails(),
                                            ));
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${thisItem['cropName']}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        '${thisItem['image']}',
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 8),
                                                    Text(
                                                      '',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF718C53),
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Farmer's Name: ",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['fullname']}',
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
                                                          "Location: ",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['location']}',
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['dateBought']}',
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['price']}',
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['boughtQuantity']}',
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['totalCost']}',
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
                                  }
                                  ;
                                }),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
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
