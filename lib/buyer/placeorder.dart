import 'package:capstone/buyer/transactions_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlaceOrder',
      theme: ThemeData(),
      home: PlaceOrder(),
    );
  }
}

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final List<String> _items = ['Onion', 'Corn', 'Rice', 'Eggplant'];
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  TextEditingController _cropNameController = TextEditingController();
  TextEditingController _farmerNameController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _packagingController = TextEditingController();
  TextEditingController _kilogramPerUnitController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void searchItem(String text) {
    setState(() {
      _searchText = text;
    });
  }

  void editCropDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chat'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _cropNameController,
                  decoration: InputDecoration(labelText: 'Crop Name'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _farmerNameController,
                  decoration: InputDecoration(labelText: 'Farmer Name'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _packagingController,
                  decoration: InputDecoration(labelText: 'Packaging'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _kilogramPerUnitController,
                  decoration: InputDecoration(labelText: 'Kilogram per Unit'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchText = _cropNameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF42931B),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredItems = _items
        .where((item) => item.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

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
                fontWeight: FontWeight.bold,
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
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (BuildContext context, int index) {
                  String cropName = filteredItems[index];

                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cropName,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/onion.png',
                                  width: 150.0,
                                  height: 100.0,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  '\n\n\n\n\nFarmer: ${_farmerNameController.text}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  '                                             Category: ${_categoryController.text}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  '                                             Packaging: ${_packagingController.text}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  '                                             Kilogram per unit: ${_kilogramPerUnitController.text}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  '                                             Description: ${_descriptionController.text}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                Column(
                                  children: [
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.check_outlined),
                                      label: Text('PLACEORDER'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF9DC08B),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransactionBuyer()));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
