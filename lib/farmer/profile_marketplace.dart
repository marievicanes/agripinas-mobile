import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MarketplaceItem {
  final String title;
  final String price;
  final String location;
  final String description;
  final String imageUrl;

  MarketplaceItem({
    required this.title,
    required this.price,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}

class PostedProducts extends StatefulWidget {
  @override
  _PostedProductsState createState() => _PostedProductsState();
}

class _PostedProductsState extends State<PostedProducts> {
  bool _isButtonVisible = true;
  final _postController = TextEditingController();
  File? _selectedImage;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<MarketplaceItem> filteredItems = [];

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  final List<Map<String, dynamic>> listViewitems = [
    {
      'title': 'Crop Tracker',
      'description': 'Tomato need to harvest',
      'icon': Icons.agriculture_outlined,
    },
    {
      'title': 'Transactions',
      'description': "Ryan Amador's order has been completed.",
      'icon': Icons.money,
    },
    {
      'title': 'Messages',
      'description': 'Arriane Gatpo messaged you',
      'icon': Icons.email_outlined,
    },
  ];

  final List<MarketplaceItem> items = [
    MarketplaceItem(
      title: 'Tomato',
      price: '₱400',
      location: 'Brgy. Bagong Buhay',
      description:
          'The tomato is the edible berry of the plant, commonly known as the tomato plant.',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      location: 'Brgy. Bagong Silang',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      title: 'Calamansi',
      price: '₱400',
      location: 'Brgy. Concepcion',
      description:
          'Calamansi tastes sour with a hint of sweetness, like a mix between a lime and a mandarin',
      imageUrl: 'assets/calamansi.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      location: 'Brgy. Bagong Silang',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      location: 'Brgy. Bagong Silang',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      location: 'Brgy. Bagong Silang',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
  ];
  @override
  void searchItem(String text) {
    setState(() {
      _searchText = text;
      filteredItems = items
          .where((item) =>
              item.title.toLowerCase().contains(text.toLowerCase()) ||
              item.price.toLowerCase().contains(text.toLowerCase()) ||
              item.location.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<MarketplaceItem> displayItems =
        _searchText.isEmpty ? items : filteredItems;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFA9AF7E),
          centerTitle: true,
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
                width: 170.0,
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
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    'Posted Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins-Bold',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(3),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 10,
              childAspectRatio: 2 / 4,
            ),
            itemCount: displayItems
                .length, // Use displayItems.length instead of items.length
            itemBuilder: (context, index) {
              final item = displayItems[index];
              return GestureDetector(
                onTap: () {},
                child: Card(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item.imageUrl,
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 150,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Price: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.price,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Location:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        item.location,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Description:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        item.description,
                                        style: TextStyle(
                                          fontSize: 14,
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
                      Positioned(
                        top: 0,
                        right: 8,
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_horiz,
                            color: Color(0xFF9DC08B),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Color(0xFF9DC08B).withAlpha(180),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Color(0xFF9DC08B),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (String value) {
                            if (value == 'edit') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        'Edit Details',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Add photo: ',
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 15.5,
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
                                            labelStyle: TextStyle(
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 15.5,
                                                color: Colors.black),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFA9AF7E)),
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Price',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 15.5,
                                                color: Colors.black),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFA9AF7E)),
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: "Farmer's Name",
                                            labelStyle: TextStyle(
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 15.5,
                                                color: Colors.black),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFA9AF7E)),
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Description',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 15.5,
                                                color: Colors.black),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFA9AF7E)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 15.5,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                String postContent =
                                                    _postController.text;
                                                print(postContent);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    157, 192, 139, 1),
                                                primary: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ])));
  }
}
