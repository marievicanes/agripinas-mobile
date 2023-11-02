import 'package:capstone/buyer/message.dart';
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
      child: MyApp(
        cartItem: {},
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Map cartItem;

  MyApp({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: BuyerTransactionDetails(
        cartItem,
      ),
    );
  }
}

class BuyerTransactionDetails extends StatefulWidget {
  final Map cartItem;
  const BuyerTransactionDetails(this.cartItem);

  @override
  _BuyerTransactionDetailsState createState() =>
      _BuyerTransactionDetailsState();
}

TextEditingController _cropNameController = TextEditingController();
TextEditingController _contentController = TextEditingController();

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final CollectionReference _userCarts =
    FirebaseFirestore.instance.collection('UserCarts');
final CollectionReference _transaction =
    FirebaseFirestore.instance.collection('Transaction');
final CollectionReference _reports =
    FirebaseFirestore.instance.collection('Reports');

final currentUser = FirebaseAuth.instance.currentUser;
AuthService authService = AuthService();

class _BuyerTransactionDetailsState extends State<BuyerTransactionDetails> {
  String paymentMethod = '';

  @override
  void initState() {
    super.initState();
    // Replace 'yourTransactionId' with the actual transaction ID associated with the cartItem
    final cropID = widget.cartItem['cropID'];

    // Retrieve the payment method from the transaction collection
    _transaction.doc(cropID).get().then((transactionSnapshot) {
      if (transactionSnapshot.exists) {
        setState(() {
          paymentMethod = transactionSnapshot['paymentMethod'];
        });
      }
    });
  }

  Future<void> _report([DocumentSnapshot? documentSnapshot]) async {
    String cropID = widget.cartItem['cropID'];
    String cropName = widget.cartItem['cropName'];
    String sellerFullname = widget.cartItem['fullname'];
    String selleruid = widget.cartItem['uid'];
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to rebuild the widget when the keyboard is displayed
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, // Adjust for the keyboard
                  left: 16.0, // Add left padding
                  right: 16.0, // Adjust for the keyboard
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 16.0),
                      Center(
                        child: Text(
                          'Report Product',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      TextFormField(
                        maxLines: 1,
                        enabled: false,
                        controller: TextEditingController(text: cropName),
                        decoration: InputDecoration(
                          labelText: "Product",
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 15.5,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                          ),
                        ),
                      ),
                      TextFormField(
                        maxLines: 1,
                        enabled: false,
                        controller: TextEditingController(text: sellerFullname),
                        decoration: InputDecoration(
                          labelText: "Seller's Full Name",
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 15.5,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                          ),
                        ),
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: _contentController,
                        decoration: InputDecoration(
                          labelText: "Details",
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 15.5,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFA9AF7E),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Details is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final String content = _contentController.text;
                                DateTime currentDate = DateTime.now();
                                String formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(currentDate);

                                FirebaseAuth auth = FirebaseAuth.instance;
                                User? user = auth.currentUser;
                                if (cropName != null) {
                                  String? buid = user?.uid;
                                  await _reports.add({
                                    "buid": buid,
                                    "uid": selleruid,
                                    "content": content,
                                    "timestamp": formattedDate,
                                    "cropName": cropName,
                                    "fullname": sellerFullname,
                                    "cropID": cropID,
                                  });
                                  _contentController.text = '';

                                  Navigator.of(context).pop();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(157, 192, 139, 1),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map cartItem = widget.cartItem;
    double price = double.tryParse(cartItem['price']) ?? 0.0;
    int boughtQuantity = int.tryParse(cartItem['boughtQuantity']) ?? 0;
    double orderTotal = price * boughtQuantity;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        centerTitle: false,
        title: Row(
          children: [
            SizedBox(width: 8.0),
            Text(
              'Order Details',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 8.0),
                    ],
                  ),
                ],
              ),
              Text(
                'Order Completed',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              SizedBox(height: 7.0),
              Text(
                'Thank you for Shopping with AgriPinas!',
                style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 14),
              ),
              SizedBox(height: 20.0),
              Divider(),
              Text(
                'Shipping Information',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
              ),
              Card(
                elevation: 3.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildCartShippingInfo(
                        '', 'Item has been received', 'Poppins-Regular'),
                  ],
                ),
              ),
              Divider(),
              Text(
                'Seller: ${cartItem['fullname']}',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
              ),
              Card(
                elevation: 3.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildCartItem(
                      cartItem['cropName'],
                      cartItem['price'],
                      cartItem['boughtQuantity'],
                      cartItem['imageUrl'],
                      'Poppins-Regular',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Divider(),
              _buildPaymentInfo('Order Total:',
                  '₱${orderTotal.toStringAsFixed(2)}', 'Poppins-Regular'),
              SizedBox(height: 16.0),
              Divider(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.4, // Adjust the width as needed
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Message(),
                            ));
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(color: Color(0xFF9DC08B)),
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Color(0xFF9DC08B)),
                      ),
                      child: Text(
                        'Chat Seller',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins-Regular',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      onPressed: () => _report(),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFF9DC08B),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'REPORT PRODUCT',
                            style: TextStyle(
                              fontSize: 14.5,
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, String price, String boughtQuantity,
      String imageUrl, String fontFamily) {
    double parsedPrice = double.tryParse(price) ?? 0.0;
    int parsedBoughtQuantity = int.tryParse(boughtQuantity) ?? 0;
    return ListTile(
      leading: Image.network(
        imageUrl,
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
            'Price: ₱${parsedPrice.toStringAsFixed(2)}', // Display the price as currency
          ),
          Text('Quantity: $parsedBoughtQuantity',
              style: TextStyle(fontFamily: fontFamily)),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(
    String label,
    String value,
    String fontFamily,
  ) {
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

  Widget _buildCartShippingInfo(
      String label, String paymentMethod, String fontFamily) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            paymentMethod,
            style: TextStyle(
              fontSize: 14,
              fontFamily: fontFamily,
              color: Color(0xFFA9AF7E),
            ),
          ),
        ],
      ),
    );
  }
}
