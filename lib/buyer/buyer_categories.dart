import 'package:capstone/buyer/buyer_category_fertilizer.dart';
import 'package:capstone/buyer/buyer_category_fruits.dart';
import 'package:capstone/buyer/buyer_category_ofproducts.dart';
import 'package:capstone/buyer/buyer_category_veggies.dart';
import 'package:flutter/material.dart';

class BuyerCategoryItem {
  final String title;
  final String imageUrl;

  BuyerCategoryItem({
    required this.title,
    required this.imageUrl,
  });
}

class BuyerCategoriesScreen extends StatefulWidget {
  @override
  _BuyerCategoriesScreenState createState() => _BuyerCategoriesScreenState();
}

class _BuyerCategoriesScreenState extends State<BuyerCategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<BuyerCategoryItem> filteredItems = [];

  final List<BuyerCategoryItem> items = [
    BuyerCategoryItem(
      title: 'Fruits',
      imageUrl: 'assets/fruits.png',
    ),
    BuyerCategoryItem(
      title: 'Vegetables',
      imageUrl: 'assets/veggies.png',
    ),
    BuyerCategoryItem(
      title: 'Fertilizers',
      imageUrl: 'assets/fertilizer.png',
    ),
    BuyerCategoryItem(
      title: 'Other Farm Products',
      imageUrl: 'assets/products.png',
    ),
  ];

  final List<Widget Function(BuildContext)> routes = [
    (context) => BuyerFruitsScreen(),
    (context) => BuyerVegetablesScreen(),
    (context) => BuyerFertilizersScreen(),
    (context) => BuyerOFProductScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Marketplace',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Poppins-Bold',
              ),
            ),
          ),
          SizedBox(height: 1.0),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontFamily: 'Poppins-Regular',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              childAspectRatio: 2 / 3,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
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
                              width: 250,
                              height: 250,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 12.2,
                                  fontFamily: 'Poppins',
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
            },
          ),
        ],
      ),
    );
  }
}
