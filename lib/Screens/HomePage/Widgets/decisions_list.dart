import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timer_builder/timer_builder.dart';

import '../../../Model/decision.dart';

class DecisionsList extends StatefulWidget {
  const DecisionsList({
    Key? key,
  }) : super(key: key);

  @override
  State<DecisionsList> createState() => _DecisionsListState();
}

class _DecisionsListState extends State<DecisionsList> {
  String _getTimeAgo(DateTime creationDate) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final now = DateTime.now();
    final difference = now.difference(creationDate);
    final days = difference.inDays;
    final hours = difference.inHours;
    final minutes = difference.inMinutes;
    final seconds = difference.inSeconds;
    if (days > 15) {
      return "${creationDate.day} ${months[creationDate.month - 1]}";
    } else if (days > 0) {
      return '$days days ago';
    } else if (hours > 0) {
      return '$hours hours ago';
    } else if (minutes > 0) {
      return '$minutes minutes ago';
    } else if (seconds > 30) {
      return '$seconds seconds ago';
    } else {
      return 'just now';
    }
  }

  Widget _buildIcon(Decision decision) {
    if (decision.arguments!.isEmpty || decision.score == 0) {
      return const Icon(Icons.horizontal_rule_rounded);
    } else if (Decision.isAccepted(decision)) {
      return const Icon(Icons.thumb_up, color: Colors.green);
    } else if (Decision.isUndecided(decision)) {
      return const Icon(Icons.question_mark_rounded);
    } else if (Decision.isRejected(decision)) {
      return const Icon(Icons.thumb_down, color: Colors.red);
    }
    return const Icon(Icons.error_outline_rounded);
  }

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(seconds: 5),
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: Hive.box<Decision>("decisions").listenable(),
          builder: (context, Box<Decision> box, _) {
            if (box.isEmpty) {
              return const Center(
                child: Text("No decisions yet"),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: box.values.length,
                      itemBuilder: (context, index) {
                        Decision.getScore(box.getAt(index)!);
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            box.deleteAt(index);
                          },
                          background: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20.0),
                              color: Colors.red,
                              child: const Icon(Icons.delete_rounded)),
                          secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              color: Colors.red,
                              child: const Icon(Icons.delete_rounded)),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/decision',
                                  arguments: box.values.elementAt(index));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: _buildIcon(box.getAt(index)!),
                                title: box.getAt(index)!.name!.isEmpty
                                    ? Text(
                                        _getTimeAgo(box.getAt(index)!.date!),
                                      )
                                    : Text(box.getAt(index)!.name!),
                                subtitle: box.getAt(index)!.name!.isEmpty
                                    ? null
                                    : Text(
                                        _getTimeAgo(box.getAt(index)!.date!),
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
