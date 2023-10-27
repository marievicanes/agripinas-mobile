import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(DashboardScreen());
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late SharedPreferences prefs;
  bool hasShownPopup = false;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();

    // Callback after the frame is painted
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Check if the popup has not been shown
      if (!hasShownPopup) {
        // Show the popup
        showPopup();
      }
    });
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // Check if the popup has been shown before
    setState(() {
      hasShownPopup = prefs.getBool('hasShownPopup') ?? false;
    });
  }

  void showPopup() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          // Disable back button
          onWillPop: () async => false,
          child: AlertDialog(
            title: Center(
              child: Text(
                'Announcement',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 19),
              ),
            ),
            content: Text(
              'Dear Cabiao farmers,\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Integer lacinia pretium aliquet. Quisque euismod suscipit mi id accumsan. Quisque molestie varius nisl, eget dictum nunc eleifend quis. Mauris massa est, tincidunt vel venenatis venenatis, fringilla sed orci. Integer et rutrum est, quis venenatis mi. Vestibulum dictum posuere quam, facilisis convallis nunc auctor eu. Etiam iaculis eleifend lorem, ut consequat lacus efficitur rutrum. Sed porta tortor nec velit luctus ullamcorper. Aenean rutrum lectus id tristique tempor. Fusce non ligula varius orci euismod imperdiet at eu ipsum. Maecenas mollis ac est ac vehicula. Donec sit amet orci risus. Nunc malesuada ut ante ac pretium. In hac habitasse platea dictumst. Integer dapibus sodales tortor, et dapibus magna ullamcorper pretium.',
              style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 14),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFF4D7046),
                    fontFamily: 'Poppins-Bold',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Set hasShownPopup to true after the user clicks OK
                  prefs.setBool('hasShownPopup', true);
                  setState(() {
                    hasShownPopup = true;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  final List<Map<String, dynamic>> tomorrowForecast = [
    {
      'date': 'July 7',
      'day': 'Tue',
      'icon': Icons.wb_sunny,
      'temperature': '28°',
      'weatherCondition': 'Sunny',
    },
  ];

  final List<Map<String, dynamic>> nextSevenDaysForecast = [
    {
      'date': 'July 8',
      'day': 'Wed',
      'icon': Icons.cloud,
      'temperature': '26°',
      'weatherCondition': 'Cloudy',
    },
    {
      'date': 'July 9',
      'day': 'Thu',
      'icon': Icons.wb_sunny,
      'temperature': '29°',
      'weatherCondition': 'Sunny',
    },
    {
      'date': 'July 10',
      'day': 'Fri',
      'icon': Icons.cloud,
      'temperature': '27°',
      'weatherCondition': 'Cloudy',
    },
    {
      'date': 'July 11',
      'day': 'Sat',
      'icon': Icons.wb_sunny,
      'temperature': '30°',
      'weatherCondition': 'Sunny',
    },
    {
      'date': 'July 12',
      'day': 'Sun',
      'icon': Icons.wb_sunny,
      'temperature': '32°',
      'weatherCondition': 'Sunny',
    },
    {
      'date': 'July 13',
      'day': 'Mon',
      'icon': Icons.cloud,
      'temperature': '29°',
      'weatherCondition': 'Cloudy',
    },
    {
      'date': 'July 14',
      'day': 'Tue',
      'icon': Icons.cloud,
      'temperature': '27°',
      'weatherCondition': 'Cloudy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFA9AF7E),
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
                  fontSize: 17.0,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Brgy. San Fernando Norte, Cabiao',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Poppins',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '25°',
                      style: TextStyle(
                        fontSize: 72.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      children: [
                        Icon(
                          Icons.wb_sunny,
                          size: 48.0,
                          color: Colors.yellow,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Sunny',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'July 6, Monday',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeatherInfoCard(
                      icon: Icons.thermostat,
                      label: 'Temperature',
                      value: '25°',
                    ),
                    WeatherInfoCard(
                      icon: Icons.wb_sunny,
                      label: 'Humidity',
                      value: '75%',
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeatherInfoCard(
                      icon: Icons.cloud,
                      label: 'Weather',
                      value: 'Sunny',
                    ),
                    WeatherInfoCard(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '10 km/h',
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tomorrowForecast.length,
                  itemBuilder: (context, index) {
                    return ForecastCard(
                      date: tomorrowForecast[index]['date'],
                      day: tomorrowForecast[index]['day'],
                      icon: tomorrowForecast[index]['icon'],
                      temperature: tomorrowForecast[index]['temperature'],
                      weatherCondition: tomorrowForecast[index]
                          ['weatherCondition'],
                    );
                  },
                ),
                SizedBox(height: 10.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: nextSevenDaysForecast.length,
                  itemBuilder: (context, index) {
                    return ForecastCard(
                      date: nextSevenDaysForecast[index]['date'],
                      day: nextSevenDaysForecast[index]['day'],
                      icon: nextSevenDaysForecast[index]['icon'],
                      temperature: nextSevenDaysForecast[index]['temperature'],
                      weatherCondition: nextSevenDaysForecast[index]
                          ['weatherCondition'],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfoCard({
    required this.icon,
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
              Icon(
                icon,
                size: 36.0,
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
  final String day;
  final IconData icon;
  final String temperature;
  final String weatherCondition;

  const ForecastCard({
    required this.date,
    required this.day,
    required this.icon,
    required this.temperature,
    required this.weatherCondition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.0),
              Text(
                weatherCondition,
                style: TextStyle(fontSize: 15.0, fontFamily: 'Poppins-Regular'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 0.0),
                      Icon(
                        icon,
                        size: 24.0,
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        temperature,
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: 'Poppins-Medium'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
