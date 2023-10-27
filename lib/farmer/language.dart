import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: Language(),
    );
  }
}

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  List<String> languages = ['English', 'Filipino'];
  int selectedLanguageIndex = 0;

  @override
  void initState() {
    super.initState();

    loadSelectedLanguage();
  }

  void loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedIndex = prefs.getInt('selectedLanguageIndex') ?? 0;
    setState(() {
      selectedLanguageIndex = savedIndex;
    });
  }

  void saveSelectedLanguage(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedLanguageIndex', index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9AF7E),
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Choose Language',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
            title: Column(
              children: [
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      languages[index],
                      style: TextStyle(
                          fontSize: 18.0, fontFamily: 'Poppins-Regular'),
                    ),
                    if (selectedLanguageIndex == index)
                      Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ],
            ),
            onTap: () {
              context.locale = languages[index] == 'English'
                  ? Locale('en', 'US')
                  : Locale('fil', 'PH');
              setState(() {
                selectedLanguageIndex = index;
              });

              saveSelectedLanguage(index);
            },
          );
        },
      ),
    );
  }
}
