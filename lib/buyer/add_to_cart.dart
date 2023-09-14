import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddToCart(),
    ),
  );
}

class ShoppingCartItem {
  final String pendingitemname;
  final String rcategory;
  final String dateordered;
  final String unitprice;
  int quantity;
  final String farmername;
  final String imageUrl;

  ShoppingCartItem({
    required this.pendingitemname,
    required this.rcategory,
    required this.dateordered,
    required this.unitprice,
    required this.quantity,
    required this.farmername,
    required this.imageUrl,
  });
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
  bool _isButtonVisible = true;
  late TabController _tabController;
  final _postController = TextEditingController();

  final List<ShoppingCartItem> items = [
    ShoppingCartItem(
      pendingitemname: 'Onion',
      rcategory: 'Vegetable',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: 5,
      farmername: 'Ryan Amador',
      imageUrl: 'assets/onion.png',
    ),
    ShoppingCartItem(
      pendingitemname: 'Tomato',
      rcategory: 'Vegetable',
      dateordered: '07 / 07 / 2023',
      unitprice: '₱400',
      quantity: 2,
      farmername: 'Arriane Gatpo',
      imageUrl: 'assets/onion.png',
    ),
    ShoppingCartItem(
      pendingitemname: 'Tomato',
      rcategory: 'Vegetable',
      dateordered: '07 / 07 / 2023',
      unitprice: '₱500',
      quantity: 2,
      farmername: 'Marievic Anes',
      imageUrl: 'assets/onion.png',
    ),
  ];

  List<bool> isCheckedList = List.generate(3, (index) => false);

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
      body: Column(
        children: [
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
                  '     Shopping Cart',
                  style: TextStyle(fontSize: 20.0, fontFamily: 'Poppins-Bold'),
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
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                bool isChecked = isCheckedList[index];
                double totalCostForItem = item.quantity *
                    double.parse(item.unitprice
                        .replaceAll('₱', '')
                        .replaceAll('Php', '')
                        .replaceAll(',', ''));

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
                              item.farmername,
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
                                child: Image.asset(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
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
                                        fontSize: 13, fontFamily: 'Poppins'),
                                  ),
                                  Text(
                                    '${item.pendingitemname}',
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
                                    '${item.unitprice}',
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
                                          if (item.quantity > 1) {
                                            setState(() {
                                              item.quantity--;
                                            });
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Delete Item?',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 19),
                                                  ),
                                                  content: Text(
                                                    'Do you want to delete this item?',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 15),
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
                                                                Colors.black),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
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
                                                            fontSize: 15),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _deleteItem(index);
                                                        });
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
                                        '${item.quantity}',
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
                                          setState(() {
                                            item.quantity++;
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
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteItem(index);
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
                      '₱${calculateTotalCost()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF27AE60),
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String calculateTotalCost() {
    double totalCost = 0;
    for (int i = 0; i < items.length; i++) {
      if (isCheckedList[i]) {
        int quantity = items[i].quantity;
        double unitPrice = double.parse(items[i]
            .unitprice
            .replaceAll('₱', '')
            .replaceAll('Php', '')
            .replaceAll(',', ''));
        totalCost += quantity * unitPrice;
      }
    }
    return '${totalCost.toStringAsFixed(2)}';
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      isCheckedList.removeAt(index);
    });
  }
}
