import 'package:flutter/material.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/app/picktory_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.instance.init();
  runApp(const PicktoryApp());
}
