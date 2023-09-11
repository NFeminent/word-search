// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:word_search/utils/color.dart';
import 'main.dart';

class GridSearch extends StatefulWidget {
  final int row, column;
  final String text;

  const GridSearch({
    Key? key,
    required this.row,
    required this.column,
    required this.text,
  }) : super(key: key);

  @override
  State<GridSearch> createState() => _GridSearchState();
}

class _GridSearchState extends State<GridSearch> {
  final searchController = TextEditingController();

  List<List<String>> grid = [];
  List<int> highlightedIndex = [];

  @override
  void initState() {
    super.initState();
    initializeGrid();
  }

  void initializeGrid() {
    grid.clear();
    int charIndex = 0;
    for (int i = 0; i < widget.row; i++) {
      List<String> row = [];
      for (int j = 0; j < widget.column; j++) {
        if (charIndex < widget.text.length) {
          row.add(widget.text[charIndex]);
          charIndex++;
        } else {
          row.add('');
        }
      }
      grid.add(row);
    }
  }

  List<List<int>> findText(String searchText) {
    List<List<int>> positions = [];

    for (int i = 0; i < widget.row; i++) {
      for (int j = 0; j <= widget.column - searchText.length; j++) {
        String rowText = grid[i].join('');
        if (rowText.substring(j, j + searchText.length).toLowerCase() ==
            searchText.toLowerCase()) {
          positions.add(List.generate(
              searchText.length, (index) => i * widget.column + j + index));
        }
      }
    }

    for (int i = 0; i <= widget.row - searchText.length; i++) {
      for (int j = 0; j < widget.column; j++) {
        String columnText = '';
        for (int k = 0; k < searchText.length; k++) {
          columnText += grid[i + k][j];
        }
        if (columnText.toLowerCase() == searchText.toLowerCase()) {
          positions.add(
            List.generate(
                searchText.length, (index) => (i + index) * widget.column + j),
          );
        }
      }
    }

    for (int i = 0; i <= widget.row - searchText.length; i++) {
      for (int j = 0; j <= widget.column - searchText.length; j++) {
        String diagonalText = '';
        for (int k = 0; k < searchText.length; k++) {
          diagonalText += grid[i + k][j + k];
        }
        if (diagonalText.toLowerCase() == searchText.toLowerCase()) {
          positions.add(List.generate(searchText.length,
              (index) => (i + index) * widget.column + j + index));
        }
      }
    }
    return positions;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> gridItems = [];

    for (int i = 0; i < widget.text.length; i++) {
      String char = widget.text[i];
      gridItems.add(
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: highlightedIndex.contains(i) ? Colors.red : Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                char,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Text',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.column,
              ),
              itemCount: gridItems.length,
              itemBuilder: (context, index) {
                return gridItems[index];
              },
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> data = {
                      'screen_name': '',
                    };
                    screens.value = data;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.myblack,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      try {
                        highlightedIndex = [];

                        var result = findText(searchController.text);
                        if (result.isEmpty) {
                          highlightedIndex = [];

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Word not found"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        for (var element in result) {
                          highlightedIndex.addAll(element);
                        }

                        // highlightedIndex = findText(searchController.text).first;
                      } catch (e) {
                        highlightedIndex = [];

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Word not found"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.myred,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Find',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
