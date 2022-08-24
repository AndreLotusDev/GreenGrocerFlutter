import 'package:flutter/material.dart';
import 'package:loja_virtual/src/pages/splashs/splash_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Grocer',
      theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white.withAlpha(190)),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
