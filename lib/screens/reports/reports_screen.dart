import 'package:flutter/material.dart';
import '../../services/report_service.dart';
import '../../services/voice_service.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ReportService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Reports.');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Reports'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, int>>(
        future: service.getSummary(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final items = [
            ('Students', data['students'] ?? 0),
            ('Teachers', data['teachers'] ?? 0),
            ('Courses', data['courses'] ?? 0),
            ('Fees', data['fees'] ?? 0),
          ];

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entry = items[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.bar_chart, color: Colors.white)),
                  title: Text(entry.$1),
                  trailing: Text(entry.$2.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
