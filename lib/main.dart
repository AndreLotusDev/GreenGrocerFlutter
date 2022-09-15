import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/src/pages/auth/controller/auth_controller.dart';
import 'package:loja_virtual/src/pages_routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Green Grocer',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white.withAlpha(190),
      ),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialRoute: PagesRoutes.splashRoute,
    );
  }
}
