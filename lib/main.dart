import 'package:flutter/material.dart';
import 'package:flutter_energy/router.dart';
import 'package:flutter_energy/screens/home/home_page.dart';
import 'package:flutter_energy/screens/settings/setting_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quanto vai vir a energia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "router",
      routes: {
        "router": (context) => const RouterWidget(),
        "settings": (context) => const SettingsPage(),
        "home": (context) => const HomePage(),
      },
    );
  }
}
