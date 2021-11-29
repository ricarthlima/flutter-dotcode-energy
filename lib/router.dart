import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouterWidget extends StatelessWidget {
  const RouterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkData(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void checkData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getKeys().isEmpty) {
      Navigator.pushReplacementNamed(context, "settings");
    } else {
      Navigator.pushReplacementNamed(context, "home");
    }
  }
}
