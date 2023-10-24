import 'package:capstone/buyer/checkout.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fil', 'PH')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(
        productData: {},
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Map productData;

  MyApp({required this.productData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: ProductDetails(this.productData),
    );
  }
}

class ProductDetails extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final Map productData;

  ProductDetails(this.productData);

  @override
  Widget build(BuildContext context) {
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
        body: ListView(padding: EdgeInsets.all(10), children: [
          Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${productData['image']}',
                        fit: BoxFit.cover,
                        width: double.infinity,
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
                            '${productData['cropName']}',
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
                              "buyerPagePrice".tr(),
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Poppins",
                              ),
                            ),
                            Text(
                              '${productData['price']}',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Poppins-Regular",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "buyerPageUserRole2".tr(),
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Poppins",
                              ),
                            ),
                            Text(
                              '${productData['farmer']}',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Poppins-Regular",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "buyerPageLocation".tr(),
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Poppins",
                              ),
                            ),
                            Text(
                              '${productData['location']}',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Poppins-Regular",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "farmerPageQuantity".tr(),
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Poppins",
                              ),
                            ),
                            Text(
                              '${productData['quantity']}',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Poppins-Regular",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "farmerPageUnit".tr(),
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Poppins",
                              ),
                            ),
                            Text(
                              '${productData['unit']}',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Poppins-Regular",
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
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    '${productData['description']}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: "Poppins-Regular",
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                              BorderSide(
                                                  color: Color(0xFF9DC08B))),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFF9DC08B)),
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
                                              Future.delayed(
                                                  Duration(milliseconds: 600),
                                                  () {
                                                Navigator.of(context).pop();
                                              });
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                title: Text(
                                                  'Added to Cart',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        'Poppins-Regular',
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                            BorderSide(
                                                color: Color(0xFF9DC08B)),
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
                                              builder: (context) =>
                                                  CheckoutScreen(),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFF9DC08B)),
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
                                ]))
                      ],
                    ))
              ]))
        ]));
  }
}
