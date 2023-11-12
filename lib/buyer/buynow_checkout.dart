import 'dart:async';

import 'package:capstone/buyer/buyer_pendingtransac.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fil', 'PH')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFA9AF7E),
      ),
      home: BuyNowCheckoutScreen(),
    );
  }
}

GlobalKey<AnimatedListState> listKey = GlobalKey();

class BuyNowCheckoutScreen extends StatefulWidget {
  @override
  _BuyNowCheckoutScreenState createState() => _BuyNowCheckoutScreenState();
}

class _BuyNowCheckoutScreenState extends State<BuyNowCheckoutScreen> {
  final CollectionReference _user =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');
  final CollectionReference _buyNow =
      FirebaseFirestore.instance.collection('BuyNow');
  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('Transaction');

  final currentUser = FirebaseAuth.instance;
  AuthService authService = AuthService();
  TextEditingController _fullnameController = TextEditingController();

  double totalPayment = 0.0;
  String selectedPaymentMethod = 'Select Payment';

  Future<void> deleteBuyNowData() async {
    // Reference to the 'BuyNow' collection
    CollectionReference<Map<String, dynamic>> buyNowRef =
        FirebaseFirestore.instance.collection('BuyNow');

    // Get all documents from the 'BuyNow' collection
    QuerySnapshot<Map<String, dynamic>> buyNowSnapshot = await buyNowRef.get();

    // Loop through the documents and delete each one
    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in buyNowSnapshot.docs) {
      await document.reference.delete();
    }
  }

  late Timer _orderTimer;
  int _hoursRemaining = 2;

  void startOrderTimer(String orderID) {
    // Set up a timer to run every hour
    _orderTimer = Timer.periodic(Duration(minutes: 2), (timer) {
      print(orderID);
      // Update the remaining hours
      setState(() {
        _hoursRemaining--;

        // Check if 12 hours have passed
        if (_hoursRemaining == 1) {
          // Notify the user (you can implement a notification here)
          showNotification('Order Reminder',
              'Your order has been pending for 12 hours. Please pickup within the next 12 hours to avoid automatic cancellation. Thank you!');
        }

        // Check if 24 hours have passed
        if (_hoursRemaining <= 0) {
          // Cancel the timer
          _orderTimer.cancel();

          // Update the order status to "Cancelled"
          updateOrderStatus(orderID, 'Cancelled');

          // Notify the user (you can implement a notification here)
          showNotification('Order Status',
              'Your order has been automatically canceled as it has not been picked up within 24 hours Thank you!');
        }
      });
    });
  }

  void showNotification(String title, String message) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        // Save the notification to Firestore
        await FirebaseFirestore.instance.collection('Notification').add({
          'uid': uid,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'title': title,
        });

        // Print the message (you can remove this if not needed)
        print(message);
      } else {
        print('Current user is null. Notification not saved.');
      }
    } catch (e) {
      print('Error saving notification to Firestore: $e');
    }
  }

  Future<void> updateOrderStatus(String orderID, String status) async {
    try {
      // Fetch the order from Firestore
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Transaction')
          .where(orderID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var orderDoc = querySnapshot.docs[0];

        // Ensure 'orders' field is present and is a List
        if (orderDoc['orders'] is List<dynamic>) {
          // Get the orders array
          List<dynamic> orders = List.from(orderDoc['orders']);

          // Find the order in the array and update its status
          for (int i = 0; i < orders.length; i++) {
            // Assuming each order in the array is a Map
            Map<String, dynamic> order = orders[i];

            // Check if the orderID in the current order matches the target orderID
            if (orderID == orderID) {
              // Update the status of the matched order
              order['status'] = status;

              // Update the orders array in Firestore
              await FirebaseFirestore.instance
                  .collection('Transaction')
                  .doc(orderDoc.id)
                  .update({
                'orders': orders,
              });

              // Notify the user (you can implement a notification here)

              break; // No need to continue searching
            }
          }
        } else {
          print(
              'The "orders" field is not present or is not a List in Firestore.');
        }
      } else {
        print('Document not found for orderID: $orderID');
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            deleteBuyNowData();
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFFA9AF7E),
        centerTitle: false,
        title: Row(
          children: [
            SizedBox(width: 8.0),
            Text(
              'Checkout',
              style: TextStyle(
                fontSize: 17.0,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            StreamBuilder<QuerySnapshot>(
              stream: _buyNow
                  .where('buid', isEqualTo: currentUser.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData) {
                  return Text("No items in your cart.");
                }

                // Calculate the totalPayment here when cart items are loaded
                totalPayment = 0.0; // Reset totalPayment

                // Group cart items by uid
                Map<String, List<QueryDocumentSnapshot>> groupedCartItems = {};

                snapshot.data!.docs.forEach((cartItem) {
                  String uid = cartItem['uid'];
                  if (!groupedCartItems.containsKey(uid)) {
                    groupedCartItems[uid] = [cartItem];
                  } else {
                    groupedCartItems[uid]!.add(cartItem);
                  }
                });

                // Create a list of widgets for each group (unique uid)
                List<Widget> cartItemGroups =
                    groupedCartItems.values.map((orders) {
                  double groupTotalCost = 0.0;

                  List<Widget> cartItemsWidgets = orders
                      .where((cartItem) => cartItem['isChecked'] == true)
                      .map((cartItem) {
                    double price =
                        double.tryParse(cartItem['price'] ?? '0.0') ?? 0.0;
                    int itemQuantity =
                        int.tryParse(cartItem['boughtQuantity'] ?? '0') ?? 0;

                    // Calculate the total cost for this item and add it to groupTotalCost.
                    groupTotalCost = price * itemQuantity;

                    return _buildCartItem(
                        cartItem['cropName'],
                        price,
                        itemQuantity,
                        cartItem['image'],
                        'Poppins-Regular',
                        cartItem['cropID'],
                        cartItem['uid'],
                        cartItem['fullname'],
                        groupTotalCost);
                  }).toList();

                  // Accumulate the groupTotalCost
                  totalPayment += groupTotalCost;
                  return Column(
                    children: [
                      // You can add a title here if needed, e.g., 'Farmer: ${cartItems[0]['fullname']}'
                      // to display the farmer's name.
                      Column(children: cartItemsWidgets),
                      Divider(),
                    ],
                  );
                }).toList();

                return Column(
                  children: cartItemGroups,
                );
              },
            ),
            SizedBox(height: 16.0),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Option:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedPaymentMethod,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPaymentMethod = newValue!;
                        if (newValue != "Select Payment") {
                          selectedPaymentMethod = newValue!;
                        } else {
                          // Optional: You can show a message or handle it in a way that makes sense for your application.
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Invalid Selection'),
                                content: Text(
                                    'Please select a valid payment option.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      });
                    },
                    items: <String>[
                      'Select Payment',
                      'Cash on Pickup',
                      'Sending proof of payment'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 13.5,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            Text(
              'Payment Details:',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
            ),
            _buildPaymentInfo(
                'Payment Method:', '$selectedPaymentMethod', 'Poppins-Regular'),
            _buildPaymentInfo('Total Payment:',
                '₱${totalPayment.toStringAsFixed(2)}', 'Poppins-Regular'),
            SizedBox(height: 16.0),
            Divider(),
            ElevatedButton(
              onPressed: () async {
                String orderID = await saveOrderToFirestore();

                // Start the order timer
                startOrderTimer(orderID);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BuyerPendingRequest(
                      orders: [],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFA9AF7E),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Center(
                child: Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(
      String name,
      double price,
      int quantity,
      String productImageAsset,
      String fontFamily,
      String cropID,
      String uid,
      String fullname,
      double groupTotalCost) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '    Farmer:  $fullname',
          style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: 15.0,
              fontWeight: FontWeight.bold),
        ),
        ListTile(
          leading: Image.network(
            productImageAsset,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          title: Text(
            name,
            style: TextStyle(fontSize: 18.0, fontFamily: fontFamily),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price: ₱${price.toStringAsFixed(2)}',
              ),
              Text('Quantity: $quantity',
                  style: TextStyle(fontFamily: fontFamily)),
              _buildPaymentInfo(
                'Total Amount:',
                '₱${groupTotalCost.toStringAsFixed(2)}',
                'Poppins-Regular',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(String label, String value, String fontFamily) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 15, fontFamily: fontFamily),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<String> saveOrderToFirestore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case when the user is not authenticated
      return '';
    }

    // Get the current date
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    // Get the cart items to save
    List<Map<String, dynamic>> cartItemsToSave = [];
    List<String> cartItemIdsToDelete = [];

    final cartItemsQuery = await _buyNow
        .where('buid', isEqualTo: currentUser.uid)
        .where('isChecked', isEqualTo: true)
        .get();

    String orderID = const Uuid().v4();

    if (cartItemsQuery.docs.isNotEmpty) {
      cartItemsQuery.docs.forEach((cartItem) {
        // Create a map for the item
        Map<String, dynamic> item = {
          'cropName': cartItem['cropName'],
          'category': cartItem['category'],
          'uid': cartItem['uid'],
          'boughtQuantity': cartItem['boughtQuantity'],
          'price': cartItem['price'],
          'unit': cartItem['unit'],
          'quantity': cartItem['quantity'],
          'location': cartItem['location'],
          'fullname': cartItem['fullname'],
          'image': cartItem['image'],
          'cropID': cartItem['cropID'],
          'buid': cartItem['buid'],
          'status': 'Pending',
          'totalCost': cartItem['totalCost'],
          // Add other item properties here
        };
        cartItemsToSave.add(item);
        cartItemIdsToDelete.add(cartItem.id);
      });

      // Create an order document
      await _transaction.add({
        'orderID': orderID,
        'buid': currentUser.uid,
        'paymentMethod': selectedPaymentMethod,
        'dateBought': formattedDate,
        'totalPayment': totalPayment,
        'orders': cartItemsToSave,
      });

      // Delete the cart items
      for (String cartItemId in cartItemIdsToDelete) {
        await _buyNow.doc(cartItemId).delete();
      }
      // Return the orderID
      return orderID;
    }

    // Return an empty string if no orders were found
    return '';
  }
}
