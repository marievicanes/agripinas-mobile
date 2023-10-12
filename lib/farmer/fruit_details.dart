import 'package:flutter/material.dart';

class FruitDetails extends StatelessWidget {
  final Map fruitData;

  FruitDetails(this.fruitData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruit Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 200,
              height: 250,
              child: fruitData.containsKey('image')
                  ? Image.network('${fruitData['image']}')
                  : Container(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '${fruitData['cropName']}',
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
                      '${fruitData['price']}',
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
                      '${fruitData['farmer']}',
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
                        '${fruitData['location']}',
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
      ),
    );
  }
}
