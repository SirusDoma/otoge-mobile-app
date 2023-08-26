import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:otoge_mobile_app/widget/otoge_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(const OtogeApp());
}




