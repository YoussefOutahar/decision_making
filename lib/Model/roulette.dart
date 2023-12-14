import 'package:hive/hive.dart';

part 'roulette.g.dart';

@HiveType(typeId: 2)
class Roulette extends HiveObject {
  Roulette({
    required this.name,
    required this.date,
    required this.choices,
  });
  @HiveField(0)
  String? name;
  @HiveField(1)
  DateTime? date;
  @HiveField(2)
  List<String>? choices;
  @HiveField(3)
  String? selectedChoice;
}
