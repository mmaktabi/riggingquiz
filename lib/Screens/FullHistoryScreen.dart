import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/layout.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class FullHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> historyList;

  const FullHistoryScreen({super.key, required this.historyList});

  void _showDetailsModal(
      BuildContext context, Map<String, dynamic> historyItem) {
    final score = historyItem['score'];
    final categoryName = historyItem['categoryName'];
    final timestamp = DateTime.parse(historyItem['timestamp']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Detailinformationen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QText(
                text: "Kategorie: $categoryName",
              ),
              const SizedBox(height: 8),
              QText(
                text: "Score: $score",
              ),
              const SizedBox(height: 8),
              QText(
                text:
                    "Datum: ${timestamp.day}.${timestamp.month}.${timestamp.year} - ${timestamp.hour}:${timestamp.minute}",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const QText(
                text: "Schließen",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return QLayout(
      backButton: true,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final historyItem = historyList[index];
          final score = historyItem['score'];
          final categoryName = historyItem['categoryName'];
          final timestamp = DateTime.parse(historyItem['timestamp']);

          return InkWell(
            onTap: () => _showDetailsModal(context, historyItem),
            child: Card(
              elevation: 3,
              color: QColors.backgroundColor,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(5),
                leading: Image.asset(
                  QImages.schaekel,
                  width: 32,
                  height: 32,
                ),
                title: QText(
                  text:
                      'Du hast $categoryName gespielt und $score Schäkel gesammelt.',
                ),
                subtitle: QText(
                  text:
                      'Datum: ${timestamp.day}.${timestamp.month}.${timestamp.year} - ${timestamp.hour}:${timestamp.minute}',
                  color: QColors.dullLavender,
                  fontSize: 12,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
