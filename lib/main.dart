import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:krunalpractical/screens/HomeScreen.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Post',
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => HomeScreen()),
    ],
  ));
}


