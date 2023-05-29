import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String? _status;

  TextEditingController _userController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _buyerController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  List<DataRow> _rows = [];

  @override
  void initState() {
    super.initState();
    _initializeRows();
  }

  void _initializeRows() {
    List<DataRow> rows = [
      DataRow(
        cells: [
          DataCell(Text(
            'B001',
          )),
          DataCell(Text('N001')),
          DataCell(Text('Onion')),
          DataCell(Text('02 / 01 / 2023')),
          DataCell(Text('400')),
          DataCell(Text('2')),
          DataCell(Text('800')),
          DataCell(Text('Ryan Amador')),
          DataCell(
            DropdownButton<String>(
              value: 'pending',
              items: [
                DropdownMenuItem<String>(
                  value: 'pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem<String>(
                  value: 'cancelled',
                  child: Text('Cancelled'),
                ),
                DropdownMenuItem<String>(
                  value: 'completed',
                  child: Text('Completed'),
                ),
              ],
              onChanged: (value) {},
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Color(0xFF9DC08B).withAlpha(160),
              ),
              onPressed: _showEditDialog,
            ),
          ),
          DataCell(
            Icon(
              Icons.delete,
              color: Color(0xFF9DC08B),
            ),
          ),
        ],
      ),
    ];
    setState(() {
      _rows = rows;
    });
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Transactions'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _userController,
                  decoration: InputDecoration(labelText: 'User ID'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'Item ID'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date Ordered'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Unit Price'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity Order'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Total Amount'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _buyerController,
                  decoration: InputDecoration(labelText: 'Buyer Name'),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _status,
                  items: [
                    DropdownMenuItem<String>(
                      value: 'pending',
                      child: Text('Pending'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'cancelled',
                      child: Text('Cancelled'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'cancelled',
                      child: Text('Cancelled'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Status'),
                ),
                SizedBox(height: 16.0),
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
                  _searchText = _userController.text;
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

  void searchItem(String text) {
    setState(() {
      _searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> filteredRows = _rows
        .where((row) =>
            row.toString().toLowerCase().contains(_searchText.toLowerCase()))
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '   Transactions',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
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
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        'User ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Item ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Item Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Date Ordered',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Unit Price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Quantity Order',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Buyer Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Edit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                  ],
                  rows: _rows,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
