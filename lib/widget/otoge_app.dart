import 'package:flutter/material.dart';

import 'package:otoge_mobile_app/service/otoge_api.dart';
import 'package:otoge_mobile_app/service/location_service.dart';

import 'package:otoge_mobile_app/widget/page/main_page.dart';

class OtogeApp extends StatelessWidget {
  const OtogeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otoge Mobile',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.orange.shade700,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange.shade700,
        useMaterial3: true,
      ),
      home: MainPage(title: 'Otoge Mobile', otogeApi: OtogeApi(), locationService: LocationService()),
      debugShowCheckedModeBanner: false,
    );
  }
}