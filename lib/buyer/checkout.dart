import 'package:capstone/buyer/transactions_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFA9AF7E),
      ),
      home: CheckoutScreen(),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
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
              'Checkout',
              style: TextStyle(
                fontSize: 17.0,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: Color(0xFFA9AF7E),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Delivery Address',
                      style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Color(0xFFA9AF7E),
                        ),
                      ),
                      child: Text(
                        'Default',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF9DC08B)),
                      ),
                      child: Text(
                        'Change',
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'Marievic Anes | 09123445598',
              style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 13),
            ),
            Text(
              '551 F Jhocson St.',
              style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 13),
            ),
            Text(
              'Sampaloc, Manila, 1008 Metro Manila',
              style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 13),
            ),
            SizedBox(height: 20.0),
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
            Text(
              'Payment Details:',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
            ),
            _buildPaymentInfo(
                'Payment Method:', 'Cash on Delivery', 'Poppins-Regular'),
            _buildPaymentInfo('Total Payment:', '₱350.00', 'Poppins-Regular'),
            SizedBox(height: 16.0),
            Divider(),
            Text(
              'Total: ₱350.00',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TransactionBuyer(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFA9AF7E),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Center(
                child: Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
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
}