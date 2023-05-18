import 'package:capstone/admin/accounts_management_farmer.dart';
import 'package:flutter/material.dart';

class BuyerAccountsManagement extends StatefulWidget {
  @override
  _BuyerAccountsManagementState createState() => _BuyerAccountsManagementState();
}

class _BuyerAccountsManagementState extends State<BuyerAccountsManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<DataRow> _rows = [
    DataRow(
      cells: [
        DataCell(Text('B001')),
        DataCell(Text('Arriane Clarisse Gatpo')),
        DataCell(Text('arriane@gmail.com')),
        DataCell(Text('(+63)9234567891')),
        DataCell(Text('Tandang Sora, Quezon City')),
        DataCell(Text('01-15-1999')),
        DataCell(Text('23')),
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
        DataCell(Text('B002')),
        DataCell(Text('Daniella Marie Tungol')),
        DataCell(Text('daniella@gmail.com')),
        DataCell(Text('(+63)9345678912')),
        DataCell(Text('Visayas Ave., Quezon City')),
        DataCell(Text('01-02-1999')),
        DataCell(Text('23')),
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('admin '),
                accountEmail: Text('admin@gmail.com'),
                currentAccountPicture:  CircleAvatar(
                  radius: 14.0,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFA9AF7E),
                ),
              ),

              ListTile(
                leading: Icon(Icons.shopping_bag_outlined),
                title: Text('Accounts Management - Buyer'),
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.agriculture_outlined),
                title: Text('Accounts Management - Farmer'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => FarmerAccounts()
                      ),
                  );
                },
              ),
            ],
          ),
        ),


        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      '   Accounts Management',
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
                              "Buyer Accounts",
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
                                'Full Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF718C53),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF718C53),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Contact No.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF718C53),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF718C53),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Birthday',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF718C53),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Age',
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
