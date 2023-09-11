// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:word_search/grid.dart';
import 'package:word_search/screens/home_screen.dart';
import 'package:word_search/screens/splash_page.dart';
import 'package:word_search/search.dart';

void main() {
  runApp(const MyApp());
}

final ValueNotifier<Map<String, dynamic>> screens = ValueNotifier({});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _splashScreenTimer() async {
    await Future.delayed(const Duration(seconds: 3));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _splashScreenTimer(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return ValueListenableBuilder(
              valueListenable: screens,
              builder: (BuildContext context, Map<String, dynamic> value,
                  Widget? child) {
                // print(value['screen_name']=='gridInput');

                if (value['screen_name'] == 'gridInput') {
                  return Grid(rows: value['rows'], columns: value['columns']);
                } else if (value['screen_name'] == 'gridSearch') {
                  return GridSearch(
                      row: value['rows'],
                      column: value['columns'],
                      text: value['inputString']);
                }

                return const HomeScreen();
              },
            );
          } else {
            return SplashPage();
          }
        },
      ),
    );
  }
}
