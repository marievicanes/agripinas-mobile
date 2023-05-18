import 'package:flutter/material.dart';

class AdminForum extends StatefulWidget {
  @override
  _AdminForumState createState() => _AdminForumState();
}

class _AdminForumState extends State<AdminForum> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<DataRow> _rows = [
    DataRow(
      cells: [
        DataCell(Text('B008')),
        DataCell(Text('Buyer')),
        DataCell(Text('Daniella Marie Tungol')),
        DataCell(Text('Is 300Php for a 1 kilo of onion is a reasonable price?')),
        DataCell(
          Image.asset(
            'assets/onion.png',
            height: 20,
            width: 20,
          ),
        ),
        DataCell(
          Icon(
            Icons.edit,
            color: Color(0xFF9DC08B).withAlpha(130),
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
        DataCell(Text('F001')),
        DataCell(Text('Farmer')),
        DataCell(Text('Ryan Edward Amador')),
        DataCell(Text('What is the current SRP of onions?')),
        DataCell(
          Image.asset(
            'assets/onion.png',
            height: 20,
            width: 20,
          ),
        ),
        DataCell(
          Icon(
            Icons.edit,
            color: Color(0xFF9DC08B).withAlpha(130),
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
                  '  Community Forum',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 5),
                        Text(
                          "Post Management",
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
                            'User Role',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF718C53),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Full Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF718C53),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Post',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF718C53),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Image',
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

        ]
      )
    );
  }
}

