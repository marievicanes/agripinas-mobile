import 'package:capstone/buyer/buyer_nav.dart';
import 'package:capstone/buyer/transactions_screen.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      home: BuyerPendingRequest(),
    );
  }
}

class BuyerPendingRequest extends StatefulWidget {
  @override
  _BuyerPendingRequestState createState() => _BuyerPendingRequestState();
}

class _BuyerPendingRequestState extends State<BuyerPendingRequest> {
  @override
  void initState() {
    super.initState();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();
  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 400,
          backgroundColor: Color(0xFFA9AF7E),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                "Pending Transaction",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Go to Transaction for more info",
                style: TextStyle(
                  fontFamily: "Poppins-Regular",
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BuyerNavBar()),
                      );
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(color: Colors.white),
                      ),
                    ),
                    child: Text(
                      'Marketplace',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionBuyer()),
                      );
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(color: Colors.white),
                      ),
                    ),
                    child: Text(
                      'Transaction',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        body: StreamBuilder(
            stream: _marketplace
                .where('uid', isEqualTo: 'uid')
                .where('archived', isEqualTo: false)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Center(
                    child: Text('Some error occurred ${streamSnapshot.error}'));
              }
              if (streamSnapshot.hasData) {
                QuerySnapshot<Object?>? querySnapshot = streamSnapshot.data;
                List<QueryDocumentSnapshot<Object?>>? documents =
                    querySnapshot?.docs;
                List<Map>? items =
                    documents?.map((e) => e.data() as Map).toList();

                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Other Products from the same Farmer",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemExtent: 150,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 8.0),
                                  Image.asset(
                                    'assets/kalabasa.png',
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    "Kalabasa",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontFamily: "Poppins",
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemCount: 20,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
