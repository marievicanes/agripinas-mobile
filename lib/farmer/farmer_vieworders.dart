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
      home: FarmerViewOrders(),
    );
  }
}

class FarmerViewOrders extends StatefulWidget {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  _FarmerViewOrdersState createState() => _FarmerViewOrdersState();
}

class _FarmerViewOrdersState extends State<FarmerViewOrders> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CollectionReference _userCarts =
      FirebaseFirestore.instance.collection('UserCarts');
  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('Transaction');
  final CollectionReference _reports =
      FirebaseFirestore.instance.collection('Reports');

  final currentUser = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFA9AF7E),
          centerTitle: false,
          title: Row(
            children: [
              SizedBox(width: 8.0),
              Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: StreamBuilder(
            stream: _transaction.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${streamSnapshot.error}'),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/historyorder.png', // Add your image path
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'There are no history orders.',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }

              QuerySnapshot<Object?>? querySnapshot = streamSnapshot.data;
              List<QueryDocumentSnapshot<Object?>>? documents =
                  querySnapshot?.docs;
              List<Map>? items =
                  documents?.map((e) => e.data() as Map).toList();

              documents!.sort((a, b) {
                final DateTime dateA = DateTime.parse(a['dateBought']);
                final DateTime dateB = DateTime.parse(b['dateBought']);
                return dateB.compareTo(dateA);
              });

              return ListView.builder(
                  itemCount: documents?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot documentSnapshot = documents![index];
                    final Map<String, dynamic> transactionData =
                        documentSnapshot.data() as Map<String, dynamic>;

                    // Accessing values from the 'orders' array
                    final List<dynamic> ordersList = transactionData['orders'];
                    final Map<String, dynamic>? order = ordersList.firstWhere(
                      (order) {
                        return order['uid'] == currentUser?.uid;
                      },
                      orElse: () => null,
                    );

                    if (order != null) {
                      final String cropName = order['cropName'];
                      final String price = order['price'];
                      final String boughtQuantity = order['boughtQuantity'];
                      final String totalCost = order['totalCost'];
                      final String image = order['image'];
                      final String dateBought = 'dateBought';

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Divider(),
                              Card(
                                elevation: 3.0,
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    _buildCartItem(
                                      cropName,
                                      price as String,
                                      boughtQuantity as String,
                                      image,
                                      'Poppins-Regular',
                                    ),
                                    SizedBox(height: 16.0),
                                    _buildPaymentInfo('Total Payment:',
                                        totalCost, 'Poppins-Regular'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  });
            }));
  }

  Widget _buildCartItem(String cropName, String price, String boughtQuantity,
      String image, String fontFamily) {
    return ListTile(
      leading: Image.network(
        image,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
      title: Text(
        cropName,
        style: TextStyle(fontSize: 16.0, fontFamily: fontFamily),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price: ₱$price',
          ),
          Text('Quantity: $boughtQuantity',
              style: TextStyle(fontFamily: fontFamily)),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(String label, String value, String fontFamily) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 15, fontFamily: fontFamily),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartShippingInfo(String label, String value, String fontFamily) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: fontFamily,
              color: Color(0xFFA9AF7E),
            ),
          ),
        ],
      ),
    );
  }
}
