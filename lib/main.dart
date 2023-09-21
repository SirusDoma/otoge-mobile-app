import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:otoge_mobile_app/widget/otoge_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await FlutterConfig.loadEnvVariables();
  } else {
    await dotenv.load();
  }

  runApp(const OtogeApp());
}




