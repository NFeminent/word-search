// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:word_search/utils/color.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController rowController = TextEditingController();
  final TextEditingController columnController = TextEditingController();

  bool validateInput() {
    if (int.tryParse(rowController.text) == null ||
        int.tryParse(columnController.text) == null) {
      return false;
    }

    if (int.parse(rowController.text) <= 0 ||
        int.parse(columnController.text) <= 0) {
      return false;
    }

    return true;
  }

  void navigateToGridInput() {
    if (validateInput()) {
      int rows = int.parse(rowController.text);
      int columns = int.parse(columnController.text);

      Map<String, dynamic> data = {
        'screen_name': 'gridInput',
        'rows': rows,
        'columns': columns
      };

      screens.value = data;
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please enter valid positive integers for rows and columns.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.myblack,
        title: Text('Input Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: rowController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rows',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.table_rows),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: columnController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Columns',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.view_column_rounded),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.myred,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 90,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: navigateToGridInput,
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
