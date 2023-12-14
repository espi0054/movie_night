import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'share_code_screen.dart';
import 'enter_code_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final double baseSpacing = 8.0;

  @override
  void initState() {
    super.initState();
    saveDeviceId();
  }

  Future<void> saveDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    String? storedDeviceId = prefs.getString('device_id');

    if (storedDeviceId == null) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if(Platform.isAndroid)
      {
        var info = await deviceInfo.androidInfo;
        await prefs.setString('device_id', info.id);
      }
      else
      {
        var info = await deviceInfo.iosInfo;
        await prefs.setString('device_id', info.identifierForVendor.toString());
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Night', style: textTheme.displayMedium,),
        elevation: 0,
        backgroundColor: Colors.blue.shade500,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.start),
              label: Text('Start Session', style: textTheme.bodyLarge,),
              onPressed: () {
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const ShareCodeScreen()),);
                            }
            ),
            Container(
              margin: EdgeInsets.all(baseSpacing * 9),
              child: Text('Choose an option to begin.', style: textTheme.headlineLarge),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.code),
              label: Text('Enter Code', style: textTheme.bodyLarge,),
              onPressed: () {
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const EnterCodeScreen()),);
                            }
            ),
          ],
        ),
      ),
    );
  }

}
