import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarthome_app/util/smart_devices_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Database Reference
  final lampuRef = FirebaseDatabase.instance.ref("kontrol/lampu");
  DatabaseReference acRef = FirebaseDatabase.instance.ref("kontrol/ac");
  DatabaseReference tvRef = FirebaseDatabase.instance.ref("kontrol/tv");
  DatabaseReference fanRef = FirebaseDatabase.instance.ref("kontrol/fan");
  // padding constant
  final double horizontalPadding = 40.0;
  final double verticalPadding = 25.0;

  void getFirebase() {
    setState(() {
      lampuRef.onValue.listen((event) {
        final data = event.snapshot.value;
        if (data == 1) {
          mySmartDevices[0][2] = true;
        } else {
          mySmartDevices[0][2] = false;
        }
      });

      acRef.onValue.listen((event) {
        final data = event.snapshot.value;
        if (data == 1) {
          mySmartDevices[1][2] = true;
        } else {
          mySmartDevices[1][2] = false;
        }
      });

      fanRef.onValue.listen((event) {
        final data = event.snapshot.value;
        if (data == 1) {
          mySmartDevices[3][2] = true;
        } else {
          mySmartDevices[3][2] = false;
        }
      });
    });
  }

  //list of smart devices
  List mySmartDevices = [
    // [ smart Device name, icon path, power status ]
    ['Smart Light', 'lib/icons/light-bulb.png', true],
    ['Smart AC', 'lib/icons/air-conditioner.png', false],
    ['Smart TV', 'lib/icons/smart-tv.png', false],
    ['Smart Fan', 'lib/icons/fan.png', false]
  ];

  // power button switch
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      getFirebase();
      mySmartDevices[index][2] = value;
      // CEK LAMPU
      if (mySmartDevices[0][2] == true) {
        lampuRef.set(1);
      } else {
        lampuRef.set(0);
      }
      // CEK AC
      if (mySmartDevices[1][2] == true) {
        acRef.set(1);
      } else {
        acRef.set(0);
      }
      // CEK TV
      if (mySmartDevices[2][2] == true) {
        tvRef.set(1);
      } else {
        tvRef.set(0);
      }
      // CEK KIPAS
      if (mySmartDevices[3][2] == true) {
        fanRef.set(1);
      } else {
        fanRef.set(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //custom appbarr
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menu icon
            
                  Image.asset(
                    'lib/icons/menu.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),

                  // person icon
                  Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.grey[800],
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Wellcome Home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wellcome Home,',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'SALAMOPOSO',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 55,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Divider(
                color: Colors.grey[600],
                thickness: 1,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            //SmartDevice + grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                'Smart Devices',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: mySmartDevices.length,
                // physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  return SmartDeviceBox(
                    smartDeviceName: mySmartDevices[index][0],
                    iconPath: mySmartDevices[index][1],
                    powerOn: mySmartDevices[index][2],
                    onChanged: (value) => powerSwitchChanged(value, index),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
