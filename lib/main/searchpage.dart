// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Search Page',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
