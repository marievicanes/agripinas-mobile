import 'package:capstone/buyer/checkout.dart';
import 'package:flutter/material.dart';

class BuyerCrops {
  final String title;
  final String price;
  final String farmer;
  final String location;
  final String description;
  final String imageUrl;

  BuyerCrops({
    required this.title,
    required this.price,
    required this.farmer,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}

class BuyerCropsScreen extends StatefulWidget {
  @override
  _BuyerCropsState createState() => _BuyerCropsState();
}

class _BuyerCropsState extends State<BuyerCropsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<BuyerCrops> filteredItems = [];

  final List<BuyerCrops> items = [
    BuyerCrops(
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
    List<BuyerCrops> displayItems = _searchText.isEmpty ? items : filteredItems;

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
          return Column(
            children: [
              Card(
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
                                  fontFamily: 'Poppins',
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
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                item.farmer,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Poppins-Regular',
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
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                item.location,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Poppins-Regular',
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
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  item.description,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Regular'),
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(color: Color(0xFF9DC08B))),
                      foregroundColor:
                          MaterialStateProperty.all(Color(0xFF9DC08B)),
                    ),
                    child: Text(
                      'Chat Now',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins-Regular',
                          color: Colors.black),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          Future.delayed(Duration(milliseconds: 600), () {
                            Navigator.of(context).pop();
                          });
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              'Added to Cart',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(color: Color(0xFF9DC08B)),
                      ),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF9DC08B)),
                    ),
                    child: Text(
                      'BUY NOW',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
