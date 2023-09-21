import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarketplaceItem {
  final String crops;
  final String datedplanted;
  final String etharvest1;
  final String status;

  MarketplaceItem({
    required this.crops,
    required this.datedplanted,
    required this.etharvest1,
    required this.status,
  });
}

class HarvestedItem {
  final String cropsharvested;
  final String cropsquantity;
  final String etharvest;
  final String imageUrl1;

  HarvestedItem({
    required this.cropsharvested,
    required this.cropsquantity,
    required this.etharvest,
    required this.imageUrl1,
  });
}

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
  String _searchText = '';
  List<HarvestedItem> filteredItems = [];
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

  final CollectionReference _cropTracker =
      FirebaseFirestore.instance.collection('Croptracker');
  final CollectionReference _harvested =
      FirebaseFirestore.instance.collection('Harvested');

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

                    if (cropName != null) {
                      await _cropTracker.add({
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
    await _cropTracker.doc(harvestedID).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Harvested Crop')));
  }

  Future<void> _addProduct([DocumentSnapshot? documentSnapshot]) async {
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
                    final String status = _harvestController.text;

                    if (cropName != null) {
                      await _harvested.add({
                        "cropName": cropName,
                        "planted": planted,
                        "harvest": harvest,
                        'status': status
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

  final List<MarketplaceItem> items = [
    MarketplaceItem(
      crops: 'Tomato',
      datedplanted: '05/11/2020',
      etharvest1: '05/11/2021',
      status: 'Ready to Harvest',
    ),
    MarketplaceItem(
      crops: 'Onion',
      datedplanted: '05/11/2020',
      etharvest1: '05/11/2021',
      status: 'Ready to Harvest',
    ),
    MarketplaceItem(
      crops: 'Pechay',
      datedplanted: '05/11/2020',
      etharvest1: '05/11/2021',
      status: 'Delayed due to typhoon',
    ),
    MarketplaceItem(
      crops: 'Rice',
      datedplanted: '05/11/2020',
      etharvest1: '05/11/2021',
      status: 'Delayed due to typhoon',
    ),
    MarketplaceItem(
      crops: 'Calamansi',
      datedplanted: '05/11/2020',
      etharvest1: '05/11/2021',
      status: 'Delayed due to typhoon',
    ),
    MarketplaceItem(
      crops: 'Corn',
      datedplanted: '05/11/2020',
      etharvest1: '05/11/2021',
      status: 'Ready to Harvest',
    ),
  ];

  final List<HarvestedItem> harvesteditems = [
    HarvestedItem(
      cropsharvested: 'Squash',
      cropsquantity: '05/11/2020',
      etharvest: '05/11/2021',
      imageUrl1: 'assets/kalabasa.png',
    ),
    HarvestedItem(
      cropsharvested: 'Corn',
      cropsquantity: '05/11/2020',
      etharvest: ' 05/11/2021',
      imageUrl1: 'assets/corn.png',
    ),
    HarvestedItem(
      cropsharvested: 'Watermelon',
      cropsquantity: '05/11/2020',
      etharvest: '05/11/2021',
      imageUrl1: 'assets/pakwan.png',
    ),
    HarvestedItem(
      cropsharvested: 'Siling Labuyo',
      cropsquantity: '05/11/2020',
      etharvest: '05/11/2021',
      imageUrl1: 'assets/sili.png',
    ),
    HarvestedItem(
      cropsharvested: 'Pechay',
      cropsquantity: '05/11/2020',
      etharvest: '05/11/2021',
      imageUrl1: 'assets/pechay.png',
    ),
    HarvestedItem(
      cropsharvested: 'Calamansi',
      cropsquantity: '05/11/2020',
      etharvest: '05/11/2021',
      imageUrl1: 'assets/calamansi.png',
    ),
  ];

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
                stream: _cropTracker.snapshots(),
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
                                                                          () {
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
                                itemBuilder: (BuildContext context, int index) {
                                  // Get the item at this index from streamSnapshot
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  final Map thisItem = items![index];

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
                                              Expanded(
                                                child: Center(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.asset(
                                                        '${thisItem['imageUrl']}',
                                                        fit: BoxFit.cover,
                                                        width: 200,
                                                        height: 125,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    8, 2, 8, 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        '${thisItem['Crops']}',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 0),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Date Planted: ',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${thisItem['quantity']}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4),
                                                    SizedBox(height: 4),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Harvested Date:',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            '${thisItem['harvest']}',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 7),
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Center(
                                                                child: Text(
                                                                  'Add Product',
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
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          'Add Image',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-Regular',
                                                                            fontSize:
                                                                                15.5,
                                                                          )),
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {},
                                                                        icon: Icon(
                                                                            Icons.file_upload),
                                                                      ),
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {},
                                                                        icon: Icon(
                                                                            Icons.camera_alt),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  TextField(
                                                                    maxLines: 1,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          "Price",
                                                                      labelStyle: TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                          fontSize:
                                                                              15.5,
                                                                          color:
                                                                              Colors.black),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Color(0xFFA9AF7E)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextField(
                                                                    maxLines: 1,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          "Farmer",
                                                                      labelStyle: TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                          fontSize:
                                                                              15.5,
                                                                          color:
                                                                              Colors.black),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Color(0xFFA9AF7E)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextField(
                                                                    maxLines: 2,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          "Location",
                                                                      labelStyle: TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                          fontSize:
                                                                              15.5,
                                                                          color:
                                                                              Colors.black),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Color(0xFFA9AF7E)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextField(
                                                                    maxLines: 4,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          "Description",
                                                                      labelStyle: TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-Regular',
                                                                          fontSize:
                                                                              15.5,
                                                                          color:
                                                                              Colors.black),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Color(0xFFA9AF7E)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          16.0),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                'Poppins-Regular',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          String
                                                                              postContent =
                                                                              _postController.text;
                                                                          print(
                                                                              postContent);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Save',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-Regular',
                                                                          ),
                                                                        ),
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          backgroundColor: Color.fromRGBO(
                                                                              157,
                                                                              192,
                                                                              139,
                                                                              1),
                                                                          foregroundColor:
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
                                                      },
                                                      child: Text(
                                                        'Add Product in Marketplace',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors
                                                                        .white),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors
                                                                        .green),
                                                        padding:
                                                            MaterialStateProperty
                                                                .all<
                                                                    EdgeInsetsGeometry>(
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 16),
                                                        ),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
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
                                            child: PopupMenuButton<String>(
                                              icon: Icon(
                                                Icons.more_horiz,
                                                color: Color(0xFF9DC08B),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              itemBuilder:
                                                  (BuildContext context) => [
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
                                                          fontFamily:
                                                              'Poppins-Regular',
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
                                                        color:
                                                            Color(0xFF9DC08B),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (String value) {
                                                if (value == 'edit') {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Center(
                                                          child: Text(
                                                            'Edit Details',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 20.0,
                                                            ),
                                                          ),
                                                        ),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            TextFormField(
                                                              readOnly: true,
                                                              onTap: () {
                                                                _selectDatePlanted1(
                                                                    context);
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    "Date Planted",
                                                                labelStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins-Regular',
                                                                  fontSize: 13,
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            208,
                                                                            216,
                                                                            144),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                              ),
                                                              controller:
                                                                  _plantedController,
                                                              onSaved:
                                                                  (value) {},
                                                            ),
                                                            TextFormField(
                                                              readOnly: true,
                                                              onTap: () {
                                                                _selectHarvestedDate(
                                                                    context);
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    "Harvested Date",
                                                                labelStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins-Regular',
                                                                  fontSize: 13,
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            208,
                                                                            216,
                                                                            144),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
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
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'Poppins-Regular',
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    String
                                                                        postContent =
                                                                        _postController
                                                                            .text;
                                                                    print(
                                                                        postContent);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    'Save',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Poppins-Regular',
                                                                    ),
                                                                  ),
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Color.fromRGBO(
                                                                            157,
                                                                            192,
                                                                            139,
                                                                            1),
                                                                    primary: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else if (value == 'delete') {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Delete Tracker?',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        content: Text(
                                                          "This can't be undone and it will be removed from your tracker.",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-Regular',
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
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text(
                                                                'Delete',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-Regular',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                          0xFF9DC08B)
                                                                      .withAlpha(
                                                                          180),
                                                                )),
                                                            onPressed: () {
                                                              () => _deleteHarvested(
                                                                  documentSnapshot
                                                                      .id);
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
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
                          )
                        ]),
                      )
                    ]);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }

  void _saveInformation() {}
}
