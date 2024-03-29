import 'dart:io';

import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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
      home: CropTrackerScreen(),
    );
  }
}

class CropTrackerScreen extends StatefulWidget {
  @override
  _CropTrackerScreenState createState() => _CropTrackerScreenState();
}

class _CropTrackerScreenState extends State<CropTrackerScreen>
    with SingleTickerProviderStateMixin {
  String? selectedStatus;
  String? selectedLocation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  TextEditingController _cropNameController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _harvestController = TextEditingController();
  TextEditingController _plantedController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String imageUrl = '';

  String _searchText = '';
  bool _isButtonVisible = true;
  late TabController _tabController;
  final _postController = TextEditingController();
  DateTime? selectedDate;
  bool _isImageSelected = false;
  String selectedCategory = "Select Category";
  String selectedUnit = "Select Unit";

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

  final CollectionReference _user =
      FirebaseFirestore.instance.collection('Users');
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
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      "farmerCropTrackerAddText2".tr(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _cropNameController,
                    decoration: InputDecoration(
                      labelText: "farmerCropTrackerAddText3".tr(),
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFA9AF7E),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Crop's name is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        _plantedController.text =
                            pickedDate.toIso8601String().split('T')[0];
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "farmerCropTrackerDP".tr(),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 208, 216, 144),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Date Planted is required';
                      }
                      return null;
                    },
                    controller: _plantedController,
                    onSaved: (value) {},
                  ),
                  TextFormField(
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        _harvestController.text =
                            pickedDate.toIso8601String().split('T')[0];
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "farmerCropTrackerETH".tr(),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 208, 216, 144),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Estimated Date of Harvest is required';
                      }
                      return null;
                    },
                    controller: _harvestController,
                    onSaved: (value) {},
                  ),
                  TextFormField(
                    controller: _statusController,
                    decoration: InputDecoration(
                      labelText: "Status",
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFA9AF7E),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Status is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          "userCancel".tr(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins-Regular',
                            fontSize: 13.5,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                          "farmerPageButton18".tr(),
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final String cropName = _cropNameController.text;
                            final String planted = _plantedController.text;
                            final String harvest = _harvestController.text;
                            final String status = _statusController.text;

                            String cropID = const Uuid().v4();

                            FirebaseAuth auth = FirebaseAuth.instance;
                            User? user = auth.currentUser;
                            if (cropName != null) {
                              String? uid = user?.uid;
                              await _cropTracker.add({
                                "uid": uid,
                                "cropID": cropID,
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
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(157, 192, 139, 1),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> othersellProduct([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      "farmerCropTrackerAddProduct".tr(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "farmerCropTrackerAddImage".tr(),
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 15.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          _showPicker(context);
                          setState(() {
                            _isImageSelected = true;
                          });
                        },
                        icon: Icon(Icons.file_upload),
                      ),
                    ],
                  ),
                  if (!_isImageSelected)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Image is required.",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .where('uid', isEqualTo: currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        QueryDocumentSnapshot userData =
                            snapshot.data!.docs.first;
                        String fullName = userData.get('fullname').toString();
                        _fullnameController.text = fullName;
                        return TextFormField(
                          maxLines: 1,
                          enabled: false,
                          controller: _fullnameController,
                          decoration: InputDecoration(
                            labelText: "farmerCropTrackerFarmerName".tr(),
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 15.5,
                              color: Colors.black,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                            ),
                          ),
                        );
                      } else {
                        return Text("No data available");
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLocation = newValue!;
                        _locationController.text = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "farmerCropTrackerAddProductLocation".tr(),
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFA9AF7E),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Location is required";
                      }
                      return null;
                    },
                    items: <String>[
                      "Brgy. Bagong Buhay",
                      "Brgy. Bagong Sikat",
                      "Brgy. Bagong Silang",
                      "Brgy. Concepcion",
                      "Brgy. Entablado",
                      "Brgy. Maligaya",
                      "Brgy. Natividad North",
                      "Brgy. Natividad South",
                      "Brgy. Palasinan",
                      "Brgy. Polilio",
                      "Brgy. San Antonio",
                      "Brgy. San Carlos",
                      "Brgy. San Fernando Norte",
                      "Brgy. San Fernando Sur",
                      "Brgy. San Gregorio",
                      "Brgy. San Juan North",
                      "Brgy. San Juan South",
                      "Brgy. San Roque",
                      "Brgy. San Vicente",
                      "Brgy. Santa Ines",
                      "Brgy. Santa Isabel",
                      "Brgy. Santa Rita",
                      "Brgy. Sinipit",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                        _categoryController.text = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "text160".tr(),
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFA9AF7E),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value == "Select Category") {
                        return "Category is required";
                      }
                      return null;
                    },
                    items: <String>[
                      "Select Category",
                      "Fertilizer",
                      "Others",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    maxLines: 1,
                    controller: _cropNameController,
                    decoration: InputDecoration(
                      labelText: "farmerCropTrackerProductName".tr(),
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15.5,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Product name is required";
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUnit = newValue!;
                        _unitController.text = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "farmerCropTrackerAddProductUnit".tr(),
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFA9AF7E),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value == "Select Unit") {
                        return "Unit is required";
                      }
                      return null;
                    },
                    items: <String>[
                      "Select Unit",
                      "Kilograms",
                      "Sacks",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    maxLines: 1,
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: "farmerCropTrackerText13".tr(),
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15.5,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Quantity is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    maxLines: 1,
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      labelText: "text63".tr(),
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Price is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    maxLines: 3,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "text164".tr(),
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Description is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          "userCancel".tr(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins-Regular',
                            fontSize: 13.5,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                          "farmerPageButton18".tr(),
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final String cropName = _cropNameController.text;
                            final String unit = _unitController.text;
                            final String category = _categoryController.text;
                            final String quantity = _quantityController.text;
                            final String price = _priceController.text;
                            final String fullname = _fullnameController.text;
                            final String location = _locationController.text;
                            final String description =
                                _descriptionController.text;
                            String cropID = const Uuid().v4();
                            FirebaseAuth auth = FirebaseAuth.instance;
                            User? user = auth.currentUser;

                            if (cropName != null) {
                              String? uid = user?.uid;
                              await _marketplace.add({
                                "uid": uid,
                                "cropID": cropID,
                                "cropName": cropName,
                                "unit": unit,
                                "category": category,
                                "quantity": quantity,
                                "price": price,
                                "fullname": fullname,
                                "location": location,
                                "description": description,
                                "image": imageUrl,
                                "archived": false,
                              });

                              await _harvested
                                  .doc(documentSnapshot?.id)
                                  .delete();
                              Navigator.of(context).pop();

                              _cropNameController.text = '';
                              _categoryController.text = '';
                              _quantityController.text = '';
                              _unitController.text = '';
                              _priceController.text = '';
                              _fullnameController.text = '';
                              _locationController.text = '';
                              _descriptionController.text = '';
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(157, 192, 139, 1),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Center(
                  child: Text(
                    "farmerEditCropTracker".tr(),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _cropNameController,
                  decoration: InputDecoration(
                    labelText: "farmerCropTrackerAddText3".tr(),
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFA9AF7E),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Crop's name is required";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: true,
                  controller: _plantedController,
                  decoration: InputDecoration(
                    labelText: "farmerCropTrackerDP".tr(),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins-Regular',
                      fontSize: 15,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 208, 216, 144),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _plantedController.text =
                            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Date Planted is required";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: true,
                  controller: _harvestController,
                  decoration: InputDecoration(
                    labelText: "farmerCropTrackerETH".tr(),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins-Regular',
                      fontSize: 15,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 208, 216, 144),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _harvestController.text =
                            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Date Harvested is required";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _statusController,
                  decoration: InputDecoration(
                    labelText: "Status",
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFA9AF7E),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Status is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "userCancel".tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text("farmerPageButton3".tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(157, 192, 139, 1),
                        primary: Colors.white,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final String cropName = _cropNameController.text;
                          final String planted = _plantedController.text;
                          final String harvest = _harvestController.text;
                          final String status = _statusController.text;

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
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteHarvest(
    String harvestID,
  ) async {
    await _cropTracker.doc(harvestID).delete();
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
    String cropID = documentSnapshot['cropID'];
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
      "cropID": cropID,
      'cropName': cropName,
      'planted': planted,
      'harvestedDate': formattedDate,
    });

    await _cropTracker.doc(documentSnapshot.id).delete();
  }

  Future<void> sellProduct([DocumentSnapshot? documentSnapshot]) async {
    String cropID = documentSnapshot?['cropID'];
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "farmerCropTrackerAddImage".tr(),
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 15.5,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              _showPicker(context);
                              setState(() {
                                _isImageSelected = true;
                              });
                            },
                            icon: Icon(Icons.file_upload),
                          ),
                        ],
                      ),
                      if (!_isImageSelected)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Image is required.",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .where('uid', isEqualTo: currentUser?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            QueryDocumentSnapshot userData =
                                snapshot.data!.docs.first;
                            String fullName =
                                userData.get('fullname').toString();
                            _fullnameController.text = fullName;
                            return TextFormField(
                              maxLines: 1,
                              enabled: false,
                              controller: _fullnameController,
                              decoration: InputDecoration(
                                labelText: "farmerCropTrackerFarmerName".tr(),
                                labelStyle: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 15.5,
                                  color: Colors.black,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA9AF7E)),
                                ),
                              ),
                            );
                          } else {
                            return Text("No data available");
                          }
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != "Select Category") {
                              selectedCategory = newValue!;
                              _categoryController.text = newValue;
                            } else {
                              // Optional: You can show a message or handle it in a way that makes sense for your application.
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Invalid Selection'),
                                    content:
                                        Text('Please select a valid category.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "text160".tr(),
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 15.5,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFA9AF7E),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == "Select Category") {
                            return "Category is required";
                          }
                          return null;
                        },
                        items: <String>[
                          "Select Category",
                          "Fruits",
                          "Vegetables",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Harvested')
                            .where('uid', isEqualTo: currentUser?.uid)
                            .where('cropID', isEqualTo: cropID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            QueryDocumentSnapshot cropData =
                                snapshot.data!.docs.first;
                            String cropName =
                                cropData.get('cropName').toString();
                            _cropNameController.text = cropName;

                            return TextFormField(
                              maxLines: 1,
                              enabled: false,
                              controller: _cropNameController,
                              decoration: InputDecoration(
                                labelText: "farmerCropTrackerProductName".tr(),
                                labelStyle: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 15.5,
                                  color: Colors.black,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA9AF7E)),
                                ),
                              ),
                            );
                          } else {
                            return Text("No data available");
                          }
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedUnit,
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != "Select Unit") {
                              selectedUnit = newValue!;
                              _unitController.text = newValue;
                            } else {
                              // Optional: You can show a message or handle it in a way that makes sense for your application.
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Invalid Selection'),
                                    content:
                                        Text('Please select a valid unit.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "farmerCropTrackerAddProductUnit".tr(),
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 15.5,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFA9AF7E),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == "Select Unit") {
                            return "Unit is required";
                          }
                          return null;
                        },
                        items: <String>[
                          "Select Unit",
                          "Kilograms",
                          "Sacks",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                          labelText: "farmerCropTrackerText13".tr(),
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 15.5,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Quantity is required";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                          labelText: "text63".tr(),
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 15.5,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Price is required";
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedLocation,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLocation = newValue!;
                            _locationController.text = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "farmerCropTrackerAddProductLocation".tr(),
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 15.5,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFA9AF7E),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Location is required";
                          }
                          return null;
                        },
                        items: <String>[
                          "Brgy. Bagong Buhay",
                          "Brgy. Bagong Sikat",
                          "Brgy. Bagong Silang",
                          "Brgy. Concepcion",
                          "Brgy. Entablado",
                          "Brgy. Maligaya",
                          "Brgy. Natividad North",
                          "Brgy. Natividad South",
                          "Brgy. Palasinan",
                          "Brgy. Polilio",
                          "Brgy. San Antonio",
                          "Brgy. San Carlos",
                          "Brgy. San Fernando Norte",
                          "Brgy. San Fernando Sur",
                          "Brgy. San Gregorio",
                          "Brgy. San Juan North",
                          "Brgy. San Juan South",
                          "Brgy. San Roque",
                          "Brgy. San Vicente",
                          "Brgy. Santa Ines",
                          "Brgy. Santa Isabel",
                          "Brgy. Santa Rita",
                          "Brgy. Sinipit",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 15.5,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA9AF7E)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Description is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "userCancel".tr(),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final String cropName =
                                    _cropNameController.text;
                                final String unit = _unitController.text;
                                final String category =
                                    _categoryController.text;
                                final String quantity =
                                    _quantityController.text;
                                final String price = _priceController.text;
                                final String fullname =
                                    _fullnameController.text;
                                final String location =
                                    _locationController.text;
                                final String description =
                                    _descriptionController.text;
                                FirebaseAuth auth = FirebaseAuth.instance;
                                User? user = auth.currentUser;

                                if (cropName != null) {
                                  String? uid = user?.uid;
                                  await _marketplace.add({
                                    "uid": uid,
                                    "cropID": cropID,
                                    "cropName": cropName,
                                    "unit": unit,
                                    "category": category,
                                    "quantity": quantity,
                                    "price": price,
                                    "fullname": fullname,
                                    "location": location,
                                    "description": description,
                                    "image": imageUrl,
                                    "archived": false,
                                  });

                                  await _harvested
                                      .doc(documentSnapshot?.id)
                                      .delete();
                                  Navigator.of(context).pop();

                                  _cropNameController.text = '';
                                  _categoryController.text = '';
                                  _quantityController.text = '';
                                  _unitController.text = '';
                                  _priceController.text = '';
                                  _fullnameController.text = '';
                                  _locationController.text = '';
                                  _descriptionController.text = '';
                                }
                              }
                            },
                            child: Text(
                              "farmerPageButton3".tr(),
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromRGBO(157, 192, 139, 1),
                              foregroundColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ]))));
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
                    List<Map>? filteredItems = items
                        ?.where((item) => item['cropName']
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()))
                        .toList();

                    return Column(children: [
                      TabBar(
                        indicatorColor: Color(0xFF557153),
                        tabs: [
                          Tab(
                            child: Text(
                              "farmerCropTrackerNavigationText1".tr(),
                              style: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  color: Color(0xFF718C53)),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "farmerCropTrackerNavigationText2".tr(),
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
                              "userFTCrop".tr(),
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
                            child: Padding(
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
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(children: [
                          Stack(
                            children: [
                              GridView.builder(
                                  itemCount: filteredItems?.length ?? 0,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 10 / 11,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // Get the item at this index from streamSnapshot
                                    final DocumentSnapshot documentSnapshot =
                                        streamSnapshot.data!.docs[index];
                                    final Map thisItem = filteredItems![index];

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
                                                                "farmerCropTrackerDP1"
                                                                    .tr(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      "Poppins",
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                '${thisItem['planted']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                                                                "farmerCropTrackerETH1"
                                                                    .tr(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      "Poppins",
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
                                                                  fontFamily:
                                                                      "Poppins",
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
                                                                        "farmerPageButton1"
                                                                            .tr(),
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
                                                                        "farmerPageButton2"
                                                                            .tr(),
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
                                                                        "farmerPageButton11"
                                                                            .tr(),
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
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    "farmerDeleteTracker"
                                                                        .tr(),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-Regular',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  content: Text(
                                                                    "farmerDeleteTrackerCantBeUndone"
                                                                        .tr(),
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
                                                                        "userCancel"
                                                                            .tr(),
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
                                                                          "farmerPageButton2"
                                                                              .tr(),
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
                                                                          () {
                                                                        _deleteHarvest(
                                                                            documentSnapshot.id);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        } else if (value ==
                                                            'harvest') {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                  title: Text(
                                                                    "farmerReadytoHarvest"
                                                                        .tr(),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-Regular',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  content: Text(
                                                                    "farmerReadytoHarvest1"
                                                                        .tr(),
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
                                                                        "userCancel"
                                                                            .tr(),
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
                                                                          "farmerPageButton5"
                                                                              .tr(),
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
                              stream: _harvested
                                  .where('uid', isEqualTo: currentUser?.uid)
                                  .snapshots(),
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

                                  List<Map>? filteredItems = items
                                      ?.where((item) => item['cropName']
                                          .toLowerCase()
                                          .contains(_searchText.toLowerCase()))
                                      .toList();
                                  return Stack(
                                    children: [
                                      GridView.builder(
                                        itemCount: filteredItems?.length ?? 0,
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
                                          final Map thisItem =
                                              filteredItems![index];

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
                                                                    "farmerCropTrackerDP1"
                                                                        .tr(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          "Poppins",
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
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
                                                                    "farmerCropTrackerHD"
                                                                        .tr(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            "Poppins"),
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
                                                            Visibility(
                                                              visible:
                                                                  false, // Set this to true or false based on your condition
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        1.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Crop ID',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            4),
                                                                    Text(
                                                                      '${thisItem['cropID']}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 7),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  sellProduct(
                                                                      documentSnapshot),
                                                              child: Text(
                                                                "farmerCropTrackerHarvestedSellProductButton"
                                                                    .tr(),
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
                                                    child: PopupMenuButton<
                                                            String>(
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
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context) =>
                                                                [
                                                                  PopupMenuItem<
                                                                      String>(
                                                                    value:
                                                                        'delete',
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Color(0xFF9DC08B),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                8),
                                                                        Text(
                                                                          "farmerPageButton2"
                                                                              .tr(),
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
                                                          if (value ==
                                                              'delete') {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      "farmerDeleteTracker"
                                                                          .tr(),
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      "farmerDeleteTrackerCantBeUndone"
                                                                          .tr(),
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
                                                                          "userCancel"
                                                                              .tr(),
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
                                                                            "farmerPageButton2"
                                                                                .tr(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Poppins-Regular',
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color(0xFF9DC08B).withAlpha(180),
                                                                            )),
                                                                        onPressed:
                                                                            () {
                                                                          _deleteHarvested(
                                                                              documentSnapshot.id);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          }
                                                          ;
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 16),
                                      Positioned(
                                        bottom: 16.0,
                                        right: 16.0,
                                        child: FloatingActionButton(
                                          onPressed: () => othersellProduct(),
                                          child: Icon(Icons.add),
                                          backgroundColor:
                                              Color.fromRGBO(157, 192, 139, 1),
                                        ),
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
}
