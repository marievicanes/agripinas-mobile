import 'package:capstone/buyer/buyer_category_fertilizer.dart';
import 'package:capstone/buyer/buyer_category_fruits.dart';
import 'package:capstone/buyer/buyer_category_ofproducts.dart';
import 'package:capstone/buyer/buyer_category_veggies.dart';
import 'package:capstone/buyer/buyer_productdetails.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');

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
        backgroundColor: Color(0xFFA9AF7E),
        automaticallyImplyLeading: false,
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
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      'Marketplace',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins-Bold',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 15,
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
            buildMarketplaceSection(),
          ],
        ),
      ),
    );
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();

  Widget buildMarketplaceSection() {
    return StreamBuilder(
      stream: _marketplace.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasError) {
          return Center(
            child: Text('Some error occurred ${streamSnapshot.error}'),
          );
        }
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No data available'),
          );
        }

        QuerySnapshot<Object?>? querySnapshot = streamSnapshot.data;
        List<QueryDocumentSnapshot<Object?>>? documents = querySnapshot?.docs;
        List<Map>? items = documents?.map((e) => e.data() as Map).toList();

        return SingleChildScrollView(
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items?.length ?? 0,
            padding: EdgeInsets.all(3),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 10,
              childAspectRatio: 2 / 4,
            ),
            itemBuilder: (BuildContext context, int index) {
              final Map thisItem = items![index];

              return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(thisItem),
                      ),
                    );
                  },
                  child: Card(
                    child: Stack(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    '${thisItem['image']}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 250,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    '${thisItem['cropName']}',
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
                                      '${thisItem['price']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Users')
                                          .where('uid',
                                              isEqualTo: currentUser?.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data!.docs.isNotEmpty) {
                                          QueryDocumentSnapshot userData =
                                              snapshot.data!.docs.first;
                                          String fullName = userData
                                              .get('fullname')
                                              .toString();

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Farmer: ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              Text(
                                                fullName,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          // Handle the case when there is no data or the document is empty
                                          return Text("No data available");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        '${thisItem['location']}',
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
                    ]),
                  ));
            },
          ),
        );
      },
    );
  }
}
