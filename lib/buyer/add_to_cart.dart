import 'package:capstone/buyer/checkout.dart';
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

GlobalKey<AnimatedListState> listKey = GlobalKey();

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
  int totalBoughtQuantity = 0;
  int totalItems = 0;
  double totalAmount = 0.0;

  final CollectionReference _userCarts =
      FirebaseFirestore.instance.collection('UserCarts');
  final currentUser = FirebaseAuth.instance.currentUser;

  Set<String> selectedItems = Set<String>();
  List<Map>? items;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    resetIsCheckedForAllItems();
    super.dispose();
  }

  void searchItem(String text) {
    setState(() {
      _searchText = text;
    });
  }

  bool isAnyItemSelected() {
    return selectedItems.isNotEmpty;
  }

  void resetIsCheckedForAllItems() async {
    final querySnapshot =
        await _userCarts.where('buid', isEqualTo: currentUser?.uid).get();
    for (final doc in querySnapshot.docs) {
      await _userCarts.doc(doc.id).update({'isChecked': false});
    }
  }

  void toggleItemSelection(String itemId) {
    final selected = !selectedItems.contains(itemId);
    setState(() {
      selectedItems.contains(itemId)
          ? selectedItems.remove(itemId)
          : selectedItems.add(itemId);
      // Update isChecked based on the new selected state.
      updateIsChecked(itemId, selected);

      // Recalculate totals based on the current selected items
      updateTotals();
    });
  }

// Function to update isChecked in Firebase
  void updateIsChecked(String itemId, bool isChecked) async {
    final documentSnapshot = await _userCarts.doc(itemId).get();
    if (documentSnapshot.exists) {
      try {
        await _userCarts.doc(itemId).update({
          'isChecked': isChecked,
        });
        // Successfully updated isChecked, now update the totals.
        updateTotals();
      } catch (e) {
        print('Error updating isChecked: $e');
      }
    } else {
      print('Document not found for docId: $itemId');
    }
  }

  // Function to update totalAmount and totalBoughtQuantity
  void updateTotals() {
    double updatedTotalAmount = 0.0;
    int updatedTotalBoughtQuantity = 0;

    for (final item in items!) {
      bool isChecked = item['isChecked'] ?? false;

      if (isChecked) {
        int boughtQuantity =
            int.tryParse(item['boughtQuantity'].toString()) ?? 0;
        double price = double.tryParse(item['price'].toString()) ?? 0.0;
        updatedTotalAmount += boughtQuantity * price;
        updatedTotalBoughtQuantity += boughtQuantity;
      }
    }

    setState(() {
      totalAmount = updatedTotalAmount;
      totalBoughtQuantity = updatedTotalBoughtQuantity;
    });
  }

  Future<void> _updateBoughtQuantity(
      DocumentSnapshot? documentSnapshot, String boughtQuantity) async {
    final document = await _userCarts.doc(documentSnapshot!.id).get();
    if (document.exists) {
      try {
        await _userCarts.doc(documentSnapshot.id).update({
          'boughtQuantity': boughtQuantity,
        });
      } catch (e) {
        print('Error updating boughtQuantity: $e');
      }
    } else {
      // Handle the case where the document doesn't exist.
      print('Document not found for docId: $documentSnapshot');
    }
    updateTotals(); // Call updateTotals after updating boughtQuantity.
  }

  Future<void> _updateTotalCostPlus(DocumentSnapshot? documentSnapshot,
      String boughtQuantity, String price) async {
    final document = await _userCarts.doc(documentSnapshot!.id).get();
    if (document.exists) {
      int boughtQuantity =
          int.tryParse(document.get('boughtQuantity').toString()) ?? 0;
      double price = double.tryParse(document.get('price').toString()) ?? 0.0;

      double totalCost = boughtQuantity * price + price;
      String totalCostString = totalCost.toStringAsFixed(2);

      try {
        await _userCarts.doc(documentSnapshot.id).update({
          'totalCost': totalCostString,
        });
      } catch (e) {
        print('Error updating totalCost: $e');
      }
    } else {
      // Handle the case where the document doesn't exist.
      print('Document not found for docId: $documentSnapshot');
    }
    updateTotals(); // Call updateTotals after updating totalCost.
  }

  Future<void> _updateTotalCostMinus(DocumentSnapshot? documentSnapshot,
      String boughtQuantity, String price) async {
    final document = await _userCarts.doc(documentSnapshot!.id).get();
    if (document.exists) {
      int boughtQuantity =
          int.tryParse(document.get('boughtQuantity').toString()) ?? 0;
      double price = double.tryParse(document.get('price').toString()) ?? 0.0;

      double totalCost = boughtQuantity * price - price;
      String totalCostString = totalCost.toStringAsFixed(2);

      try {
        await _userCarts.doc(documentSnapshot.id).update({
          'totalCost': totalCostString,
        });
      } catch (e) {
        print('Error updating totalCost: $e');
      }
    } else {
      // Handle the case where the document doesn't exist.
      print('Document not found for docId: $documentSnapshot');
    }
    updateTotals(); // Call updateTotals after updating totalCost.
  }

  Future<void> _delete(
    String cropID,
  ) async {
    await _userCarts.doc(cropID).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted an item in your cart')));
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
            const SizedBox(width: 8.0),
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
                decoration: const InputDecoration(
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
            _userCarts.where('buid', isEqualTo: currentUser?.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasError) {
            return Center(
              child: Text('Error: ${streamSnapshot.error}'),
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
          items = documents?.map((e) => e.data() as Map).toList();
          List.generate(items!.length, (index) => false);

          return Column(
            children: [
              const Row(
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
              const Row(
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
              const Row(
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
                  itemCount: items?.length ?? 0,
                  key: listKey,
                  itemBuilder: (BuildContext context, int index) {
                    final Map thisItem = items![index];
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    final String itemId = documentSnapshot.id;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
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
                                      const Text(
                                        'Item: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Poppins'),
                                      ),
                                      Text(
                                        '${thisItem['cropName']}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Text(
                                        'Price: ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        '${thisItem['price']}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          int boughtQuantity = int.parse(
                                              thisItem['boughtQuantity']);
                                          int price = int.parse(
                                              thisItem['price'].toString());
                                          if (boughtQuantity > 1) {
                                            setState(() {
                                              boughtQuantity--;
                                              thisItem['boughtQuantity'] =
                                                  boughtQuantity.toString();
                                            });
                                            // Update the boughtQuantity in Firestore
                                            _updateBoughtQuantity(
                                                documentSnapshot,
                                                boughtQuantity.toString());
                                            _updateTotalCostMinus(
                                                documentSnapshot,
                                                boughtQuantity.toString(),
                                                price.toString());
                                            updateTotals();
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Delete Item?',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 19,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Do you want to delete this item?',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text(
                                                        'No',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                          color:
                                                              Color(0xFF9DC08B),
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _delete(documentSnapshot
                                                            .id);
                                                        Navigator.of(context)
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
                                        thisItem['boughtQuantity'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          int boughtQuantity = int.parse(
                                              thisItem['boughtQuantity']);
                                          int price = int.parse(
                                              thisItem['price'].toString());
                                          int quantity =
                                              int.parse(thisItem['quantity']);
                                          if (boughtQuantity < quantity) {
                                            setState(() {
                                              boughtQuantity++;
                                            });
                                            // Update the boughtQuantity in Firestore
                                            _updateBoughtQuantity(
                                                documentSnapshot,
                                                boughtQuantity.toString());
                                            _updateTotalCostPlus(
                                                documentSnapshot,
                                                boughtQuantity.toString(),
                                                price.toString());
                                            updateTotals();
                                          } else {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Cannot add more items. Limited stocks up to $quantity only',
                                              ),
                                              duration: Duration(seconds: 3),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: selectedItems.contains(itemId),
                              onChanged: (value) {
                                toggleItemSelection(itemId);
                              },
                              activeColor: Color(0xFF9DC08B),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Delete Item?',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 19,
                                        ),
                                      ),
                                      content: const Text(
                                        'Do you want to delete this item?',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 15,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text(
                                            'No',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(
                                            'Yes',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              color: Color(0xFF9DC08B),
                                              fontSize: 15,
                                            ),
                                          ),
                                          onPressed: () {
                                            _delete(documentSnapshot.id);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
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
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Total Items: ',
                          style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                        ),
                        Text(
                          '$totalBoughtQuantity',
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Total Amount: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '₱$totalAmount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF27AE60),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: isAnyItemSelected()
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(),
                                  ),
                                );
                              }
                            : null, // Disable the button if no item is selected
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC0D090),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
