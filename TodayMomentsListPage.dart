import 'package:flutter/material.dart';
class TodayMomentsListPage extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const TodayMomentsListPage({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Moments'),
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry['details'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  entry['image'] != null
                      ? Image.file(
                          entry['image'],
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        )
                      : const Text('No image available'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
