import 'dart:io';

import 'package:capstone/farmer/farmer_archive.dart';
import 'package:capstone/farmer/product_details.dart';
import 'package:capstone/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostedProducts extends StatefulWidget {
  @override
  _PostedProductsState createState() => _PostedProductsState();
}

class _PostedProductsState extends State<PostedProducts> {
  bool _isButtonVisible = true;
  final _postController = TextEditingController();
  File? _selectedImage;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  DateTime? selectedDate;
  bool _isImageSelected = false;

  TextEditingController _cropNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String imageUrl = '';
  String selectedUnit = "Select Unit";

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

  final currentUser = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();
  final CollectionReference _marketplace =
      FirebaseFirestore.instance.collection('Marketplace');

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _cropNameController.text = documentSnapshot['cropName'];
      _unitController.text = documentSnapshot['unit'];
      _quantityController.text = documentSnapshot['quantity'];
      _priceController.text = documentSnapshot['price'];
      _descriptionController.text = documentSnapshot['description'];
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
                    SizedBox(height: 16.0),
                    Center(
                      child: Text(
                        'Edit Crop',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Image',
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
                    TextFormField(
                      controller: _cropNameController,
                      decoration: InputDecoration(
                        labelText: "Crop's Name",
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
                        if (value!.isEmpty) {
                          return "Crop's name is required";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: "Price",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
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
                          return "Price is required";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: "Quantity",
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
                        if (value!.isEmpty) {
                          return "Quantity is required";
                        }
                        return null;
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
                                  content: Text('Please select a valid unit.'),
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
                        labelText: "Unit",
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
                      readOnly: true,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 13,
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
                          return "Description is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins-Regular',
                            ),
                          ),
                        ),
                        TextButton(
                          child: const Text(
                            'Save',
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromRGBO(157, 192, 139, 1),
                            primary: Colors.white,
                          ),
                          onPressed: () async {
                            final String cropName = _cropNameController.text;
                            final String unit = _unitController.text;
                            final String quantity = _quantityController.text;
                            final String price = _priceController.text;
                            final String description =
                                _descriptionController.text;
                            if (cropName != null) {
                              await _marketplace
                                  .doc(documentSnapshot!.id)
                                  .update({
                                "cropName": cropName,
                                "unit": unit,
                                "quantity": quantity,
                                "price": price,
                                "description": description,
                                "image": imageUrl,
                              });
                              _cropNameController.text = '';
                              _unitController.text = '';
                              _quantityController.text = '';
                              _priceController.text = '';
                              _descriptionController.text = '';
                              Navigator.of(context).pop();
                            }
                          },
                        )
                      ],
                    ),
                  ]));
        });
  }

  Future<void> _delete(
    String cropID,
  ) async {
    await _marketplace.doc(cropID).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  Future<void> archiveProduct(DocumentSnapshot documentSnapshot) async {
    // Get the reference to the document
    final documentReference = _marketplace.doc(documentSnapshot.id);

    try {
      // Update the "archived" field to true
      await documentReference.update({'archived': true});
      print('The product is archived successfully.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The product is archived successfully.'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    } catch (error) {
      print('Error archiving document: $error');
    }
  }

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
                  fontSize: 14.0,
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
                width: 170.0,
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
            stream: _marketplace
                .where('uid', isEqualTo: currentUser?.uid)
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

                return SingleChildScrollView(
                    child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            'Posted Products',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins-Bold',
                            ),
                          ),
                        ),
                        SizedBox(width: 165.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FarmerArchive(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/archiveicon.png',
                                width: 30,
                                height: 30,
                                color: Color(0xFF5c9348),
                              ),
                            ),
                            Text(
                              'Archive',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GridView.builder(
                    itemCount: streamSnapshot.data?.docs.length ?? 0,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(1),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.5 / 3.9,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      // Get the item at this index from streamSnapshot
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
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
                          child: Stack(
                            children: [
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
                                            width: 200,
                                            height: 150,
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
                                              'Price: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
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
                                              'Quantity: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '${thisItem['quantity']}',
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
                                              'Unit: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '${thisItem['unit']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 8,
                                child: PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Color(0xFF9DC08B),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Color(0xFF9DC08B)
                                                .withAlpha(180),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Edit',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Color(0xFF9DC08B),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Delete',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'archive',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.archive,
                                            color: Color(0xFF9DC08B),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Archive Product",
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (String value) {
                                    if (value == 'edit') {
                                      _update(documentSnapshot);
                                    } else if (value == 'delete') {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Delete Product?',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Regular',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: Text(
                                                "This can't be undone and it will be removed in marketplace.",
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 13.8,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Delete',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(0xFF9DC08B)
                                                            .withAlpha(180),
                                                      )),
                                                  onPressed: () {
                                                    _delete(
                                                        documentSnapshot.id);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    } else if (value == 'archive') {
                                      archiveProduct(documentSnapshot);
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
                ]));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
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
