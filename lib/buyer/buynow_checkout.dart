import 'package:capstone/buyer/transactions_screen.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                    groupedCartItems.values.map((cartItems) {
                  double groupTotalCost = 0.0;

                  List<Widget> cartItemsWidgets = cartItems
                      .where((cartItem) => cartItem['isChecked'] == true)
                      .map((cartItem) {
                    double price =
                        double.tryParse(cartItem['price'] ?? '0.0') ?? 0.0;
                    int itemQuantity =
                        int.tryParse(cartItem['boughtQuantity'] ?? '0') ?? 0;

                    // Calculate the total cost for this item and add it to groupTotalCost.
                    groupTotalCost += price * itemQuantity;

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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TransactionBuyer(),
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

  void saveOrderToFirestore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case when the user is not authenticated
      return;
    }

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Get the cart items to save
    List<Map<String, dynamic>> cartItemsToSave = [];

    // Create a batch to perform a batched write
    WriteBatch batch = FirebaseFirestore.instance.batch();

    final cartItemsQuery = await _buyNow
        .where('buid', isEqualTo: currentUser.uid)
        .where('cropID', isEqualTo: 'cropID')
        .get();

    if (cartItemsQuery.docs.isNotEmpty) {
      cartItemsQuery.docs.forEach((cartItem) {
        if (cartItem['isChecked']) {
          final cartItemData = cartItem.data() as Map<String, dynamic>;

          // Check if the cartItem's cropID matches the desired cropID
          if (cartItemData['cropID'] == cartItemData['cropID']) {
            // Create a map for the item
            Map<String, dynamic> item = {
              'cropName': cartItemData['cropName'],
              'uid': cartItemData['uid'],
              'boughtQuantity': cartItemData['boughtQuantity'],
              'price': cartItemData['price'],
              'unit': cartItemData['unit'],
              'quantity': cartItemData['quantity'],
              'location': cartItemData['location'],
              'fullname': cartItemData['fullname'],
              'totalCost': cartItemData['totalCost'],
              'image': cartItemData['imageUrl'],
              'cropID': cartItemData['cropID'],
              'buid': cartItemData['buid'],
              'status': 'pending',
              // Add other item properties here
            };
            cartItemsToSave.add(item);

            // Delete the item from the userCarts collection
            batch.delete(cartItem.reference);
          }
        }
      });

      // Create an order document
      final transactionDoc = _transaction.doc();

      batch.set(
        transactionDoc,
        {
          'buid': currentUser.uid,
          'paymentMethod': selectedPaymentMethod,
          'totalPayment': totalPayment,
          'timestamp': currentDate,
          'cartItems': cartItemsToSave,
        },
      );

      // Commit the batched write to Firestore
      await batch.commit();
    }
  }
}
