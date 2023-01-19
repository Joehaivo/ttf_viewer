import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttf_viewer/src/i18n/i18n_value.dart';
import 'package:ttf_viewer/src/screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: I18nValue(),
      locale: Get.deviceLocale?.languageCode == 'zh' ? const Locale('zh', 'CN') : const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      title: "TTF Viewer",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
