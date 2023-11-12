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
  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');

  Future<void> _updateStatus(
      DocumentSnapshot? documentSnapshot, String cropID, String uid) async {
    if (documentSnapshot == null) {
      print('DocumentSnapshot is null. Cannot update status.');
      return;
    }

    final DocumentReference documentRef = _transaction.doc(documentSnapshot.id);

    final DocumentSnapshot document = await documentRef.get();

    if (document.exists) {
      final List<dynamic> orders = document['orders'] as List;

      final updatedCartItems = orders.map((cartItem) {
        if (cartItem['uid'] == currentUser.currentUser!.uid &&
            cartItem['cropID'] == cropID) {
          // Update the status for this specific cart item
          cartItem['status'] = selectedStatus;

          // If status is "Completed," update quantities in marketplace collection
          if (selectedStatus == 'Completed') {
            _updateMarketplaceQuantity(cartItem['cropID'],
                cartItem['boughtQuantity'], cartItem['uid']);
          }
        }
        return cartItem;
      }).toList();

      try {
        await _transaction.doc(documentSnapshot.id).update({
          'orders': updatedCartItems,
        });
        print('Status updated successfully');
      } catch (e) {
        print('Error updating status: $e');
      }
    } else {
      print('Document does not exist.');
    }
  }

  Future<void> _updateMarketplaceQuantity(
      String cropID, String boughtQuantity, String uid) async {
    try {
      // Query the marketplace collection for documents matching both cropID and uid
      QuerySnapshot marketplaceSnapshot = await _marketplace
          .where('cropID', isEqualTo: cropID)
          .where('uid', isEqualTo: uid)
          .get();

      // Check if any matching documents were found
      if (marketplaceSnapshot.docs.isNotEmpty) {
        // Assume there is only one matching document, get its reference
        final DocumentReference cropRef =
            marketplaceSnapshot.docs.first.reference;

        // Get the current data in the marketplace
        final DocumentSnapshot cropDocument = await cropRef.get();

        // Check if the document exists
        if (cropDocument.exists) {
          // Update the quantity by subtracting the boughtQuantity
          String currentQuantity = cropDocument['quantity'];
          int updatedQuantity =
              int.parse(currentQuantity) - int.parse(boughtQuantity);

          // Update the quantity in the marketplace collection
          await cropRef.update({
            'quantity': updatedQuantity.toString(),
          });

          print('Marketplace quantity updated successfully');
        } else {
          print('Document does not exist for cropID: $cropID and uid: $uid');
        }
      } else {
        print('No matching documents found in the marketplace collection.');
      }
    } catch (e) {
      print('Error updating marketplace quantity: $e');
    }
  }

  Future<void> _deleteTransac(
    String cropID,
  ) async {
    await _transaction.doc(cropID).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted the transaction')));
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
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: const Color(0xFFA9AF7E),
              centerTitle: true,
              title: Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 32.0,
                  ),
                  const SizedBox(width: 7.0),
                  const Text(
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
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Loading indicator
                  }

                  final querySnapshot = streamSnapshot.data!;
                  final documents = querySnapshot.docs;
                  List<Map>? items =
                      documents?.map((e) => e.data() as Map).toList();

                  return Column(children: [
                    const TabBar(
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
                    const Row(
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
                    const Row(
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
                    const Row(
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
                        padding: const EdgeInsets.all(10),
                        itemCount: streamSnapshot.data?.docs.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          // Get the item at this index from streamSnapshot
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          final Map thisItem = items![index];

                          String dateBought = thisItem['dateBought'];
                          DateTime dateTime =
                              DateFormat('yyyy-MM-dd').parse(dateBought);
                          String formattedDate =
                              DateFormat('MMMM d, y').format(dateTime);

                          List<Map<dynamic, dynamic>> pendingCartItems =
                              (thisItem['orders'] as List)
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: pendingCartItems.length,
                                itemBuilder:
                                    (BuildContext context, int cartIndex) {
                                  Map cartItem = pendingCartItems[cartIndex];
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
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
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.network(
                                                      '${cartItem['image']}',
                                                      fit: BoxFit.cover,
                                                      width: 80,
                                                      height: 80,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          color: Colors
                                                              .grey, // Customize the color
                                                          width: 80,
                                                          height: 80,
                                                          child: const Center(
                                                            child: Text(
                                                              'Image Error',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    '',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF718C53),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Farmer's Name: ",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${cartItem['fullname']}',
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Location: ",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${cartItem['location']}',
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
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
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Price: ',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '₱${cartItem['price']}',
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Quantity: ',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${cartItem['boughtQuantity']}',
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Unit: ',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${cartItem['unit']}',
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Total Amount: ',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '₱${cartItem['totalCost']}',
                                                        style: const TextStyle(
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
                                                icon: const Icon(
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
                                                          color: const Color(
                                                                  0xFF9DC08B)
                                                              .withAlpha(180),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        const Text(
                                                          'Status',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-Regular',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const PopupMenuItem<String>(
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
                                                            title: const Center(
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
                                                                const Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [],
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        16.0),
                                                                DropdownButtonFormField<
                                                                    String>(
                                                                  decoration:
                                                                      const InputDecoration(
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
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                                const SizedBox(
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
                                                                          const Text(
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
                                                                          cartItem[
                                                                              'cropID'],
                                                                          cartItem[
                                                                              'uid'],
                                                                        );

                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Save',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                        ),
                                                                      ),
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        backgroundColor: const Color
                                                                            .fromRGBO(
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
                                                          title: const Text(
                                                            'Delete Transaction?',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: const Text(
                                                            "This can't be undone and it will be removed from your transactions.",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                              fontSize: 13.8,
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: const Text(
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
                                                                    color: const Color(
                                                                            0xFF9DC08B)
                                                                        .withAlpha(
                                                                            180),
                                                                  )),
                                                              onPressed: () {
                                                                _deleteTransac(
                                                                    documentSnapshot
                                                                        .id);
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
                        padding: const EdgeInsets.all(10),
                        itemCount: streamSnapshot.data?.docs.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          // Get the item at this index from streamSnapshot
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          final Map thisItem = items![index];

                          String dateBought = thisItem['dateBought'];
                          DateTime dateTime =
                              DateFormat('yyyy-MM-dd').parse(dateBought);
                          String formattedDate =
                              DateFormat('MMMM d, y').format(dateTime);

                          List<Map<dynamic, dynamic>> cancelledCartItems =
                              (thisItem['orders'] as List)
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cancelledCartItems.length,
                                itemBuilder:
                                    (BuildContext context, int cartIndex) {
                                  Map cartItem = cancelledCartItems[cartIndex];
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
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
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.network(
                                                      '${cartItem['image']}',
                                                      fit: BoxFit.cover,
                                                      width: 80,
                                                      height: 80,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          color: Colors
                                                              .grey, // Customize the color
                                                          width: 80,
                                                          height: 80,
                                                          child: const Center(
                                                            child: Text(
                                                              'Image Error',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    '',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF718C53),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Farmer's Name: ",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${cartItem['fullname']}',
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Location: ",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${cartItem['location']}',
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
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
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Price: ',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '₱${cartItem['price']}',
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Quantity: ',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${cartItem['boughtQuantity']}',
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Unit: ',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${cartItem['unit']}',
                                                        style: const TextStyle(
                                                          fontSize: 14.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Total Amount: ',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '₱${cartItem['totalCost']}',
                                                        style: const TextStyle(
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
                          padding: const EdgeInsets.all(10),
                          itemCount: streamSnapshot.data?.docs.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            // Get the item at this index from streamSnapshot
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            final Map thisItem = items![index];

                            String dateBought = thisItem['dateBought'];
                            DateTime dateTime =
                                DateFormat('yyyy-MM-dd').parse(dateBought);
                            String formattedDate =
                                DateFormat('MMMM d, y').format(dateTime);

                            List<Map<dynamic, dynamic>> completedCartItems =
                                (thisItem['orders'] as List)
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: completedCartItems.length,
                                  itemBuilder:
                                      (BuildContext context, int cartIndex) {
                                    Map cartItem =
                                        completedCartItems[cartIndex];

                                    return GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
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
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        '${cartItem['image']}',
                                                        fit: BoxFit.cover,
                                                        width: 80,
                                                        height: 80,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Container(
                                                            color: Colors
                                                                .grey, // Customize the color
                                                            width: 80,
                                                            height: 80,
                                                            child: const Center(
                                                              child: Text(
                                                                'Image Error',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    const Text(
                                                      '',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF718C53),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Buyer Name: ',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${cartItem['fullname']}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
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
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Price: ',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '₱${cartItem['price']}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Quantity: ',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${cartItem['boughtQuantity']}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Unit: ',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${cartItem['unit']}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Total Amount: ',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '₱${cartItem['totalCost']}',
                                                          style:
                                                              const TextStyle(
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
                                                  icon: const Icon(
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
                                                    const PopupMenuItem<String>(
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
                                                    if (value == 'delete') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              'Delete Transaction?',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-Regular',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            content: const Text(
                                                              "This can't be undone and it will be removed from your transactions",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                                fontSize: 13.8,
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                child:
                                                                    const Text(
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
                                                                      color: const Color(
                                                                              0xFF9DC08B)
                                                                          .withAlpha(
                                                                              180),
                                                                    )),
                                                                onPressed: () {
                                                                  _deleteTransac(
                                                                      documentSnapshot
                                                                          .id);
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
