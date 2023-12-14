import 'package:hive/hive.dart';

part 'argument.g.dart';

@HiveType(typeId: 1)
class Argument extends HiveObject {
  Argument({
    required this.name,
    required this.date,
    required this.score,
  });
  @HiveField(0)
  String? name;
  @HiveField(1)
  DateTime? date;
  @HiveField(2)
  double? score;
}
