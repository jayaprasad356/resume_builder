import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cvmaker/home_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize().then((InitializationStatus status) {
    print('Initialization done: ${status.adapterStatuses}');
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
          tagForChildDirectedTreatment:
              TagForChildDirectedTreatment.unspecified,
          testDeviceIds: <String>[
            "76D876DC25AAE04CF157D090E3029B30",
            "A8DE1403-9A26-4F50-8353-E44BD4BF743C"
          ]),
    );
  });
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
