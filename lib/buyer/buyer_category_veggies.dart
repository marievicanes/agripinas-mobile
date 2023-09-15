import 'package:capstone/farmer/fruitcalamansi.dart';
import 'package:capstone/farmer/fruitcorn.dart';
import 'package:capstone/farmer/fruittomato.dart';
import 'package:capstone/farmer/veggies_kalabasa.dart';
import 'package:capstone/farmer/veggies_pechay.dart';
import 'package:flutter/material.dart';

class BuyerVegetablesItem {
  final String title;
  final String price;
  final String farmer;
  final String location;
  final String imageUrl;

  BuyerVegetablesItem({
    required this.title,
    required this.price,
    required this.farmer,
    required this.location,
    required this.imageUrl,
  });
}

class BuyerVegetablesScreen extends StatefulWidget {
  @override
  _BuyerVegetablesScreenState createState() => _BuyerVegetablesScreenState();
}

class _BuyerVegetablesScreenState extends State<BuyerVegetablesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<BuyerVegetablesItem> filteredItems = [];

  final List<BuyerVegetablesItem> items = [
    BuyerVegetablesItem(
      title: 'Pechay',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      location: 'Brgy. Bagong Buhay',
      imageUrl: 'assets/pechay.png',
    ),
    BuyerVegetablesItem(
      title: 'Kalabasa',
      price: '₱4500',
      farmer: 'Marievic Añes',
      location: 'Brgy. Bagong Silang',
      imageUrl: 'assets/kalabasa.png',
    ),
    BuyerVegetablesItem(
      title: 'Kalabasa',
      price: '₱400',
      farmer: 'Daniella Tungol',
      location: 'Brgy. Concepcion',
      imageUrl: 'assets/kalabasa.png',
    ),
    BuyerVegetablesItem(
      title: 'Pechay',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      location: 'Brgy. Natividad South',
      imageUrl: 'assets/pechay.png',
    ),
  ];
  final List<Widget Function(BuildContext)> routes = [
    (context) => VeggiesPechayScreen(),
    (context) => VeggiesKalabasaScreen(),
    (context) => VeggiesKalabasaScreen(),
    (context) => VeggiesPechayScreen(),
  ];
  void searchItem(String text) {
    setState(() {
      _searchText = text;
      filteredItems = items
          .where((item) =>
              item.title.toLowerCase().contains(text.toLowerCase()) ||
              item.farmer.toLowerCase().contains(text.toLowerCase()) ||
              item.price.toLowerCase().contains(text.toLowerCase()) ||
              item.location.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BuyerVegetablesItem> displayItems =
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
              width: 190.0,
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
          childAspectRatio: 2 / 3.5,
        ),
        itemCount: displayItems.length,
        itemBuilder: (context, index) {
          final item = displayItems[index];
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: routes[index],
                  ),
                );
              },
              child: Card(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          width: 200,
                          height: 250,
                        ),
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
                                fontFamily: 'Poppins',
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
                        Row(
                          children: [
                            Text(
                              'Farmer: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              item.farmer,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                item.location,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins-Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )));
        },
      ),
    );
  }
}
