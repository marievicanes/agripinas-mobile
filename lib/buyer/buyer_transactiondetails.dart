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
      home: BuyerTransactionDetails(),
    );
  }
}

class BuyerTransactionDetails extends StatefulWidget {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  _BuyerTransactionDetailsState createState() =>
      _BuyerTransactionDetailsState();
}

class _BuyerTransactionDetailsState extends State<BuyerTransactionDetails> {
  String selectedPaymentMethod = 'Cash on Pickup';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(),
              Divider(),
              Divider(),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 8.0),
                    ],
                  ),
                ],
              ),
              Text(
                'Order Completed',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              SizedBox(height: 7.0),
              Text(
                'Thank you for Shopping with AgriPinas!',
                style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 14),
              ),
              SizedBox(height: 20.0),
              Divider(),
              Text(
                'Shipping Information',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
              ),
              Card(
                elevation: 3.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildCartShippingInfo(
                        'Parcel has been delivered', '', 'Poppins-Regular'),
                  ],
                ),
              ),
              Divider(),
              Text(
                'Seller: Marievic Anes',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
              ),
              Card(
                elevation: 3.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildCartItem('Pechay', 200.0, 2, 'assets/pechay.png',
                        'Poppins-Regular'),
                    _buildCartItem('Tomato', 150.0, 1, 'assets/tomato.png',
                        'Poppins-Regular'),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Divider(),
              _buildPaymentInfo(
                  'Payment Method:', 'Cash on Delivery', 'Poppins-Regular'),
              _buildPaymentInfo('Order Total:', '₱350.00', 'Poppins-Regular'),
              SizedBox(height: 16.0),
              Divider(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.4, // Adjust the width as needed
                    child: OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(color: Color(0xFF9DC08B)),
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Color(0xFF9DC08B)),
                      ),
                      child: Text(
                        'Chat Seller',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins-Regular',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFF9DC08B),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'REPORT PRODUCT',
                            style: TextStyle(
                              fontSize: 14.5,
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, double price, int quantity,
      String productImageAsset, String fontFamily) {
    return ListTile(
      leading: Image.asset(
        productImageAsset,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
      title: Text(
        name,
        style: TextStyle(fontSize: 16.0, fontFamily: fontFamily),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price: ₱${price.toStringAsFixed(2)}',
          ),
          Text('Quantity: $quantity', style: TextStyle(fontFamily: fontFamily)),
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
