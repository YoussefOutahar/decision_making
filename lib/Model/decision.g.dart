// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DecisionAdapter extends TypeAdapter<Decision> {
  @override
  final int typeId = 0;

  @override
  Decision read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Decision(
      name: fields[0] as String?,
      date: fields[1] as DateTime?,
      score: fields[2] as double?,
      arguments: (fields[6] as List?)?.cast<Argument>(),
    )
      ..positiveScore = fields[3] as double?
      ..negativeScore = fields[4] as double?
      ..weightedNegativeScore = fields[5] as double?;
  }

  @override
  void write(BinaryWriter writer, Decision obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.positiveScore)
      ..writeByte(4)
      ..write(obj.negativeScore)
      ..writeByte(5)
      ..write(obj.weightedNegativeScore)
      ..writeByte(6)
      ..write(obj.arguments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecisionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
