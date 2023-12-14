import 'package:hive/hive.dart';

import 'argument.dart';

part 'decision.g.dart';

@HiveType(typeId: 0)
class Decision extends HiveObject {
  Decision(
      {required this.name,
      required this.date,
      required this.score,
      required this.arguments});

  @HiveField(0)
  String? name;
  @HiveField(1)
  DateTime? date;
  @HiveField(2)
  double? score;
  @HiveField(3)
  double? positiveScore;
  @HiveField(4)
  double? negativeScore;
  @HiveField(5)
  double? weightedNegativeScore;
  @HiveField(6)
  List<Argument>? arguments;

  static bool isAccepted(Decision decision) {
    if (decision.positiveScore! >= -decision.weightedNegativeScore!) {
      return true;
    } else {
      return false;
    }
  }

  static bool isUndecided(Decision decision) {
    if (decision.positiveScore! < -decision.weightedNegativeScore! &&
        decision.positiveScore! > -decision.negativeScore!) {
      return true;
    }
    return false;
  }

  static bool isRejected(Decision decision) {
    if (decision.positiveScore! <= -decision.negativeScore!) {
      return true;
    }
    return false;
  }

  static void getScore(Decision decision) {
    double score = 0;
    double positiveScore = 0;
    double negativeScore = 0;
    double weightedNegativeScore = 0;
    for (Argument argument in decision.arguments!) {
      score += argument.score!;
      if (argument.score! > 0) {
        positiveScore += argument.score!;
      } else {
        negativeScore += argument.score!;
        weightedNegativeScore += 2 * argument.score!;
      }
    }
    decision.score = score;
    decision.positiveScore = positiveScore;
    decision.negativeScore = negativeScore;
    decision.weightedNegativeScore = weightedNegativeScore;
  }
}
