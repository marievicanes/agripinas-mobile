import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MarketplaceItem {
  final String crops;
  final String quantity;
  final String imageUrl;

  MarketplaceItem({
    required this.crops,
    required this.quantity,
    required this.imageUrl,
  });
}

class CropTrackerScreen extends StatefulWidget {
  @override
  _CropTrackerScreenState createState() => _CropTrackerScreenState();
}

class _CropTrackerScreenState extends State<CropTrackerScreen>
    with SingleTickerProviderStateMixin {
  String? selectedStatus;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  bool _isButtonVisible = true;
  late TabController _tabController;
  final _postController = TextEditingController();
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
      crops: 'Ampalaya',
      quantity: '55kg',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      crops: 'Ampalaya',
      quantity: '55kg',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      crops: 'Ampalaya',
      quantity: '55kg',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      crops: 'Ampalaya',
      quantity: '55kg',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      crops: 'Ampalaya',
      quantity: '55kg',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      crops: 'Ampalaya',
      quantity: '55kg',
      imageUrl: 'assets/onion.png',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFA9AF7E),
          centerTitle: true,
          title: Row(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 32.0,
              ),
              SizedBox(width: 7.0),
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
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: Color(0xFF557153),
              tabs: [
                Tab(
                  child: Text(
                    'Harvest',
                    style: TextStyle(color: Color(0xFF718C53)),
                  ),
                ),
                Tab(
                  child: Text(
                    'Harvested',
                    style: TextStyle(color: Color(0xFF718C53)),
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    '     Crop Tracker',
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Show:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(width: 8.0),
                      DropdownButton<int>(
                        value: 15,
                        items: [
                          DropdownMenuItem<int>(
                            value: 15,
                            child: Text('15'),
                          ),
                          DropdownMenuItem<int>(
                            value: 25,
                            child: Text('25'),
                          ),
                          DropdownMenuItem<int>(
                            value: 50,
                            child: Text('50'),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
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
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 0),
                                        child: Image.asset(
                                          item.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        8, 0, 8, 20), // Adjusted padding
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.crops,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.quantity,
                                          style: TextStyle(
                                            fontSize: 14,
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
                                            color: Color(0xFF9DC08B)
                                                .withAlpha(180),
                                          ),
                                          SizedBox(width: 8),
                                          Text('Edit'),
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
                                          Text('Delete'),
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
                                                  fontWeight: FontWeight.bold,
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
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFFA9AF7E)),
                                                    ),
                                                  ),
                                                ),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: 'Quantity',
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFFA9AF7E)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 16.0),
                                                DropdownButtonFormField<String>(
                                                  value: selectedStatus,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedStatus = newValue;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Harvest',
                                                    'Harvested'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                                SizedBox(height: 16.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                                        String postContent =
                                                            _postController
                                                                .text;
                                                        print(postContent);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Save'),
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            Color.fromRGBO(157,
                                                                192, 139, 1),
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
                  GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 0),
                                        child: Image.asset(
                                          item.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        8, 0, 8, 20), // Adjusted padding
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.crops,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.quantity,
                                          style: TextStyle(
                                            fontSize: 14,
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
                                            color: Color(0xFF9DC08B)
                                                .withAlpha(180),
                                          ),
                                          SizedBox(width: 8),
                                          Text('Edit'),
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
                                          Text('Delete'),
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
                                                  fontWeight: FontWeight.bold,
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
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFFA9AF7E)),
                                                    ),
                                                  ),
                                                ),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: 'Quantity',
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFFA9AF7E)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 16.0),
                                                DropdownButtonFormField<String>(
                                                  value: selectedStatus,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedStatus = newValue;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Harvest',
                                                    'Harvested'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                                SizedBox(height: 16.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                                        String postContent =
                                                            _postController
                                                                .text;
                                                        print(postContent);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Save'),
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            Color.fromRGBO(157,
                                                                192, 139, 1),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveInformation() {}
}
