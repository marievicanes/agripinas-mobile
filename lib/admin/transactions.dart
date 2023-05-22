import 'package:flutter/material.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<DataRow> _rows = [
    DataRow(
      cells: [
        DataCell(Text('B001')),
        DataCell(Text('N001')),
        DataCell(Text('Onion')),
        DataCell(Text('02/01/2023')),
        DataCell(Text('400 / kg')),
        DataCell(Text('2 kg')),
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
          Icon(
            Icons.edit,
            color: Color(0xFF9DC08B).withAlpha(130),
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
    DataRow(
      cells: [
        DataCell(Text('B002')),
        DataCell(Text('N002')),
        DataCell(Text('Garlic')),
        DataCell(Text('02/05/2023')),
        DataCell(Text('120 / kg')),
        DataCell(Text('3 kg')),
        DataCell(Text('360')),
        DataCell(Text('Daniel Ribaya')),
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
          Icon(
            Icons.edit,
            color: Color(0xFF9DC08B).withAlpha(130),
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
  List<DataRow> _rows1 = [
    DataRow(
      cells: [
        DataCell(Text('B001')),
        DataCell(Text('N001')),
        DataCell(Text('Onion')),
        DataCell(Text('02/01/2023')),
        DataCell(Text('400 / kg')),
        DataCell(Text('2 kg')),
        DataCell(Text('800')),
        DataCell(Text('Ryan Edward')),
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
          Icon(
            Icons.edit,
            color: Color(0xFF9DC08B).withAlpha(130),
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
    DataRow(
      cells: [
        DataCell(Text('B002')),
        DataCell(Text('N002')),
        DataCell(Text('Garlic')),
        DataCell(Text('02/05/2023')),
        DataCell(Text('120 / kg')),
        DataCell(Text('3 kg')),
        DataCell(Text('360')),
        DataCell(Text('Daniel Ribaya')),
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
          Icon(
            Icons.edit,
            color: Color(0xFF9DC08B).withAlpha(130),
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
                    'Buyer',
                    style: TextStyle(color: Color(0xFF718C53)),
                  ),
                ),
                Tab(
                  child: Text(
                    'Farmer',
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
                    '     Transactions',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  "Buyer Transactions",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            DataTable(
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
                                    'Farmer Name',
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
                              rows: filteredRows,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  "Farmer Transactions",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            DataTable(
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
                              rows: filteredRows,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
