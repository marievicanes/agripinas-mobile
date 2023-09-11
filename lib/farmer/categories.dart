import 'package:capstone/farmer/category_veggies.dart';
import 'package:capstone/farmer/category_fertilizer.dart';
import 'package:capstone/farmer/marketplace_screen.dart';
import 'package:flutter/material.dart';

class CategoryItem {
  final String title;
  final String imageUrl;

  CategoryItem({
    required this.title,
    required this.imageUrl,
  });
}

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<CategoryItem> filteredItems = [];

  final List<CategoryItem> items = [
    CategoryItem(
      title: 'Fruits',
      imageUrl: 'assets/fruits.png',
    ),
    CategoryItem(
      title: 'Vegetables',
      imageUrl: 'assets/veggies.png',
    ),
    CategoryItem(
      title: 'Fertilizers',
      imageUrl: 'assets/fertilizer.png',
    ),
    CategoryItem(
      title: 'Other Farm Products',
      imageUrl: 'assets/products.png',
    ),
  ];

  final List<Widget Function(BuildContext)> routes = [
    (context) => FruitsScreen(),
    (context) => VegetablesScreen(),
    (context) => FertilizersScreen(),
    (context) => OtherFarmProductsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    List<CategoryItem> displayItems =
        _searchText.isEmpty ? items : filteredItems;

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
      body: Column(
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
                  '     Category',
                  style: TextStyle(fontSize: 20.0, fontFamily: 'Poppins-Bold'),
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
          Expanded(
            child: GridView.builder(
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
                          padding: EdgeInsets.all(9),
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
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OtherFarmProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Farm Products'),
      ),
      body: Center(
        child: Text("Other Farm Products"),
      ),
    );
  }
}
