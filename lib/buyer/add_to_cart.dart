import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddToCart(),
    ),
  );
}

class AddToCart extends StatefulWidget {
  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String? selectedStatus;
  late TabController _tabController;

  final CollectionReference _userCarts =
      FirebaseFirestore.instance.collection('UserCarts');
  final currentUser = FirebaseAuth.instance.currentUser;

  List<bool> isCheckedList = [];

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

  void searchItem(String text) {
    setState(() {
      _searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFA9AF7E),
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
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: 200.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onChanged: searchItem,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            _userCarts.where('uid', isEqualTo: currentUser?.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasError) {
            return Center(
              child: Text('Some error occurred ${streamSnapshot.error}'),
            );
          }
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          }

          QuerySnapshot<Object?>? querySnapshot = streamSnapshot.data;
          List<QueryDocumentSnapshot<Object?>>? documents = querySnapshot?.docs;
          List<Map>? items = documents?.map((e) => e.data() as Map).toList();

          isCheckedList = List.generate(items!.length, (index) => false);

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '',
                      style: TextStyle(
                        fontSize: 15.0,
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
                      '     Shopping Cart',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Poppins-Bold',
                      ),
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
                        fontSize: 5.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map thisItem = items[index];
                    bool isChecked = isCheckedList[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${thisItem['farmer']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: 100,
                                  height: 95,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      '${thisItem['image']}',
                                      width: double.infinity,
                                      height: 250,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 0),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 45),
                                  Row(
                                    children: [
                                      Text(
                                        'Item Name: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Poppins'),
                                      ),
                                      Text(
                                        '${thisItem['cropName']}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Price: ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        '${thisItem['price']}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              size: 16,
                                            ),
                                            onPressed: () {
                                              int quantity =
                                                  thisItem['quantity'];
                                              if (quantity > 1) {
                                                setState(() {
                                                  quantity--;
                                                  thisItem['quantity'] =
                                                      quantity;
                                                });
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        'Delete Item?',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 19,
                                                        ),
                                                      ),
                                                      content: Text(
                                                        'Do you want to delete this item?',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
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
                                                            'Yes',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                              color: Color(
                                                                  0xFF9DC08B),
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _deleteItem(
                                                                '${thisItem['cropName']}');
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
                                          Text(
                                            thisItem['quantity'].toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              size: 16,
                                            ),
                                            onPressed: () {
                                              int quantity =
                                                  thisItem['quantity'];
                                              setState(() {
                                                quantity++;
                                                thisItem['quantity'] = quantity;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isCheckedList[index] = value!;
                                });
                              },
                              activeColor: Color(0xFF9DC08B),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteItem('${thisItem['cropName']}');
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total Items: ${items.length}',
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Total Amount: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '₱${calculateTotalCost(items)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF27AE60),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double calculateTotalCost(List<Map>? items) {
    double totalCost = 0;

    for (int i = 0; i < items!.length; i++) {
      if (isCheckedList[i]) {
        int quantity = items[i]['quantity'];
        double unitPrice = double.parse(items[i]['price']
            .toString()
            .replaceAll('₱', '')
            .replaceAll('Php', '')
            .replaceAll(',', ''));
        totalCost += quantity * unitPrice;
      }
    }
    return totalCost;
  }

  void _deleteItem(String cropName) {
    setState(() {
      // Remove the item from the database
      _userCarts
          .doc(currentUser!.uid)
          .collection('items')
          .doc(cropName)
          .delete();
    });
  }
}
