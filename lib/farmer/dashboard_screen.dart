import 'dart:async' show Timer;

import 'package:capstone/farmer/farmer_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

void main() {
  runApp(DashboardScreen());
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  late SharedPreferences prefs;
  bool hasShownPopup = false;
  late WeatherFactory wf;
  DateTime currentDate = DateTime.now();
  Weather? currentWeather;
  List<Weather>? forecast;
  late String selectedBarangay;
  late Timer timer;
  List<String> barangays = [
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
    "Brgy. Sta. Ines",
    "Brgy. Sta. Isabel",
    "Brgy. Sta. Rita",
    "Brgy. Sinipit",
  ];

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedBarangay = barangays[0];
    initSharedPreferences();
    wf = WeatherFactory("11e621a5382027f65c69ac85ce5791c6",
        language: Language.ENGLISH);
    fetchWeather();

    // Initialize the time zone
    tz.initializeTimeZones();
    var philippines = tz.getLocation('Asia/Manila');
    tz.setLocalLocation(philippines);

    // Start the periodic timer to update the date every minute
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      setState(() {
        currentDate = tz.TZDateTime.now(philippines);
      });
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!hasShownPopup) {}
    });
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      hasShownPopup = prefs.getBool('hasShownPopup') ?? false;
    });
  }

  Future<void> fetchWeather() async {
    try {
      String cityName = "Cabiao, $selectedBarangay";

      Weather currentWeather = await wf.currentWeatherByCityName(cityName);
      List<Weather> forecast = await wf.fiveDayForecastByCityName(cityName);

      int celsius = (currentWeather.temperature?.celsius ?? 0.0).toInt();
      int fahrenheit = (currentWeather.temperature?.fahrenheit ?? 0.0).toInt();
      int kelvin = (currentWeather.temperature?.kelvin ?? 0.0).toInt();

      setState(() {
        this.currentWeather = currentWeather;
        this.forecast = forecast;
        currentDate =
            tz.TZDateTime.now(tz.local); // Use tz.local to get the local time
      });

      print("Current Date: ${currentDate.toLocal()}");
      print("Current Temperature: $celsius °C / $fahrenheit °F / $kelvin K");
      print("Weather Description: ${currentWeather.weatherDescription}");

      // You can access forecast data as well
      for (Weather forecastItem in forecast) {
        print("Forecast Date: ${forecastItem.date}");
        print("Forecast Temperature: ${forecastItem.temperature?.celsius} °C");
        print(
            "Forecast Weather Description: ${forecastItem.weatherDescription}");
      }
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  void updateWeatherForSelectedBarangay() {
    String searchedBarangay = _searchController.text.toLowerCase();

    if (barangays
        .map((barangay) => barangay.toLowerCase())
        .contains(searchedBarangay)) {
      setState(() {
        selectedBarangay = barangays.firstWhere(
            (barangay) => barangay.toLowerCase() == searchedBarangay);
        fetchWeather();
      });
    } else {
      print("Barangay not found in the list");
    }
  }

  String capitalize(String s) {
    return s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Stack(children: [
          Container(
            height: 690,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/weather.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(60.0),
                  child: Container(
                    width: 900.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          value: selectedBarangay,
                          items: barangays.map((barangay) {
                            return DropdownMenuItem<String>(
                              value: barangay,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  barangay,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedBarangay = newValue!;
                              updateWeatherForSelectedBarangay();
                            });
                          },
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(),
                        ),
                        IconButton(
                          icon: Icon(Icons.shopping_bag_outlined),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Go to Marketplace?',
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BottomNavBar(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color:
                                              Color(0xFF9DC08B).withAlpha(180),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          currentWeather != null
                              ? '${(currentWeather!.temperature?.celsius ?? 0.0).toInt()}°'
                              : '',
                          style: TextStyle(
                              fontSize: 72.0,
                              fontFamily: 'Poppins',
                              color: Colors.white),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          selectedBarangay,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Poppins',
                              color: Colors.white),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          DateFormat('MMMM d, EEEE').format(currentDate),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Poppins',
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeatherInfoCard(
                      imagePath: 'assets/temperature.png',
                      label: 'Temperature',
                      value: currentWeather != null
                          ? '${(currentWeather!.temperature?.celsius ?? 0.0).toInt()}°'
                          : 'Loading...',
                    ),
                    WeatherInfoCard(
                      imagePath: 'assets/weather.png',
                      label: 'Weather',
                      value: currentWeather != null
                          ? currentWeather!.weatherDescription ?? 'Loading...'
                          : 'Loading...',
                    ),
                  ],
                ),
                if (forecast != null)
                  Container(
                    height: 200.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...forecast!
                            .asMap()
                            .entries
                            .where((entry) =>
                                entry.key == 0 ||
                                DateFormat('MMMM d, EEEE')
                                        .format(entry.value.date!) !=
                                    DateFormat('MMMM d, EEEE')
                                        .format(forecast![entry.key - 1].date!))
                            .take(7)
                            .map((entry) {
                          return ForecastCard(
                            date: entry.key == 0
                                ? 'Today'
                                : DateFormat('MMMM d, EEEE')
                                    .format(entry.value.date!),
                            imagePath: getWeatherIconPath(entry.key == 0
                                ? currentWeather!.weatherDescription ??
                                    'Unknown'
                                : entry.value.weatherDescription ?? 'Unknown'),
                            temperature: entry.key == 0
                                ? '${(currentWeather!.temperature?.celsius ?? 0.0).toInt()}°'
                                : '${(entry.value.temperature?.celsius ?? 0.0).toInt()}°',
                            weatherCondition: entry.key == 0
                                ? currentWeather!.weatherDescription ??
                                    'Unknown'
                                : entry.value.weatherDescription ?? 'Unknown',
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                SizedBox(height: 16.0),
                Card(
                  margin: EdgeInsets.only(bottom: 1),
                  child: Column(
                    children: [
                      Text(
                        'Announcements',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Announcements')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, streamSnapshot) {
                          if (streamSnapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Some error occurred ${streamSnapshot.error}'));
                          }
                          if (streamSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          List<QueryDocumentSnapshot> documents =
                              streamSnapshot.data!.docs;

                          return Column(
                            children: documents.map((document) {
                              Map<String, dynamic>? data =
                                  document.data() as Map<String, dynamic>?;

                              return GestureDetector(
                                onTap: () {
                                  showAnnouncementDialog(
                                      context, data?['content']);
                                },
                                child: AnnouncementCard(
                                  title: data?['title'] ?? '',
                                  content: data?['content'] ?? '',
                                  timestamp: data?['timestamp'] ?? '',
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ])));
  }
}

String getWeatherIconPath(String condition) {
  switch (condition) {
    case 'broken clouds':
      return 'assets/broken.png';
    case 'few clouds':
      return 'assets/broken.png';
    case 'thunderstorm':
      return 'assets/thunderstorm.png';
    case 'cloudy':
      return 'assets/cloudy.png';
    case 'light rain':
    case 'moderate rain':
    case 'rain':
      return 'assets/light-rain.png';
    case 'scattered clouds':
      return 'assets/scattered.png';
    case 'overcast clouds':
      return 'assets/overcast.png';
    default:
      return 'assets/default.png';
  }
}

IconData getWeatherIcon(String condition) {
  switch (condition) {
    case 'sunny':
      return Icons.wb_sunny;
    case 'cloudy':
      return Icons.cloud;
    case 'overcast clouds':
      return WeatherIcons.cloudy;
    case 'light rain':
    case 'moderate rain':
    case 'rain':
      return WeatherIcons.rain;
    case 'few clouds':
    case 'scattered clouds':
      return WeatherIcons.cloudy;
    case 'broken clouds':
      return WeatherIcons.cloudy_gusts;
    default:
      return Icons.error;
  }
}

class WeatherInfoCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final String value;

  const WeatherInfoCard({
    required this.imagePath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 60.0,
                width: 60.0,
              ),
              SizedBox(height: 10.0),
              Text(
                label,
                style: TextStyle(fontSize: 16.0, fontFamily: 'Poppins'),
              ),
              SizedBox(height: 10.0),
              Text(
                value,
                style: TextStyle(fontSize: 14.0, fontFamily: 'Poppins-Regular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForecastCard extends StatelessWidget {
  final String date;
  final String imagePath;
  final String temperature;
  final String weatherCondition;

  const ForecastCard({
    required this.date,
    required this.imagePath,
    required this.temperature,
    required this.weatherCondition,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              date,
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 5.0),
            Image.asset(
              imagePath,
              height: 60.0,
              width: 60.0,
            ),
            SizedBox(height: 10.0),
            Text(
              weatherCondition,
              style: TextStyle(fontSize: 15.0, fontFamily: 'Poppins-Regular'),
            ),
            SizedBox(height: 2.0),
            Text(
              temperature,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Poppins-Medium',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showAnnouncementDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Announcement',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20.0,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 15.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Colors.black, // Add this line to set the text color
              ),
            ),
          ),
        ],
      );
    },
  );
}

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String content;
  final String timestamp;

  AnnouncementCard({
    required this.title,
    required this.content,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 9),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Posted by Admin',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins-Regular',
                  ),
                ),
                Text(
                  timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins-Medium',
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
