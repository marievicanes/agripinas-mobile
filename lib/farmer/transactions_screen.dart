import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  String? selectedStatus;
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

  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('Transaction');

  Future<void> _updateStatus(
      DocumentSnapshot? documentSnapshot, String cropID) async {
    if (documentSnapshot == null) {
      print('DocumentSnapshot is null. Cannot update status.');
      return;
    }

    final DocumentReference documentRef = _transaction.doc(documentSnapshot.id);

    final DocumentSnapshot document = await documentRef.get();

    if (document.exists) {
      final List<dynamic> cartItems = document['cartItems'] as List;

      final updatedCartItems = cartItems.map((cartItem) {
        if (cartItem['uid'] == currentUser.currentUser!.uid) {
          if (cartItem['cropID'] == cropID) {
            // Update the status for this specific cart item
            cartItem['status'] = selectedStatus;
          }
        }
        return cartItem;
      }).toList();

      try {
        await _transaction.doc(documentSnapshot.id).update({
          'cartItems': updatedCartItems,
        });
        print('Status updated successfully');
      } catch (e) {
        print('Error updating status: $e');
      }
    } else {
      print('Document does not exist.');
    }
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
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
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
            body: StreamBuilder(
                stream: _transaction.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasError) {
                    return Center(
                        child: Text(
                            'Some error occurred ${streamSnapshot.error}'));
                  }
                  if (!streamSnapshot.hasData) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // Loading indicator
                  }

                  final querySnapshot = streamSnapshot.data!;
                  final documents = querySnapshot.docs;
                  List<Map>? items =
                      documents?.map((e) => e.data() as Map).toList();

                  return Column(children: [
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
                            'Cancelled',
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
                    Expanded(
                        child: TabBarView(children: [
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
                                      cartItem['uid'] ==
                                      currentUser.currentUser!.uid)
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
                                itemBuilder:
                                    (BuildContext context, int cartIndex) {
                                  Map cartItem = pendingCartItems[cartIndex];
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
                                                    '${cartItem['cropName']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 8),
                                                  Text(
                                                    '',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF718C53),
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
                                                              FontWeight.bold,
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
                                                              FontWeight.bold,
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
                                                              FontWeight.bold,
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
                                                              FontWeight.bold,
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
                                                              FontWeight.bold,
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
                                                      BorderRadius.circular(8),
                                                ),
                                                itemBuilder:
                                                    (BuildContext context) => [
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
                                                          'Status',
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
                                                                          BorderSide(
                                                                              color: Color(0xFFA9AF7E)),
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
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily: 'Poppins-Regular'),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        _updateStatus(
                                                                            documentSnapshot,
                                                                            cartItem['cropID']);

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
                                },
                              ),
                            ],
                          );
                        },
                      ),
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

                          List<Map<dynamic, dynamic>> cancelledCartItems =
                              (thisItem['cartItems'] as List)
                                  .where((cartItem) =>
                                      cartItem['uid'] ==
                                      currentUser.currentUser!.uid)
                                  .where((cartItem) =>
                                      cartItem['status'] == 'Cancelled')
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
                                itemCount: cancelledCartItems.length,
                                itemBuilder:
                                    (BuildContext context, int cartIndex) {
                                  Map cartItem = cancelledCartItems[cartIndex];
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
                                                    '${cartItem['cropName']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 8),
                                                  Text(
                                                    '',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF718C53),
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
                                                              FontWeight.bold,
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
                                                              FontWeight.bold,
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
                                                              FontWeight.bold,
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
                                                              FontWeight.bold,
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
                                                              FontWeight.bold,
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
                                            ),
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

                            List<Map<dynamic, dynamic>> completedCartItems =
                                (thisItem['cartItems'] as List)
                                    .where((cartItem) =>
                                        cartItem['uid'] ==
                                        currentUser.currentUser!.uid)
                                    .where((cartItem) =>
                                        cartItem['status'] == 'Completed')
                                    .map((cartItem) =>
                                        cartItem as Map<dynamic, dynamic>)
                                    .toList();

                            return Column(children: [
                              // Display transaction information here
                              // ...

                              // Use another ListView.builder to display pending cart items
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: completedCartItems.length,
                                  itemBuilder:
                                      (BuildContext context, int cartIndex) {
                                    Map cartItem =
                                        completedCartItems[cartIndex];

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
                                                      '${cartItem['cropName']}',
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
                                                        '${cartItem['imageUrl']}',
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
                                                    SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Buyer Name: ',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                          '${cartItem['dateBought']}',
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
                                                                FontWeight.bold,
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
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${cartItem['totalCost']}',
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
                                                                      labelStyle:
                                                                          TextStyle(
                                                                              color: Colors.black),
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
                                                              "This can't be undone and it will be removed from your transactions",
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
                                  })
                            ]);
                          })
                    ]))
                  ]);
                })));
  }
}
