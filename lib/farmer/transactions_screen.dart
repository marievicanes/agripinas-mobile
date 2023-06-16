import 'package:flutter/material.dart';

class MarketplaceItem {
  final String userid;
  final String itemid;
  final String pendingitemname;
  final String dateordered;
  final String unitprice;
  final String quantity;
  final String totalamount;
  final String buyername;
  final String imageUrl;

  MarketplaceItem({
    required this.userid,
    required this.itemid,
    required this.pendingitemname,
    required this.dateordered,
    required this.unitprice,
    required this.quantity,
    required this.totalamount,
    required this.buyername,
    required this.imageUrl,
  });
}

class CancelledMarketplaceItem {
  final String userid;
  final String itemid;
  final String cancelitemname;
  final String dateordered;
  final String unitprice;
  final String quantity;
  final String totalamount;
  final String buyername;
  final String imageUrl1;

  CancelledMarketplaceItem({
    required this.userid,
    required this.itemid,
    required this.cancelitemname,
    required this.dateordered,
    required this.unitprice,
    required this.quantity,
    required this.totalamount,
    required this.buyername,
    required this.imageUrl1,
  });
}

class CompleteMarketplaceItem {
  final String userid;
  final String itemid;
  final String completeitemname;
  final String dateordered;
  final String unitprice;
  final String quantity;
  final String totalamount;
  final String buyername;
  final String imageUrl2;

  CompleteMarketplaceItem({
    required this.userid,
    required this.itemid,
    required this.completeitemname,
    required this.dateordered,
    required this.unitprice,
    required this.quantity,
    required this.totalamount,
    required this.buyername,
    required this.imageUrl2,
  });
}

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String? selectedStatus;
  bool _isButtonVisible = true;
  late TabController _tabController;
  final _postController = TextEditingController();

  final List<MarketplaceItem> items = [
    MarketplaceItem(
      userid: 'B001',
      itemid: 'N001',
      pendingitemname: 'Onion',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '5',
      totalamount: '₱2,000',
      buyername: 'Ryan Amador',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      userid: 'B002',
      itemid: 'N002',
      pendingitemname: 'Rice',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱500',
      quantity: '9',
      totalamount: '₱3,600',
      buyername: 'Daniel Ribaya',
      imageUrl: 'assets/rice.png',
    ),
    MarketplaceItem(
      userid: 'B003',
      itemid: 'N003',
      pendingitemname: 'Pechay',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱600',
      quantity: '2',
      totalamount: 'Php 1200',
      buyername: 'Ryan Amador',
      imageUrl: 'assets/pechay.png',
    ),
    MarketplaceItem(
      userid: 'B004',
      itemid: 'N004',
      pendingitemname: 'Corn',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '10',
      totalamount: '₱4,000',
      buyername: 'Jenkins Mesina',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      userid: 'B005',
      itemid: 'N005',
      pendingitemname: 'Tomato',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '11',
      totalamount: '₱4,400',
      buyername: 'Ryan Amador',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      userid: 'B006',
      itemid: 'N006',
      pendingitemname: 'Calamansi',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '12',
      totalamount: '₱4,800',
      buyername: 'Ryan Amador',
      imageUrl: 'assets/calamansi.png',
    ),
  ];
  final List<CancelledMarketplaceItem> cancelitems = [
    CancelledMarketplaceItem(
      userid: 'B001',
      itemid: 'N001',
      cancelitemname: 'Pechay',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '5',
      totalamount: '₱2,000',
      buyername: 'Marievic Anes',
      imageUrl1: 'assets/pechay.png',
    ),
    CancelledMarketplaceItem(
      userid: 'B002',
      itemid: 'N002',
      cancelitemname: 'Onion',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱500',
      quantity: '9',
      totalamount: '₱3,600',
      buyername: 'Daniel Ribaya',
      imageUrl1: 'assets/onion.png',
    ),
    CancelledMarketplaceItem(
      userid: 'B003',
      itemid: 'N003',
      cancelitemname: 'Squash',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱600',
      quantity: '2',
      totalamount: 'Php 1200',
      buyername: 'Daniella Tungol',
      imageUrl1: 'assets/kalabasa.png',
    ),
    CancelledMarketplaceItem(
      userid: 'B004',
      itemid: 'N004',
      cancelitemname: 'Corn',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '10',
      totalamount: '₱4,000',
      buyername: 'Romeo London III',
      imageUrl1: 'assets/corn.png',
    ),
    CancelledMarketplaceItem(
      userid: 'B005',
      itemid: 'N005',
      cancelitemname: 'Calamansi',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '11',
      totalamount: '₱4,400',
      buyername: 'Jenkins Mesina',
      imageUrl1: 'assets/calamansi.png',
    ),
    CancelledMarketplaceItem(
      userid: 'B006',
      itemid: 'N006',
      cancelitemname: 'Siling Labuyo',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '12',
      totalamount: '₱4,800',
      buyername: 'Ryan Amador',
      imageUrl1: 'assets/sili.png',
    ),
  ];
  final List<CompleteMarketplaceItem> completeitems = [
    CompleteMarketplaceItem(
      userid: 'B001',
      itemid: 'N001',
      completeitemname: 'Squash',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '5',
      totalamount: '₱2,000',
      buyername: 'Marievic Anes',
      imageUrl2: 'assets/kalabasa.png',
    ),
    CompleteMarketplaceItem(
      userid: 'B002',
      itemid: 'N002',
      completeitemname: 'Watermelon',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱500',
      quantity: '9',
      totalamount: '₱3,600',
      buyername: 'Daniel Ribaya',
      imageUrl2: 'assets/pakwan.png',
    ),
    CompleteMarketplaceItem(
      userid: 'B003',
      itemid: 'N003',
      completeitemname: 'Corn',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱600',
      quantity: '2',
      totalamount: 'Php 1200',
      buyername: 'Daniella Tungol',
      imageUrl2: 'assets/corn.png',
    ),
    CompleteMarketplaceItem(
      userid: 'B004',
      itemid: 'N004',
      completeitemname: 'Pechay',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '10',
      totalamount: '₱4,000',
      buyername: 'Romeo London III',
      imageUrl2: 'assets/pechay.png',
    ),
    CompleteMarketplaceItem(
      userid: 'B005',
      itemid: 'N005',
      completeitemname: 'Calamansi',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '11',
      totalamount: '₱4,400',
      buyername: 'Jenkins Mesina',
      imageUrl2: 'assets/calamansi.png',
    ),
    CompleteMarketplaceItem(
      userid: 'B006',
      itemid: 'N006',
      completeitemname: 'Siling Labuyo',
      dateordered: '02 / 01 / 2023',
      unitprice: '₱400',
      quantity: '12',
      totalamount: '₱4,800',
      buyername: 'Ryan Amador',
      imageUrl2: 'assets/sili.png',
    ),
  ];

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
    return DefaultTabController(
      length: 3,
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
                    'Pending',
                    style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        color: Color(0xFF718C53)),
                  ),
                ),
                Tab(
                  child: Text(
                    'Cancelled',
                    style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        color: Color(0xFF718C53)),
                  ),
                ),
                Tab(
                  child: Text(
                    'Completed',
                    style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        color: Color(0xFF718C53)),
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
                    '     Transactions',
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
                  ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.pendingitemname,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          item.imageUrl,
                                          fit: BoxFit.cover,
                                          width: 80,
                                          height: 80,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Text(
                                        '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF718C53),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        item.itemid,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        item.userid,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        item.buyername,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      Text(
                                        item.dateordered,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      Text(
                                        item.unitprice,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        item.quantity,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      Text(
                                        item.totalamount,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                                        fontSize: 20.0,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [],
                                                    ),
                                                    SizedBox(height: 16.0),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Status',
                                                        labelStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins-Regular'),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFFA9AF7E)),
                                                        ),
                                                      ),
                                                      value: selectedStatus,
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          selectedStatus =
                                                              newValue;
                                                        });
                                                      },
                                                      items: <String>[
                                                        'Pending',
                                                        'Cancelled',
                                                        'Completed'
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Poppins-Regular'),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            String postContent =
                                                                _postController
                                                                    .text;
                                                            print(postContent);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Save',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                            ),
                                                          ),
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    157,
                                                                    192,
                                                                    139,
                                                                    1),
                                                            primary:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: cancelitems.length,
                    itemBuilder: (context, index) {
                      final item = cancelitems[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.cancelitemname,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          item.imageUrl1,
                                          fit: BoxFit.cover,
                                          width: 80,
                                          height: 80,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Text(
                                        '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF718C53),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        item.itemid,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        item.userid,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        item.buyername,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      Text(
                                        item.dateordered,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      Text(
                                        item.unitprice,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        item.quantity,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      Text(
                                        item.totalamount,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                                        fontSize: 20.0,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [],
                                                    ),
                                                    SizedBox(height: 16.0),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Status',
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFFA9AF7E)),
                                                        ),
                                                      ),
                                                      value: selectedStatus,
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          selectedStatus =
                                                              newValue;
                                                        });
                                                      },
                                                      items: <String>[
                                                        'Pending',
                                                        'Cancelled',
                                                        'Completed'
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Poppins-Regular'),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            String postContent =
                                                                _postController
                                                                    .text;
                                                            print(postContent);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Save',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                            ),
                                                          ),
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    157,
                                                                    192,
                                                                    139,
                                                                    1),
                                                            primary:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: completeitems.length,
                    itemBuilder: (context, index) {
                      final item = completeitems[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.completeitemname,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          item.imageUrl2,
                                          fit: BoxFit.cover,
                                          width: 80,
                                          height: 80,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Text(
                                        '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF718C53),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        item.itemid,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        item.userid,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        item.buyername,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      Text(
                                        item.dateordered,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      Text(
                                        item.unitprice,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        item.quantity,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Medium'),
                                      ),
                                      Text(
                                        item.totalamount,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                                        fontSize: 20.0,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [],
                                                    ),
                                                    SizedBox(height: 16.0),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Status',
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFFA9AF7E)),
                                                        ),
                                                      ),
                                                      value: selectedStatus,
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          selectedStatus =
                                                              newValue;
                                                        });
                                                      },
                                                      items: <String>[
                                                        'Pending',
                                                        'Cancelled',
                                                        'Completed'
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Poppins-Regular'),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            String postContent =
                                                                _postController
                                                                    .text;
                                                            print(postContent);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Save',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                            ),
                                                          ),
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    157,
                                                                    192,
                                                                    139,
                                                                    1),
                                                            primary:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
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
