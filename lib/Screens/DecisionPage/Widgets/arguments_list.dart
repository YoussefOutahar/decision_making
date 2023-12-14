import 'package:bubble/bubble.dart';
import 'package:decision_making/Google_Ads/interstitial_ads.dart';
import 'package:decision_making/Model/argument.dart';
import 'package:decision_making/Model/decision.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ArgumentsList extends StatefulWidget {
  const ArgumentsList({Key? key, required this.decision}) : super(key: key);

  final Decision decision;

  @override
  State<ArgumentsList> createState() => _ArgumentsListState();
}

class _ArgumentsListState extends State<ArgumentsList> {
  Widget _buildArgument(BuildContext context, Argument argument) {
    bool isDark = GetStorage().read('isDarkMode') ?? false;
    if (argument.score! > 0) {
      return Row(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Bubble(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                child: Text(argument.name ?? '')),
          ),
          Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                ),
                color: Colors.green,
                borderRadius: const BorderRadius.all(Radius.circular(5000)),
              ),
              child: Text(argument.score.toString())),
        ],
      );
    } else if (argument.score! < 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  color: Colors.red,
                  borderRadius: const BorderRadius.all(Radius.circular(5000))),
              child: Text(
                argument.score.toString(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Bubble(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  child: Text(argument.name ?? '')),
            ),
            const Spacer(),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Bubble(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              child: Text(argument.name ?? '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: widget.decision.arguments!.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
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
          onDismissed: (direction) {
            setState(() {
              widget.decision.arguments!.removeAt(index);
            });
          },
          child: _buildArgument(context, widget.decision.arguments![index]),
        );
      },
    );
  }
}
