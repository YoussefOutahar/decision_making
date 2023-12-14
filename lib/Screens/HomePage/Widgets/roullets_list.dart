import 'package:decision_making/Model/roulette.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timer_builder/timer_builder.dart';

class RoulettesList extends StatefulWidget {
  const RoulettesList({Key? key}) : super(key: key);

  @override
  State<RoulettesList> createState() => _RoulettesListState();
}

class _RoulettesListState extends State<RoulettesList> {
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

  Widget _buildIcon(Roulette roulette) {
    if (roulette.selectedChoice == null) {
      return const Icon(Icons.horizontal_rule_rounded);
    } else {
      return const Icon(Icons.check_circle_outline, color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(const Duration(seconds: 5),
        builder: (context) {
      return ValueListenableBuilder(
        valueListenable: Hive.box<Roulette>('roulettes').listenable(),
        builder: (context, Box<Roulette> box, _) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
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
                            Navigator.pushNamed(context, '/roulette',
                                arguments: box.values.elementAt(index));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              trailing: _buildIcon(box.getAt(index)!),
                              title: Text((box.getAt(index)!.name!.isEmpty)
                                  ? _getTimeAgo(box.getAt(index)!.date!)
                                  : box.getAt(index)!.name!),
                              subtitle: Text((box.getAt(index)!.name!.isEmpty)
                                  ? ''
                                  : _getTimeAgo(box.getAt(index)!.date!)),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        },
      );
    });
  }
}
