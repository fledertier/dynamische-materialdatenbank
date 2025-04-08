import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 720,
      child: SearchBar(
        leading: Icon(Icons.search),
        hintText: 'Search in materials',
      ),
    );
  }
}
