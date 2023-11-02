import 'package:flutter/material.dart';

class BuyerAboutUsScreen extends StatelessWidget {
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
              'About Us',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Image.asset(
                'assets/about.png',
                width: 900,
                height: 300,
              ),
              SizedBox(height: 16.0),
              Text(
                'VISION',
                style: TextStyle(fontSize: 24.0, fontFamily: "Poppins"),
              ),
              SizedBox(height: 8.0),
              Text(
                'Layuning may gawa, tapat para sa pangarap ng magsasaka na mabago ang antas ng pamumuhay ng bawat kasapi.',
                style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 16.0),
              Text(
                'MISSION',
                style: TextStyle(fontSize: 24.0, fontFamily: "Poppins"),
              ),
              SizedBox(height: 8.0),
              Text(
                'Upang matutunan na mapaunlad ang antas ng kabuhayan ng mga magsasaka sa pamamagitan ng pinansyal na tulong at serbisyo.',
                style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 16.0),
              Text(
                'GOALS',
                style: TextStyle(fontSize: 24.0, fontFamily: "Poppins"),
              ),
              SizedBox(height: 8.0),
              Text(
                '1. Matulungan ang bawat kasapi o miyembro sa mga pangangailangang pinansyal.',
                style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 5.0),
              Text(
                '2. Mahikayat ang mga kasapi at mag-impok para may pondong puhunan.',
                style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 8.0),
              Text(
                '3. Pagkakaroon ng sapat nA puhunan para sa iba’t ibang negosyo at proyekto.',
                style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 5.0),
              Text(
                '4. Mapataas ang ani at kita ng bawat kasapi ng kooperatiba.',
                style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 8.0),
              Text(
                '5. Pagkakaroon ng pasilidad gaya ng bodega,bilaran,makinarya,at sariling lote.',
                style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 5.0),
              Text(
                '6. Magkaroon ng programa para sa pang-kalusugan,edukasyon at pangkabuhayan.',
                style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 5.0),
              Text(
                '7. Patuloy na pag-aaral at pagsasanay sa lahat ng kasapi ng kooperatiba.',
                style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Regular"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
