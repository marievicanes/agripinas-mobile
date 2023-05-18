import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<DataRow> _rows = [
    DataRow(
      cells: [
        DataCell(Text('N0034')),
        DataCell(Text('Corn')),
        DataCell(Text('01/02/2023')),
        DataCell(Text('5000')),
        DataCell(Text('2')),
        DataCell(Text('10000')),
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
            onChanged: (value) {
            },
          ),
        ),
        DataCell(
          Icon(
            Icons.edit,
            color: Color(0xFF9DC08B).withAlpha(160),
          ),
        ),
        DataCell(
          Icon(Icons.delete,
            color: Color(0xFF9DC08B),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(Text('N001')),
        DataCell(Text('Rice')),
        DataCell(Text('01/02/2023')),
        DataCell(Text('5000')),
        DataCell(Text('2')),
        DataCell(Text('10000')),
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
            onChanged: (value) {
            },
          ),
        ),
        DataCell(
          Icon(
            Icons.edit,
            color: Color(0xFF9DC08B).withAlpha(160),
          ),
        ),
        DataCell(
          Icon(Icons.delete,
            color: Color(0xFF9DC08B),
          ),
        ),
      ],
    ),

  ];

  void searchItem(String text) {
    setState(() {
      _searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> filteredRows = _rows.where((row) =>
        row.toString().toLowerCase().contains(_searchText.toLowerCase())).toList();

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
                  '    Transactions',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
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
                      onChanged: (value) {
                      },
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
                      label: Text('Date Ordered',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text('Unit Price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text('Quantity Order',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text('Total Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text('Buyer’s Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text('Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text('Edit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text('Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF718C53),
                        ),
                      ),
                    ),
                  ],
                  rows: filteredRows,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

