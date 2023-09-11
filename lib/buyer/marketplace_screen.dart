import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MarketplaceItem {
  final String title;
  final String price;
  final String farmer;
  final String location;
  final String description;
  final String imageUrl;

  MarketplaceItem({
    required this.title,
    required this.price,
    required this.farmer,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}

class MarketplaceScreen extends StatefulWidget {
  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<MarketplaceItem> filteredItems = [];

  final List<MarketplaceItem> items = [

    MarketplaceItem(
      title: 'Tomato',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      location: 'Brgy. Bagong Buhay',
      description:
          'The tomato is the edible berry of the plant, commonly known as the tomato plant.',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: '₱400',
      farmer: 'Daniella Tungol',
      location: 'Brgy. Bagong Sikat',
      description:
          'An onion is a round vegetable with a brown skin that grows underground. ',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      farmer: 'Marievic Añes',
      location: 'Brgy. Bagong Silang',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      title: 'Calamansi',
      price: '₱400',
      farmer: 'Jenkins Mesina',
      location: 'Brgy. Concepcion',
      description:
          'Calamansi tastes sour with a hint of sweetness, like a mix between a lime and a mandarin',
      imageUrl: 'assets/calamansi.png',
    ),
    MarketplaceItem(
      title: 'Pechay',
      price: '₱400',
      farmer: 'Romeo London',
      location: 'Brgy. Entablado',
      description:
          'Pechay is a leafy, shallow-rooted, cool-season crop but can stand higher temperatures',
      imageUrl: 'assets/pechay.png',
    ),
    MarketplaceItem(
      title: 'Rice',
      price: '₱400',
      farmer: 'Mavic Anes',
      location: 'Brgy. Maligaya',
      description:
          'Rice is edible starchy cereal grain and the grass plant (family Poaceae) by which it is produced.',
      imageUrl: 'assets/rice.png',
    ),
    MarketplaceItem(
      title: 'Rice',
      price: '₱400',
      farmer: 'Mavic Anes',
      location: 'Brgy. Natividad North',
      description:
          'Rice is edible starchy cereal grain and the grass plant (family Poaceae) by which it is produced.',
      imageUrl: 'assets/rice.png',
    ),
    MarketplaceItem(
      title: 'Tomato',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      location: 'Brgy. Natividad South',
      description:
          'The tomato is the edible berry of the plant, commonly known as the tomato plant.',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: '₱400',
      farmer: 'Daniella Tungol',
      location: 'Brgy. Palasinan',
      description:
          'An onion is a round vegetable with a brown skin that grows underground. ',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      farmer: 'Marievic Añes',
      location: 'Brgy. Polilio',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      title: 'Calamansi',
      price: '₱400',
      farmer: 'Jenkins Mesina',
      location: 'Brgy. San Antonio',
      description:
          'Calamansi tastes sour with a hint of sweetness, like a mix between a lime and a mandarin',
      imageUrl: 'assets/calamansi.png',
    ),
    MarketplaceItem(
      title: 'Pechay',
      price: '₱400',
      farmer: 'Romeo London',
      location: 'Brgy. San Carlos',
      description:
          'Pechay is a leafy, shallow-rooted, cool-season crop but can stand higher temperatures',
      imageUrl: 'assets/pechay.png',
    ),
    MarketplaceItem(
      title: 'Rice',
      price: '₱400',
      farmer: 'Mavic Anes',
      location: 'Brgy. San Fernando Norte',
      description:
          'Rice is edible starchy cereal grain and the grass plant (family Poaceae) by which it is produced.',
      imageUrl: 'assets/rice.png',
    ),
    MarketplaceItem(
      title: 'Rice',
      price: '₱400',
      farmer: 'Mavic Anes',
      location: 'Brgy. San Fernando Sur',
      description:
          'Rice is edible starchy cereal grain and the grass plant (family Poaceae) by which it is produced.',
      imageUrl: 'assets/rice.png',
    ),
    MarketplaceItem(
      title: 'Tomato',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      location: 'Brgy. San Gregorio',
      description:
          'The tomato is the edible berry of the plant, commonly known as the tomato plant.',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: '₱400',
      farmer: 'Daniella Tungol',
      location: 'Brgy. San Juan North',
      description:
          'An onion is a round vegetable with a brown skin that grows underground. ',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      farmer: 'Marievic Añes',
      location: 'Brgy. San Juan South',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      title: 'Calamansi',
      price: '₱400',
      farmer: 'Jenkins Mesina',
      location: 'Brgy. San Roque',
      description:
          'Calamansi tastes sour with a hint of sweetness, like a mix between a lime and a mandarin',
      imageUrl: 'assets/calamansi.png',
    ),
    MarketplaceItem(
      title: 'Pechay',
      price: '₱400',
      farmer: 'Romeo London',
      location: 'Brgy. San Vicente',
      description:
          'Pechay is a leafy, shallow-rooted, cool-season crop but can stand higher temperatures',
      imageUrl: 'assets/pechay.png',
    ),
    MarketplaceItem(
      title: 'Rice',
      price: '₱400',
      farmer: 'Mavic Anes',
      location: 'Brgy. Santa Ines',
      description:
          'Rice is edible starchy cereal grain and the grass plant (family Poaceae) by which it is produced.',
      imageUrl: 'assets/rice.png',
    ),
    MarketplaceItem(
      title: 'Rice',
      price: '₱400',
      farmer: 'Mavic Anes',
      location: 'Brgy. Santa Isabel',
      description:
          'Rice is edible starchy cereal grain and the grass plant (family Poaceae) by which it is produced.',
      imageUrl: 'assets/rice.png',
    ),
    MarketplaceItem(
      title: 'Tomato',
      price: '₱400',
      farmer: 'Arriane Gatpo',
      location: 'Brgy. Santa Rita',
      description:
          'The tomato is the edible berry of the plant, commonly known as the tomato plant.',
      imageUrl: 'assets/tomato.png',
    ),
    MarketplaceItem(
      title: 'Onion',
      price: '₱400',
      farmer: 'Daniella Tungol',
      location: 'Brgy. Sinipit',
      description:
          'An onion is a round vegetable with a brown skin that grows underground. ',
      imageUrl: 'assets/onion.png',
    ),
    MarketplaceItem(
      title: 'Corn',
      price: '₱4500',
      farmer: 'Marievic Añes',
      location: 'Brgy. Polilio',
      description:
          'Corn is a tall annual cereal grass that is widely grown for its large elongated ears.',
      imageUrl: 'assets/corn.png',
    ),
    MarketplaceItem(
      title: 'Calamansi',
      price: '₱400',
      farmer: 'Jenkins Mesina',
      location: 'Brgy. San Antonio',
      description:
          'Calamansi tastes sour with a hint of sweetness, like a mix between a lime and a mandarin',
      imageUrl: 'assets/calamansi.png',
    ),
    MarketplaceItem(
      title: 'Pechay',
      price: '₱400',
      farmer: 'Romeo London',
      location: 'Brgy. San Carlos',
      description:
          'Pechay is a leafy, shallow-rooted, cool-season crop but can stand higher temperatures',
      imageUrl: 'assets/pechay.png',
    ),
    MarketplaceItem(
      title: 'Rice',
      price: '₱400',
      farmer: 'Mavic Anes',
      location: 'Brgy. San Fernando Norte',
      description:
          'Rice is edible starchy cereal grain and the grass plant (family Poaceae) by which it is produced.',
      imageUrl: 'assets/rice.png',
    ),
    MarketplaceItem(
      title: 'Rice',
      price: '₱400',
      farmer: 'Mavic Anes',
      location: 'Brgy. San Fernando Sur',
      description:
          'Rice is edible starchy cereal grain and the grass plant (family Poaceae) by which it is produced.',
      imageUrl: 'assets/rice.png',
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
    List<MarketplaceItem> displayItems =
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
              onTap: () {},
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
                                fontWeight: FontWeight.bold,
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item.farmer,
                              style: TextStyle(
                                fontSize: 14,
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                item.location,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                item.description,
                                style: TextStyle(
                                  fontSize: 14,
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
