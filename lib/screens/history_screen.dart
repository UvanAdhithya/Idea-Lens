import 'dart:io';
import 'package:flutter/material.dart';

import '../models/project_history.dart';
import 'package:hive_flutter/hive_flutter.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ProjectHistory>('historyBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<ProjectHistory> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No projects yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final historyList =
          box.values.toList().reversed.toList();

          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final item = historyList[index];

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Image.file(
                    File(item.imagePath),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.selectedProject),
                  subtitle: Text(
                    '${item.difficulty.toUpperCase()} • '
                        '${item.createdAt.toLocal()}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
