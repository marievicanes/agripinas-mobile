import 'dart:io';

import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CropTrackerScreen extends StatefulWidget {
  @override
  _CropTrackerScreenState createState() => _CropTrackerScreenState();
}

class _CropTrackerScreenState extends State<CropTrackerScreen>
    with SingleTickerProviderStateMixin {
  String? selectedStatus;
  final TextEditingController _searchController = TextEditingController();
  TextEditingController _cropNameController = TextEditingController();
  TextEditingController _harvestController = TextEditingController();
  TextEditingController _plantedController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  TextEditingController _categoryController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _farmerController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  String imageUrl = '';

  String _searchText = '';
  bool _isButtonVisible = true;
  late TabController _tabController;
  final _postController = TextEditingController();
  DateTime? selectedDate;

  Future<void> _selectDatePlanted(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _plantedController.text = picked.toIso8601String().split('T')[0];
    }
  }

  Future<void> _selectEstimatedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _harvestController.text = picked.toIso8601String().split('T')[0];
    }
  }

  Future<void> _selectDatePlanted1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _plantedController.text = picked.toIso8601String().split('T')[0];
    }
  }

  Future<void> _selectHarvestedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _harvestController.text = picked.toIso8601String().split('T')[0];
    }
  }

  XFile? file;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future UimgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future UimgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        file = XFile(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  final CollectionReference _cropTracker =
      FirebaseFirestore.instance.collection('Croptracker');
  final CollectionReference _harvested =
      FirebaseFirestore.instance.collection('Harvested');
  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');
  final currentUser = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _cropNameController,
                  decoration: const InputDecoration(labelText: 'Crop Name'),
                ),
                TextField(
                  controller: _plantedController,
                  decoration: const InputDecoration(labelText: 'Date Planted'),
                ),
                TextField(
                  controller: _harvestController,
                  decoration: const InputDecoration(
                      labelText: 'Estimated Date to Harvest'),
                ),
                TextField(
                  controller: _statusController,
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    final String cropName = _cropNameController.text;
                    final String planted = _plantedController.text;
                    final String harvest = _harvestController.text;
                    final String status = _statusController.text;
                    FirebaseAuth auth = FirebaseAuth.instance;
                    User? user = auth.currentUser;
                    if (cropName != null) {
                      String? uid = user?.uid;
                      await _cropTracker.add({
                        "uid": uid,
                        "cropName": cropName,
                        "planted": planted,
                        "harvest": harvest,
                        "status": status,
                      });
                      _cropNameController.text = '';
                      _plantedController.text = '';
                      _harvestController.text = '';
                      _statusController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _cropNameController.text = documentSnapshot['cropName'];
      _plantedController.text = documentSnapshot['planted'];
      _harvestController.text = documentSnapshot['harvest'];
      _statusController.text = documentSnapshot['status'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _cropNameController,
                  decoration: const InputDecoration(labelText: 'Crop Name'),
                ),
                TextField(
                  controller: _plantedController,
                  decoration: const InputDecoration(labelText: 'Date Planted'),
                ),
                TextField(
                  controller: _harvestController,
                  decoration: const InputDecoration(
                      labelText: 'Estimated Date of Harvest'),
                ),
                TextField(
                  controller: _statusController,
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String cropName = _cropNameController.text;
                    final String planted = _plantedController.text;
                    final String harvest = _harvestController.text;
                    final String status = _statusController.text;
                    if (cropName != null) {
                      await _cropTracker.doc(documentSnapshot!.id).update({
                        "cropName": cropName,
                        "planted": planted,
                        "harvest": harvest,
                        "status": status,
                      });
                      _cropNameController.text = '';
                      _plantedController.text = '';
                      _harvestController.text = '';
                      _statusController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(
    String cropID,
  ) async {
    await _cropTracker.doc(cropID).delete();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a crop')));
  }

  Future<void> _deleteHarvested(
    String harvestedID,
  ) async {
    await _harvested.doc(harvestedID).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Harvested Crop')));
  }

  Future<void> transferData(DocumentSnapshot documentSnapshot) async {
    String cropName = documentSnapshot['cropName'];
    String planted = documentSnapshot['planted'];
    String uid = documentSnapshot['uid'];

    DateTime currentDate = DateTime.now();

    await _cropTracker.doc(documentSnapshot.id).update({
      'harvested': true, // Example field to mark as harvested
    });

    String formattedDate =
        DateFormat('yyyy-MM-dd').format(currentDate); // Format the date
    // Transfer the data to _harvested with the formatted date
    await _harvested.add({
      "uid": uid,
      'cropName': cropName,
      'planted': planted,
      'harvestedDate': formattedDate,
    });

    await _cropTracker.doc(documentSnapshot.id).delete();
  }

  Future<void> sellProduct([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _showPicker(context);
                  },
                  child: Text('Add Image')),
              TextField(
                controller: _cropNameController,
                decoration: const InputDecoration(labelText: 'Crop Name'),
              ),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: _farmerController,
                decoration: const InputDecoration(labelText: 'Farmer'),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Sell Product'),
                onPressed: () async {
                  // Validate required fields
                  if (_cropNameController.text.isEmpty ||
                      _priceController.text.isEmpty) {
                    // Show an error message or handle it in some way
                    return;
                  }

                  try {
                    final String cropName = _cropNameController.text;
                    final String category = _categoryController.text;
                    final String quantity = _quantityController.text;
                    final String price = _priceController.text;
                    final String farmerId =
                        _farmerController.text; // Assuming you have a farmerId

                    FirebaseAuth auth = FirebaseAuth.instance;
                    User? user = auth.currentUser;
                    String? uid = user?.uid;

                    // Fetch farmer's fullname from the "farmers" collection
                    DocumentSnapshot farmerSnapshot = await FirebaseFirestore
                        .instance
                        .collection("farmers")
                        .doc(farmerId)
                        .get();
                    if (farmerSnapshot.exists) {
                      String fullname = farmerSnapshot["fullname"];

                      // Ensure that your image handling logic is correctly implemented
                      String imageUrl = "your_image_url_here";

                      await _marketplace.add({
                        "uid": uid,
                        "cropName": cropName,
                        "category": category,
                        "quantity": quantity,
                        "price": price,
                        "farmer": fullname,
                        "location": _locationController.text,
                        "description": _descriptionController.text,
                        "image": imageUrl,
                      });

                      _cropNameController.text = '';
                      _categoryController.text = '';
                      _quantityController.text = '';
                      _priceController.text = '';
                      _farmerController.text = '';
                      _locationController.text = '';
                      _descriptionController.text = '';

                      Navigator.of(context).pop();
                    } else {
                      // Handle the case where the farmer document doesn't exist
                      print("Farmer not found");
                    }
                  } catch (e) {
                    // Handle errors (e.g., show an error message)
                    print("Error: $e");
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFFA9AF7E),
              centerTitle: true,
              title: Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 32.0,
                  ),
                  SizedBox(width: 7.0),
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
            body: StreamBuilder(
                stream: _cropTracker
                    .where('uid', isEqualTo: currentUser?.uid)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasError) {
                    return Center(
                        child: Text(
                            'Some error occurred ${streamSnapshot.error}'));
                  }
                  if (streamSnapshot.hasData) {
                    QuerySnapshot<Object?>? querySnapshot = streamSnapshot.data;
                    List<QueryDocumentSnapshot<Object?>>? documents =
                        querySnapshot?.docs;
                    List<Map>? items =
                        documents?.map((e) => e.data() as Map).toList();

                    return Column(children: [
                      TabBar(
                        indicatorColor: Color(0xFF557153),
                        tabs: [
                          Tab(
                            child: Text(
                              'Harvest',
                              style: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  color: Color(0xFF718C53)),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Harvested',
                              style: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  color: Color(0xFF718C53)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '     Crop Tracker',
                              style: TextStyle(
                                  fontSize: 20.0, fontFamily: 'Poppins-Bold'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Show:',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Poppins-Regular'),
                                ),
                                SizedBox(width: 8.0),
                                DropdownButton<int>(
                                  value: 15,
                                  items: [
                                    DropdownMenuItem<int>(
                                      value: 15,
                                      child: Text('15'),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: 25,
                                      child: Text('25'),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: 50,
                                      child: Text('50'),
                                    ),
                                  ],
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                width: 200.0,
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
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(children: [
                          Stack(
                            children: [
                              GridView.builder(
                                  itemCount:
                                      streamSnapshot.data?.docs.length ?? 0,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 3 / 2.7,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // Get the item at this index from streamSnapshot
                                    final DocumentSnapshot documentSnapshot =
                                        streamSnapshot.data!.docs[index];
                                    final Map thisItem = items![index];

                                    {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Card(
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            8, 10, 8, 4),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            '${thisItem['cropName']}',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 9),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Date Planted: ',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${thisItem['planted']}',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 4),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Estimated Date to Harvest:',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                '${thisItem['harvest']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Status:',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                '${thisItem['status']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
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
                                              Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: PopupMenuButton<
                                                          String>(
                                                      icon: Icon(
                                                        Icons.more_vert,
                                                        color:
                                                            Color(0xFF9DC08B),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      itemBuilder:
                                                          (BuildContext
                                                                  context) =>
                                                              [
                                                                PopupMenuItem<
                                                                    String>(
                                                                  value: 'edit',
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .edit,
                                                                        color: Color(0xFF9DC08B)
                                                                            .withAlpha(180),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              8),
                                                                      Text(
                                                                        'Edit',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                PopupMenuItem<
                                                                    String>(
                                                                  value:
                                                                      'delete',
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Color(
                                                                            0xFF9DC08B),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              8),
                                                                      Text(
                                                                        'Delete',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                PopupMenuItem<
                                                                    String>(
                                                                  value:
                                                                      'harvest',
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .clean_hands_sharp,
                                                                        color: Color(0xFF9DC08B)
                                                                            .withAlpha(180),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              8),
                                                                      Text(
                                                                        'Harvest',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                      onSelected:
                                                          (String value) {
                                                        if (value == 'edit') {
                                                          _update(
                                                              documentSnapshot); // Call _update directly
                                                        } else if (value ==
                                                            'delete') {
                                                          _delete(documentSnapshot
                                                              .id); // Call _delete directly
                                                        } else if (value ==
                                                            'harvest') {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                  title: Text(
                                                                    'Ready to Harvest?',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-Regular',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  content: Text(
                                                                    "Are you sure this is ready to harvest? This can't be undone and it will be moved to the Harvested tab.",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Poppins-Regular',
                                                                      fontSize:
                                                                          13.8,
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      child:
                                                                          Text(
                                                                        'No',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text(
                                                                          'Yes',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-Regular',
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Color(0xFF9DC08B).withAlpha(180),
                                                                          )),
                                                                      onPressed:
                                                                          () async {
                                                                        transferData(
                                                                            documentSnapshot);

                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  ]);
                                                            },
                                                          );
                                                        }
                                                      }))
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    ;
                                  }),
                              Positioned(
                                bottom: 16.0,
                                right: 16.0,
                                child: FloatingActionButton(
                                  onPressed: () => _create(),
                                  child: Icon(Icons.add),
                                  backgroundColor:
                                      Color.fromRGBO(157, 192, 139, 1),
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder(
                              stream: _harvested.snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                if (streamSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Some error occurred ${streamSnapshot.error}'));
                                }
                                if (streamSnapshot.hasData) {
                                  QuerySnapshot<Object?>? querySnapshot =
                                      streamSnapshot.data;
                                  List<QueryDocumentSnapshot<Object?>>?
                                      documents = querySnapshot?.docs;
                                  List<Map>? items = documents
                                      ?.map((e) => e.data() as Map)
                                      .toList();
                                  return Stack(
                                    children: [
                                      GridView.builder(
                                        itemCount:
                                            streamSnapshot.data?.docs.length ??
                                                0,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 3 / 2.7,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // Get the item at this index from streamSnapshot
                                          final DocumentSnapshot
                                              documentSnapshot =
                                              streamSnapshot.data!.docs[index];
                                          final Map thisItem = items![index];

                                          return GestureDetector(
                                            onTap: () {},
                                            child: Card(
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Center(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                8, 2, 8, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                '${thisItem['cropName']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 0),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Date Planted: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${thisItem['planted']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 4),
                                                            SizedBox(height: 4),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Harvested Date:',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    '${thisItem['harvestedDate']}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 7),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  sellProduct(),
                                                              child: Text(
                                                                'Add Product in Marketplace',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-Regular',
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              style:
                                                                  ButtonStyle(
                                                                foregroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .green),
                                                                padding:
                                                                    MaterialStateProperty
                                                                        .all<
                                                                            EdgeInsetsGeometry>(
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          16),
                                                                ),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                    top: 5,
                                                    right: 8,
                                                    child:
                                                        PopupMenuButton<String>(
                                                      icon: Icon(
                                                        Icons.more_horiz,
                                                        color:
                                                            Color(0xFF9DC08B),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          [
                                                        PopupMenuItem<String>(
                                                          value: 'delete',
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.delete,
                                                                color: Color(
                                                                    0xFF9DC08B),
                                                              ),
                                                              SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                'Delete',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-Regular',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                      onSelected:
                                                          (String value) {
                                                        if (value == 'edit') {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Center(
                                                                  child: Text(
                                                                    'Edit Details',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                content: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    TextFormField(
                                                                      readOnly:
                                                                          true,
                                                                      onTap:
                                                                          () {
                                                                        _selectDatePlanted1(
                                                                            context);
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            "Date Planted",
                                                                        labelStyle:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                          fontSize:
                                                                              13,
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                208,
                                                                                216,
                                                                                144),
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(15),
                                                                        ),
                                                                      ),
                                                                      controller:
                                                                          _plantedController,
                                                                      onSaved:
                                                                          (value) {},
                                                                    ),
                                                                    TextFormField(
                                                                      readOnly:
                                                                          true,
                                                                      onTap:
                                                                          () {
                                                                        _selectHarvestedDate(
                                                                            context);
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            "Harvested Date",
                                                                        labelStyle:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                          fontSize:
                                                                              13,
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                208,
                                                                                216,
                                                                                144),
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(15),
                                                                        ),
                                                                      ),
                                                                      controller:
                                                                          _harvestController,
                                                                      onSaved:
                                                                          (value) {},
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: 'Poppins-Regular',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            String
                                                                                postContent =
                                                                                _postController.text;
                                                                            print(postContent);
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Save',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Poppins-Regular',
                                                                            ),
                                                                          ),
                                                                          style:
                                                                              TextButton.styleFrom(
                                                                            backgroundColor: Color.fromRGBO(
                                                                                157,
                                                                                192,
                                                                                139,
                                                                                1),
                                                                            primary:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        } else if (value ==
                                                            'delete') {
                                                          _deleteHarvested(
                                                              documentSnapshot
                                                                  .id);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              })
                        ]),
                      )
                    ]);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }

  void _UshowPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        UimgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      UimgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _saveInformation() {}
}
