import 'package:capstone/buyer/transactions_screen.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFA9AF7E),
      ),
      home: CheckoutScreen(),
    );
  }
}

GlobalKey<AnimatedListState> listKey = GlobalKey();

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CollectionReference _user =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');
  final CollectionReference _userCarts =
      FirebaseFirestore.instance.collection('UserCarts');

  final currentUser = FirebaseAuth.instance;
  AuthService authService = AuthService();
  TextEditingController _fullnameController = TextEditingController();

  double totalPayment = 0.0;
  String selectedPaymentMethod = 'Select Payment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              stream: FirebaseFirestore.instance
                  .collection('Marketplace')
                  .where('uid')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  QueryDocumentSnapshot userData = snapshot.data!.docs.first;
                  String fullName = userData.get('fullname').toString();

                  return Text(
                    _fullnameController.text,
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 15.5,
                      color: Colors.black,
                    ),
                  );
                } else {
                  return Text("No data available");
                }
              },
            ),
            Card(
              elevation: 3.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _userCarts
                        .where('uid', isEqualTo: currentUser.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!snapshot.hasData) {
                        return Text("No items in your cart.");
                      }

                      // Initialize totalCost to 0.0 here
                      double totalCost = 0.0;

                      // Build a list of product items in the cart and calculate the total cost.
                      List<Widget> cartItems = snapshot.data!.docs
                          .where((cartItem) => cartItem['isChecked'] == true)
                          .map((cartItem) {
                        double price =
                            double.tryParse(cartItem['price'] ?? '0.0') ?? 0.0;
                        int itemQuantity =
                            int.tryParse(cartItem['boughtQuantity'] ?? '0') ??
                                0;

                        // Calculate the total cost for this item and add it to the totalCost.
                        totalCost += price * itemQuantity;

                        return _buildCartItem(
                          cartItem['cropName'],
                          price,
                          itemQuantity,
                          cartItem['image'],
                          'Poppins-Regular',
                        );
                      }).toList();

                      // totalCost now holds the correct total cost, update totalPayment.
                      totalPayment = totalCost;

                      return Column(
                        children: cartItems,
                      );
                    },
                  ),
                ],
              ),
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

  Widget _buildCartItem(String name, double price, int quantity,
      String productImageAsset, String fontFamily) {
    return ListTile(
      leading: Image.network(
        productImageAsset,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
      title: Text(
        name,
        style: TextStyle(fontSize: 16.0, fontFamily: fontFamily),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price: ₱${price.toStringAsFixed(2)}',
          ),
          Text('Quantity: $quantity', style: TextStyle(fontFamily: fontFamily)),
        ],
      ),
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
}
