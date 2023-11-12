import 'package:capstone/buyer/buyer_nav.dart';
import 'package:capstone/buyer/buyer_productdetails.dart';
import 'package:capstone/buyer/message.dart';
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
  late List<Map<String, dynamic>> orders;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: BuyerPendingRequest(
        orders: [],
      ),
    );
  }
}

class BuyerPendingRequest extends StatefulWidget {
  final List<Map<String, dynamic>> orders;

  BuyerPendingRequest({required this.orders});

  @override
  _BuyerPendingRequestState createState() => _BuyerPendingRequestState();
}

class _BuyerPendingRequestState extends State<BuyerPendingRequest> {
  @override
  void initState() {
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();
  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');

  String generateRoomName(String currentUserUID, String selectedUserUID) {
    String roomName = currentUserUID.compareTo(selectedUserUID) < 0
        ? '$currentUserUID and $selectedUserUID'
        : '$selectedUserUID and $currentUserUID';
    print("Room Name: $roomName"); // Print the room name to the console
    return roomName;
  }

  @override
  Widget build(BuildContext context) {
    String uid = widget.orders.isNotEmpty ? widget.orders[0]['uid'] : '';
    String fullname =
        widget.orders.isNotEmpty ? widget.orders[0]['fullname'] : '';

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
                "buyerpendingtransac1".tr(),
                style: TextStyle(
                  fontFamily: "Poppins-Regular",
                  fontSize: 14,
                ),
              ),
              Text(
                "buyerpendingtransac2".tr(),
                style: TextStyle(
                  fontFamily: "Poppins-Regular",
                  fontSize: 14,
                ),
              ),
              Text(
                "buyerpendingtransac3".tr(),
                style: TextStyle(
                  fontFamily: "Poppins-Regular",
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () async {
                      // Ensure that the user is authenticated
                      if (_auth.currentUser != null) {
                        String roomName = generateRoomName(
                          _auth.currentUser!.uid,
                          uid, // Use the variable 'uid'
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatAgriScreen(
                              fullname: fullname, // Use the variable 'fullname'
                              roomName: roomName,
                              currentUserUid: _auth.currentUser!.uid,
                              farmerUid: uid, // Use the variable 'uid'
                            ),
                          ),
                        );
                      } else {
                        // Handle the case when the user is not authenticated (show an error or redirect to the login screen)
                      }
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(color: Colors.white),
                      ),
                    ),
                    child: Text(
                      'Chat Seller',
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
                        MaterialPageRoute(builder: (context) => BuyerNavBar()),
                      );
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(color: Colors.white),
                      ),
                    ),
                    child: Text(
                      'Go to Marketplace',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: _marketplace
              .where('uid',
                  isEqualTo:
                      widget.orders.isNotEmpty ? widget.orders[0]['uid'] : '')
              .where('archived', isEqualTo: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (streamSnapshot.hasError) {
              return Center(
                child: Text('Error: ${streamSnapshot.error}'),
              );
            }
            if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No other products available.'),
              );
            }

            List<DocumentSnapshot> documents = streamSnapshot.data!.docs;
            List<Map<String, dynamic>> items = documents
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "buyerpendingtransac4".tr(),
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
                    height: 300,
                    child: ListView.builder(
                      itemExtent: 150,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () async {
                            String cropID = items[index]['cropID'] ?? '';
                            Map<String, dynamic>? productDetails =
                                await fetchProductDetails(cropID);

                            if (productDetails != null) {
                              // Now you have the details of the selected product
                              // Navigate to the product details screen with the obtained details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetails(productDetails),
                                ),
                              );
                            } else {
                              print('Product details not found.');
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 8.0),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  items[index]['image'] ?? '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 150,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                items[index]['cropName'] ?? '',
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
                      itemCount: items?.length ?? 0,
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }

  // Function to fetch additional details by cropID
  Future<Map<String, dynamic>> fetchProductDetails(String cropID) async {
    try {
      // Reference to the Firestore collection
      CollectionReference marketplaceCollection =
          FirebaseFirestore.instance.collection('Marketplace');

      // Query to get the document with the specified cropID
      QuerySnapshot<Object?> querySnapshot =
          await marketplaceCollection.where('cropID', isEqualTo: cropID).get();

      // Check if there's a document with the specified cropID
      if (querySnapshot.docs.isNotEmpty) {
        // Extract the data from the document
        Map<String, dynamic> productDetails =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        return productDetails;
      } else {
        // Handle the case when the document with the specified cropID is not found
        print('Product details not found for cropID: $cropID');
        return {};
      }
    } catch (error) {
      // Handle errors here
      throw Exception('Failed to fetch product details: $error');
    }
  }
}
