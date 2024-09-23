import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:unico_sdk/src/app_widget.dart';
import 'package:unico_sdk/src/models/project_info_model.dart';

Future<AppConfig> loadConfig(String fileName) async {
  final String response = await rootBundle.loadString(fileName);
  final data = json.decode(response);
  return AppConfig.fromJson(data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppConfig configAndroid = await loadConfig('P2XPAY_Android_HML.json');
  final AppConfig configIos = await loadConfig('P2XPAY_IOS_HML.json');

  runApp(AppWidget(
    configAndroid: configAndroid,
    configIos: configIos,
  ));
}
