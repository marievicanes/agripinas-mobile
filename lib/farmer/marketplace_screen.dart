import 'package:flutter/material.dart';

class MarketplaceItem {
  final String title;
  final String price;
  final String farmer;
  final String description;
  final String imageUrl;

  MarketplaceItem({
    required this.title,
    required this.price,
    required this.farmer,
    required this.description,
    required this.imageUrl,
  });
}

class MarketplaceScreen extends StatelessWidget {
  final List<MarketplaceItem> items = [
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Ryan Amador',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Ryan Amador',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 4500',
      farmer: 'Ryan Amador',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Ryan Amador',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Ryan Amador',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: 'Php 400',
      farmer: 'Daniella Marie Tungol',
      description: 'A red round vegetable with a good storage quality',
      imageUrl: 'assets/onion.png',
    ),
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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 10,
          childAspectRatio:
              2 / 3, // Adjust the aspect ratio to control the height
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              // Handle item tap
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        item.imageUrl,
                        fit: BoxFit.cover,
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item.price,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item.farmer,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item.description,
                          style: TextStyle(fontSize: 14),
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
    );
  }
}
