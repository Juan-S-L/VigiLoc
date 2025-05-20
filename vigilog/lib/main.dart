import 'package:flutter/material.dart';
import 'package:vigilog/ui/pages/home_page.dart';


void main() {
  runApp(const VigiLogApp());
}

class VigiLogApp extends StatelessWidget {
  const VigiLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VigiLog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );}
}