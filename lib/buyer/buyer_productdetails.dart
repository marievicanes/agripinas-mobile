import 'package:capstone/buyer/add_to_cart.dart';
import 'package:capstone/buyer/buynow_checkout.dart';
import 'package:capstone/buyer/message.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ProductDetails extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final Map productData;

  ProductDetails(this.productData);

  DateTime? selectedDate;

  final CollectionReference _userCarts =
      FirebaseFirestore.instance.collection('UserCarts');
  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');
  final currentUser = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();

  Future<void> transferData(
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
  ) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String cropID = productData['cropID'] ?? '';

    if (currentUser != null) {
      // Reference to your Marketplace collection
      CollectionReference<Map<String, dynamic>> marketplaceRef =
          FirebaseFirestore.instance.collection('Marketplace');

      // Query the Marketplace collection for documents with the matching cropID
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await marketplaceRef.where('cropID', isEqualTo: cropID).get();

      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String? buid = user?.uid;

      // Replace productData with the data you want to transfer
      Map<String, dynamic> productData = documentSnapshot.data() ?? {};

      DateTime currentDate = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

      // Reference to your UserCarts collection
      CollectionReference<Map<String, dynamic>> userCartsRef =
          FirebaseFirestore.instance.collection('UserCarts');

      // Process each document in the querySnapshot
      for (var marketplaceDoc in querySnapshot.docs) {
        String itemId = const Uuid().v4();
        String cropName = marketplaceDoc['cropName'] ?? '';
        String location = marketplaceDoc['location'] ?? '';
        String category = marketplaceDoc['category'] ?? '';
        String unit = marketplaceDoc['unit'] ?? '';
        String price = marketplaceDoc['price'] ?? '';
        String fullname = marketplaceDoc['fullname'] ?? '';
        String quantity = marketplaceDoc['quantity'] ?? '';
        String imageUrl = marketplaceDoc['image'] ?? '';
        String uid = marketplaceDoc['uid'] ?? '';
        bool archived = marketplaceDoc['archived'] ?? false;

        String totalCost = price;
        String totalAmount = '0';
        String totalBoughtQuantity = '0';
        String boughtQuantity = '1';

        await userCartsRef.add({
          'uid': uid,
          'buid': buid,
          'cropID': cropID,
          'itemId': itemId,
          'cropName': cropName,
          'location': location,
          'category': category,
          'unit': unit,
          'price': price,
          'fullname': fullname,
          'totalCost': totalCost,
          'totalAmount': totalAmount,
          'boughtQuantity': boughtQuantity,
          'totalBoughtQuantity': totalBoughtQuantity,
          'quantity': quantity,
          'image': imageUrl,
          'dateBought': formattedDate,
          'archived': archived,
        });
      }
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchProductSnapshot(
      String cropID) async {
    // Reference to your UserCarts collection
    CollectionReference<Map<String, dynamic>> userCartsRef =
        FirebaseFirestore.instance.collection('UserCarts');

    // Get the document reference for the current product
    DocumentReference<Map<String, dynamic>> currentProductRef =
        userCartsRef.doc(cropID);

    // Fetch the current product's data
    DocumentSnapshot<Map<String, dynamic>> currentProductSnapshot =
        await currentProductRef.get();

    return currentProductSnapshot;
  }

  String generateRoomName(String currentUserUID, String selectedUserUID) {
    String roomName = currentUserUID.compareTo(selectedUserUID) < 0
        ? '$currentUserUID and $selectedUserUID'
        : '$selectedUserUID and $currentUserUID';
    print("Room Name: $roomName"); // Print the room name to the console
    return roomName;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance; // Define _auth here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFA9AF7E),
          centerTitle: false,
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
        ),
        body: ListView(padding: EdgeInsets.all(10), children: [
          Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${productData['image']}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          '${productData['cropName']}',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Price: ',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${productData['price']}',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'Quantity: ',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${productData['quantity']}',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'Unit: ',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${productData['unit']}',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'Farmer: ',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${productData['fullname']}',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '${productData['description']}',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: Text(
                                '${productData['cropID']}',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    // Ensure that the user is authenticated
                                    if (_auth.currentUser != null) {
                                      String roomName = generateRoomName(
                                        _auth.currentUser!
                                            .uid, // Use _auth.currentUser!
                                        '${productData['uid']}', // Farmer's UID from product data
                                      );
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ChatAgriScreen(
                                            fullname:
                                                '${productData['fullname']}',
                                            roomName:
                                                roomName, // Pass the generated roomName
                                            currentUserUid: _auth.currentUser!
                                                .uid, // Use _auth.currentUser!
                                            farmerUid: '${productData['uid']}',
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Handle the case when the user is not authenticated (show an error or redirect to the login screen)
                                    }
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                      BorderSide(
                                        color: Color(0xFF9DC08B),
                                      ),
                                    ),
                                    foregroundColor: MaterialStateProperty.all(
                                      Color(0xFF9DC08B),
                                    ),
                                  ),
                                  child: Text(
                                    'Chat Now',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Regular',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () async {
                                    String cropID = productData['cropID'];

                                    // Reference to your UserCarts collection
                                    CollectionReference<Map<String, dynamic>>
                                        userCartsRef = FirebaseFirestore
                                            .instance
                                            .collection('UserCarts');

                                    // Get the document reference for the current product
                                    DocumentReference<Map<String, dynamic>>
                                        currentProductRef =
                                        userCartsRef.doc(cropID);

                                    // Fetch the current product's data
                                    DocumentSnapshot<Map<String, dynamic>>
                                        currentProductSnapshot =
                                        await currentProductRef.get();
                                    await transferData(currentProductSnapshot);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => AddToCart(),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                      BorderSide(
                                        color: Color(0xFF9DC08B),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Regular',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    String cropID = productData['cropID'];
                                    DocumentSnapshot<Map<String, dynamic>>
                                        currentProductSnapshot =
                                        await fetchProductSnapshot(cropID);
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (innerContext) => Builder(
                                              builder: (BuildContext
                                                      scaffoldContext) =>
                                                  Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                child: BuyNowModal(
                                                  cropID:
                                                      '${productData['cropID']}',
                                                  imageUrl:
                                                      '${productData['image']}',
                                                  price:
                                                      '₱${productData['price']}',
                                                  quantity:
                                                      '${productData['quantity']}',
                                                  initialBoughtQuantity: 1,
                                                  documentSnapshot:
                                                      currentProductSnapshot,
                                                  scaffoldContext:
                                                      scaffoldContext,
                                                  transferDataCallback:
                                                      transferData,
                                                ),
                                              ),
                                            ));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF9DC08B),
                                    ),
                                  ),
                                  child: Text(
                                    'BUY NOW',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontFamily: "Poppins"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]))
        ]));
  }
}

class BuyNowModal extends StatefulWidget {
  final String cropID;
  final String imageUrl;
  final String price;
  final String quantity;
  final int initialBoughtQuantity;
  final DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  final BuildContext scaffoldContext;
  final void Function(DocumentSnapshot<Map<String, dynamic>>)
      transferDataCallback;

  BuyNowModal({
    required this.cropID,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.initialBoughtQuantity,
    required this.documentSnapshot,
    required this.scaffoldContext,
    required this.transferDataCallback,
  });

  @override
  _BuyNowModalState createState() => _BuyNowModalState();
}

class _BuyNowModalState extends State<BuyNowModal> {
  final CollectionReference _userCarts =
      FirebaseFirestore.instance.collection('UserCarts');
  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');
  final CollectionReference _buyNow =
      FirebaseFirestore.instance.collection('BuyNow');
  final currentUser = FirebaseAuth.instance.currentUser;
  List<Map>? items;
  late TextEditingController boughtQuantityController;
  late int currentBoughtQuantity;
  late int maxAvailableStock;

  @override
  void initState() {
    super.initState();
    currentBoughtQuantity = widget.initialBoughtQuantity;
    boughtQuantityController =
        TextEditingController(text: currentBoughtQuantity.toString());

    maxAvailableStock = int.parse(widget.quantity);
  }

  @override
  void dispose() {
    boughtQuantityController.dispose();
    super.dispose();
  }

  void showAlertDialog(String message) {
    showDialog(
      context: widget.scaffoldContext,
      builder: (BuildContext context) {
        return CustomAlertDialog(message: message);
      },
    );
  }

  void incrementBoughtQuantity() {
    setState(() {
      if (currentBoughtQuantity < maxAvailableStock) {
        currentBoughtQuantity++; // Increment the quantity
        boughtQuantityController.text =
            currentBoughtQuantity.toString(); // Update the text field
      } else {
        showAlertDialog(
            'Cannot add more items. Product is limited up to stocks only');
      }
    });
  }

  void decrementBoughtQuantity() {
    if (currentBoughtQuantity > 1) {
      setState(() {
        currentBoughtQuantity--; // Decrement the quantity, but keep it at least 1
        boughtQuantityController.text =
            currentBoughtQuantity.toString(); // Update the text field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                widget.imageUrl,
                height: 100.0,
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.price,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Stocks:',
                        style: TextStyle(
                            fontSize: 16.0, fontFamily: "Poppins-Regular"),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        widget.quantity,
                        style: TextStyle(
                            fontSize: 16.0, fontFamily: "Poppins-Regular"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove,
                  size: 16,
                ),
                onPressed: () {
                  decrementBoughtQuantity();
                },
              ),
              SizedBox(
                width: 55, // Set your desired width
                height: 25, // Set your desired height
                child: TextFormField(
                  controller: boughtQuantityController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add,
                  size: 16,
                ),
                onPressed: () {
                  incrementBoughtQuantity();
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              await transferBuyNow(widget.documentSnapshot);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuyNowCheckoutScreen(),
                ),
              ); // Pass the document snapshot to the function
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xFF9DC08B),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(400.0, 40.0),
              ),
            ),
            child: Text(
              'BUY NOW',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> transferBuyNow(
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
  ) async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String buid = currentUser.uid; // Get the UID of the current user

      String cropID = widget.cropID;

      // Reference to your Marketplace collection
      CollectionReference<Map<String, dynamic>> marketplaceRef =
          FirebaseFirestore.instance.collection('Marketplace');

      // Query the Marketplace collection for the document with matching cropID
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await marketplaceRef.where('cropID', isEqualTo: cropID).get();

      // Check if a document with a matching cropID exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document with the matching cropID
        DocumentSnapshot<Map<String, dynamic>> marketplaceDoc =
            querySnapshot.docs.first;

        // Extract data from the Marketplace document
        String cropName = marketplaceDoc['cropName'];
        String location = marketplaceDoc['location'];
        String category = marketplaceDoc['category'];
        String unit = marketplaceDoc['unit'];
        String price = marketplaceDoc['price'];
        String fullname = marketplaceDoc['fullname'];
        String quantity = marketplaceDoc['quantity'];
        String imageUrl = marketplaceDoc['image'];
        String uid = marketplaceDoc['uid'];
        bool archived = marketplaceDoc['archived'] as bool;

        // Other data you want to extract

        DateTime currentDate = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
        String boughtQuantity = currentBoughtQuantity.toString();
        bool isChecked = true;
        String totalCost =
            (currentBoughtQuantity * double.parse(price)).toString();

        // Reference to your UserCarts collection
        CollectionReference<Map<String, dynamic>> buyNowRef =
            FirebaseFirestore.instance.collection('BuyNow');

        // Create a new document in UserCarts collection with the extracted data
        await buyNowRef.add({
          'uid': uid,
          'buid': buid,
          'cropID': cropID,
          'cropName': cropName,
          'location': location,
          'category': category,
          'unit': unit,
          'price': price,
          'fullname': fullname,
          'quantity': quantity,
          'image': imageUrl,
          'dateBought': formattedDate,
          'boughtQuantity': boughtQuantity,
          'isChecked': isChecked,
          'archived': archived,
          'totalCost': totalCost,
          // Add other data you want to transfer
        });
      }
    }
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String message;

  CustomAlertDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Alert'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
