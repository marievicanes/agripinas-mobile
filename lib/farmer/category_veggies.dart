import 'package:capstone/farmer/product_details.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VegetablesScreen extends StatefulWidget {
  @override
  _VegetablesScreenState createState() => _VegetablesScreenState();
}

class _VegetablesScreenState extends State<VegetablesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');
  final currentUser = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
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
                  fontSize: 15.0,
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
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Marketplace')
                .where('uid', isEqualTo: currentUser?.uid)
                .where('category', isEqualTo: 'Vegetables')
                .snapshots(),
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
              if (!streamSnapshot.hasData ||
                  streamSnapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No data available'),
                );
              }

              QuerySnapshot<Object?>? querySnapshot = streamSnapshot.data;
              List<QueryDocumentSnapshot<Object?>>? documents =
                  querySnapshot?.docs;
              List<Map>? items =
                  documents?.map((e) => e.data() as Map).toList();

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Vegetables',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Expanded(
                    child: GridView.builder(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      width: 200,
                                      height: 250,
                                      child: thisItem.containsKey('image')
                                          ? Image.network(
                                              '${thisItem['image']}')
                                          : Container(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          Text(
                                            'Farmer: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          Text(
                                            '${thisItem['fullname']}',
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }));
  }
}
