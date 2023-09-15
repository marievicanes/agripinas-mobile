import 'package:capstone/farmer/fruitcalamansi.dart';
import 'package:capstone/farmer/fruitcorn.dart';
import 'package:capstone/farmer/fruittomato.dart';
import 'package:flutter/material.dart';

class MarketplaceItem {
  final String title;
  final String price;
  final String farmer;
  final String location;
  final String imageUrl;

  MarketplaceItem({
    required this.title,
    required this.price,
    required this.farmer,
    required this.location,
    required this.imageUrl,
  });
}

class FruitsScreen extends StatefulWidget {
  @override
  _FruitsScreenState createState() => _FruitsScreenState();
}

class _FruitsScreenState extends State<FruitsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<MarketplaceItem> filteredItems = [];

  final List<MarketplaceItem> items = [
    MarketplaceItem(
      title: 'Tomato',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      location: 'Brgy. Bagong Buhay',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      farmer: 'Marievic Añes',
      location: 'Brgy. Bagong Silang',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      title: 'Calamansi',
      price: '₱400',
      farmer: 'Jenkins Mesina',
      location: 'Brgy. Concepcion',
      imageUrl: 'assets/calamansi.png',
    ),
    MarketplaceItem(
      title: 'Tomato',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      location: 'Brgy. Natividad South',
      imageUrl: 'assets/tomato.png',
    ),
  ];
  final List<Widget Function(BuildContext)> routes = [
    (context) => FruitTomatoScreen(),
    (context) => FruitCornScreen(),
    (context) => FruitCalamansiScreen(),
    (context) => FruitTomatoScreen(),
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
