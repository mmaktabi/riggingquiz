import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rigging_quiz/Screens/FullHistoryScreen.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/score_service.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/button.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'dart:async'; // Import für StreamSubscription

class HistoryList extends StatefulWidget {
  final String uid;
  final int maxItems;

  const HistoryList({super.key, required this.uid, this.maxItems = 5});

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<Map<String, dynamic>> historyList = [];
  bool isLoading = true;
  String? errorMessage;
  StreamSubscription? _historySubscription; // StreamSubscription speichern

  @override
  void initState() {
    super.initState();
    final scoreService = Provider.of<ScoreService>(context, listen: false);

    // StreamSubscription speichern und Listener registrieren
    _historySubscription =
        scoreService.getHistoryStream(widget.uid).listen((data) {
      if (mounted) {
        // mounted prüfen
        setState(() {
          historyList = data.reversed.toList(); // Neuste zuerst anzeigen
          isLoading = false;
          errorMessage = null;
        });
      }
    }, onError: (error) {
      if (mounted) {
        // mounted prüfen
        setState(() {
          isLoading = false;
          errorMessage = 'Fehler beim Laden der Historie: $error';
        });
      }
    });
  }

  @override
  void dispose() {
    _historySubscription?.cancel(); // StreamSubscription beenden
    super.dispose();
  }

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
    if (isLoading) {
      return QWidgets().progressIndicator;
    }

    if (errorMessage != null) {
      return Center(
        child: QText(
          text: errorMessage!,
        ),
      );
    }

    if (historyList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: QText(
            text: 'Keine Historie verfügbar',
          ),
        ),
      );
    }

    final displayedList = historyList.take(widget.maxItems).toList();
    final showMoreButton = historyList.length > widget.maxItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 4, left: 8),
          child: QText(
            text: "Deine Spiele",
            fontSize: 16,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: displayedList.length,
          itemBuilder: (context, index) {
            final historyItem = displayedList[index];
            final score = historyItem['score'];
            final categoryName = historyItem['categoryName'];
            final timestamp = DateTime.parse(historyItem['timestamp']);

            return InkWell(
              onTap: () => _showDetailsModal(context, historyItem),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Card(
                  elevation: 3,
                  color: QColors.backgroundColor,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(5),
                    leading: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        QImages.schaekel,
                        width: 25,
                        height: 25,
                      ),
                    ),
                    title: QText(
                      text:
                          'Du hast das Quiz "$categoryName" abgeschlossen und dabei $score Schäkel gesammelt!',
                    ),
                    subtitle: QText(
                      text:
                          'Datum: ${timestamp.day}.${timestamp.month}.${timestamp.year} - ${timestamp.hour}:${timestamp.minute}',
                      color: QColors.primaryColor,
                      fontSize: 12,
                    ),
                    trailing: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: QColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (showMoreButton)
          Center(
            child: QButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullHistoryScreen(historyList: historyList),
                      ),
                    ),
                buttonText: "Historie ansehen"),
          )
      ],
    );
  }
}
