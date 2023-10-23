import 'package:capstone/buyer/add_to_cart.dart';
import 'package:capstone/buyer/checkout.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Future<void> transferData(DocumentSnapshot documentSnapshot) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? uid = user?.uid;

    String cropID = productData['cropID'] ?? '';
    String cropName = productData['cropName'] ?? '';
    String location = productData['location'] ?? '';
    String category = productData['category'] ?? '';
    String unit = productData['unit'] ?? '';
    String price = productData['price'] ?? '';
    String quantity = productData['quantity'] ?? '';
    String boughtQuantity = productData['boughtQuantity'] ?? '';
    String imageUrl = productData['image'] ?? '';

    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    await _userCarts.add({
      "uid": uid,
      'cropID': cropID,
      'cropName': cropName,
      'location': location,
      'category': category,
      'unit': unit,
      'price': price,
      'boughtQuantity': boughtQuantity + 1.toString(),
      'quantity': quantity,
      'image': imageUrl,
      'dateBought': formattedDate,
    });
  }

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
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
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
                                  onPressed: () {},
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
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CheckoutScreen(),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF9DC08B),
                                    ),
                                  ),
                                  child: Text(
                                    'BUY NOW',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
