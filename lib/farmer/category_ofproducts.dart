import 'package:capstone/farmer/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fil', 'PH')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: OFProductScreen(),
    );
  }
}

class OFProductScreen extends StatefulWidget {
  @override
  _OFProductsScreenState createState() => _OFProductsScreenState();
}

class _OFProductsScreenState extends State<OFProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');

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
                  fontSize: 18.0,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                width: 175.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: _marketplace
                .where('category', isEqualTo: 'Others')
                .where('archived', isEqualTo: false)
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

              List<Map>? filteredItems = items
                  ?.where((item) =>
                      item['cropName']
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()) ||
                      item['location']
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()))
                  .toList();

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Other Farm Products',
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
                      itemCount: filteredItems?.length ?? 0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(3),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.3 / 4,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final Map thisItem = items![index];

                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetails(thisItem),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                                "farmerPagePrice".tr(),
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
                                                "farmerPageUserRole".tr(),
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
                                                  "farmerPageCategoriesLocation"
                                                      .tr(),
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
                                                    fontFamily:
                                                        'Poppins-Regular',
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
                  ),
                ],
              );
            }));
  }
}
