// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'argument.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArgumentAdapter extends TypeAdapter<Argument> {
  @override
  final int typeId = 1;

  @override
  Argument read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Argument(
      name: fields[0] as String?,
      date: fields[1] as DateTime?,
      score: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Argument obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArgumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
