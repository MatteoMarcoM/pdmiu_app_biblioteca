import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdmiu_app_biblioteca/pages/mainPages/biblioHomePage.dart';

const int largeScreenBreakpoint = 600;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Biblioteca',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const BiblioHomePage(),
    );
  }
}
