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
          List<ProjectHistory> historyList = [];
          try {
            historyList = box.values.toList().reversed.toList();
          } catch (e) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text('Error loading history.'),
                  TextButton(
                    onPressed: () => box.clear(),
                    child: const Text('Clear History'),
                  ),
                ],
              ),
            );
          }

          if (historyList.isEmpty) {
            return const Center(
              child: Text(
                'No projects yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final item = historyList[index];

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: item.imagePath != null
                      ? Image.file(
                          File(item.imagePath!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: const Icon(Icons.history),
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
