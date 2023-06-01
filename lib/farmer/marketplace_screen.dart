import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MarketplaceItem {
  final String title;
  final String price;
  final String farmer;
  final String description;
  final String imageUrl;

  MarketplaceItem({
    required this.title,
    required this.price,
    required this.farmer,
    required this.description,
    required this.imageUrl,
  });
}

class MarketplaceScreen extends StatefulWidget {
  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final _postController = TextEditingController();
  bool _isButtonVisible = true;
  File? _selectedImage;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  final List<MarketplaceItem> items = [
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Arriane Gatpo',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Daniella Tungol',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 4500',
      farmer: 'Marievic Añes',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Jenkins Mesina',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Romeo London',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'AgriPinas Mobile and Web',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
  ];
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
        body: GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 10,
            childAspectRatio: 2 / 3,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {},
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          item.imageUrl,
                          fit: BoxFit.cover,
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
                              item.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item.price,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item.farmer,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item.description,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          right: 16.0,
          bottom: _isButtonVisible ? 16.0 : -100.0,
          child: MouseRegion(
            onEnter: (_) {
              setState(() {
                _isButtonVisible = true;
              });
            },
            onExit: (_) {
              setState(() {
                _isButtonVisible = false;
              });
            },
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 16.0),
                            Center(
                              child: Text(
                                'Add New Product',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Add photo: ',
                                  style: TextStyle(
                                    fontSize: 16.5,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _selectImage,
                                  icon: Icon(Icons.image),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            _selectedImage != null
                                ? Image.file(
                                    _selectedImage!,
                                    width: 100,
                                    height: 100,
                                  )
                                : SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                labelText: "Crop's Name",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA9AF7E)),
                                ),
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Price',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA9AF7E)),
                                ),
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: "Farmer's Name",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA9AF7E)),
                                ),
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA9AF7E)),
                                ),
                              ),
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
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('Add'),
                                  onPressed: () {
                                    String postContent = _postController.text;
                                    print(postContent);
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(157, 192, 139, 1),
                                    onPrimary: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Color.fromRGBO(157, 192, 139, 1),
            ),
          ),
        ));
  }
}
