import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_wall.dart';
import 'package:intl/intl.dart';

class MarketplaceItem {
  final String crops;
  final String quantity;
  final String etharvest1;

  MarketplaceItem({
    required this.crops,
    required this.quantity,
    required this.etharvest1,
  });
}

class HarvestedItem {
  final String cropsharvested;
  final String cropsquantity;
  final String etharvest;
  final String imageUrl1;

  HarvestedItem({
    required this.cropsharvested,
    required this.cropsquantity,
    required this.etharvest,
    required this.imageUrl1,
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
  DateTime? selectedDate;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final List<MarketplaceItem> items = [
    MarketplaceItem(
      crops: 'Tomato',
      quantity: 'Date Planted: 05/11/2020',
      etharvest1: 'Estimated Date to Harvest: 05/11/2021',
    ),
    MarketplaceItem(
      crops: 'Onion',
      quantity: 'Date Planted: 05/11/2020',
      etharvest1: 'Estimated Date to Harvest: 05/11/2021',
    ),
    MarketplaceItem(
      crops: 'Pechay',
      quantity: 'Date Planted: 05/11/2020',
      etharvest1: 'Estimated Date to Harvest: 05/11/2021',
    ),
    MarketplaceItem(
      crops: 'Rice',
      quantity: 'Date Planted: 05/11/2020',
      etharvest1: 'Estimated Date to Harvest: 05/11/2021',
    ),
    MarketplaceItem(
      crops: 'Calamansi',
      quantity: 'Date Planted: 05/11/2020',
      etharvest1: 'Estimated Date to Harvest: 05/11/2021',
    ),
    MarketplaceItem(
      crops: 'Corn',
      quantity: 'Date Planted: 05/11/2020',
      etharvest1: 'Estimated Date to Harvest: 05/11/2021',
    ),
  ];

  final List<HarvestedItem> harvesteditems = [
    HarvestedItem(
      cropsharvested: 'Squash',
      cropsquantity: 'Date Planted: 05/11/2020',
      etharvest: 'Estimated Date to Harvest: 05/11/2021',
      imageUrl1: 'assets/kalabasa.png',
    ),
    HarvestedItem(
      cropsharvested: 'Corn',
      cropsquantity: 'Date Planted: 05/11/2020',
      etharvest: 'Estimated Date to Harvest: 05/11/2021',
      imageUrl1: 'assets/corn.png',
    ),
    HarvestedItem(
      cropsharvested: 'Watermelon',
      cropsquantity: 'Date Planted: 05/11/2020',
      etharvest: 'Estimated Date to Harvest: 05/11/2021',
      imageUrl1: 'assets/pakwan.png',
    ),
    HarvestedItem(
      cropsharvested: 'Siling Labuyo',
      cropsquantity: 'Date Planted: 05/11/2020',
      etharvest: 'Estimated Date to Harvest: 05/11/2021',
      imageUrl1: 'assets/sili.png',
    ),
    HarvestedItem(
      cropsharvested: 'Pechay',
      cropsquantity: 'Date Planted: 05/11/2020',
      etharvest: 'Estimated Date to Harvest: 05/11/2021',
      imageUrl1: 'assets/pechay.png',
    ),
    HarvestedItem(
      cropsharvested: 'Calamansi',
      cropsquantity: 'Date Planted: 05/11/2020',
      etharvest: 'Estimated Date to Harvest: 05/11/2021',
      imageUrl1: 'assets/calamansi.png',
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                  fontFamily: 'Poppins',
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
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      color: Color(0xFF718C53),
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Harvested',
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      color: Color(0xFF718C53),
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
                  child: Text(
                    '     Crop Tracker',
                    style:
                        TextStyle(fontSize: 20.0, fontFamily: 'Poppins-Bold'),
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
                        style: TextStyle(
                            fontSize: 15.0, fontFamily: 'Poppins-Regular'),
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
                      childAspectRatio: 3 / 2,
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
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8, 10, 8, 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.crops,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins'),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.quantity,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Poppins-Light'),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.etharvest1,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Poppins-Light'),
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
                                                        fontFamily:
                                                            'Poppins-Regular',
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
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 15.5,
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
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 15.5,
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
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
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
                                                          fontFamily:
                                                              'Poppins-Regular',
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
                                                      child: Text(
                                                        'Save',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
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
                                    } else if (value == 'delete') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Delete Tracker?',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              "This can't be undone and it will be removed from your tracker.",
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 13.8,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Regular',
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Delete',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF9DC08B)
                                                          .withAlpha(180),
                                                    )),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
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
                    itemCount: harvesteditems.length,
                    itemBuilder: (context, index) {
                      final item = harvesteditems[index];
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
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.asset(
                                            item.imageUrl1,
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 125,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.cropsharvested,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.cropsquantity,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Poppins-Light',
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.etharvest,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Poppins-Light',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 5,
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
                                                        fontFamily:
                                                            'Poppins-Regular',
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
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 15.5,
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
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 15.5,
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
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
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
                                                          fontFamily:
                                                              'Poppins-Regular',
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
                                                      child: Text(
                                                        'Save',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
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
                                    } else if (value == 'delete') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Delete Tracker?',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              "This can't be undone and it will be removed from your tracker.",
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 13.8,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Regular',
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Delete',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF9DC08B)
                                                          .withAlpha(180),
                                                    )),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
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
