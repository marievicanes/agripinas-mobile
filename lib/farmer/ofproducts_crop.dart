import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Crops {
  final String title;
  final String price;
  final String farmer;
  final String location;
  final String description;
  final String imageUrl;

  Crops({
    required this.title,
    required this.price,
    required this.farmer,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}

class CropsScreen extends StatefulWidget {
  @override
  _CropsState createState() => _CropsState();
}

class _CropsState extends State<CropsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<Crops> filteredItems = [];

  final List<Crops> items = [
    Crops(
      title: 'Crops',
      price: '₱300',
      farmer: 'Jenkins Mesina',
      location: 'Brgy. Bagong Buhay',
      description:
          'The tomato is the edible berry of the plant, commonly known as the tomato plant.',
      imageUrl: 'assets/crops.png',
    ),
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
    List<Crops> displayItems = _searchText.isEmpty ? items : filteredItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        centerTitle: false,
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
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: displayItems.length,
        itemBuilder: (context, index) {
          final item = displayItems[index];
          return GestureDetector(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
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
                              fontSize: 25,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Price: ',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item.price,
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'Farmer: ',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item.farmer,
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'Location: ',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item.location,
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description:',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                item.description,
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ],
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
    );
  }
}
