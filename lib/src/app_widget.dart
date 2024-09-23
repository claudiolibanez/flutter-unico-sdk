import 'package:flutter/material.dart';
import 'package:unico_sdk/src/models/project_info_model.dart';

import 'package:unico_sdk/src/screens/home_screen.dart';

class AppWidget extends StatelessWidget {
  final AppConfig configAndroid;
  final AppConfig configIos;

  const AppWidget({
    super.key,
    required this.configAndroid,
    required this.configIos,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(
        configAndroid: configAndroid,
        configIos: configIos,
      ),
    );
  }
}
