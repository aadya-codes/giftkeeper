// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 0;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Person(
      // Older saved records won't have field 8 (it didn't exist yet) —
      // fields[8] will be null for them, and the Person constructor
      // auto-generates a fresh id in that case instead of crashing.
      id: fields[8] as String?,
      name: fields[0] as String,
      day: fields[1] as int,
      month: fields[2] as int,
      year: fields[3] as int?,
      relationship: fields[4] as String,
      interests: fields[5] as String,
      notes: fields[6] as String,
      giftIdeas: (fields[7] as List).cast<GiftIdea>(),
    );
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.month)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.relationship)
      ..writeByte(5)
      ..write(obj.interests)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.giftIdeas)
      ..writeByte(8)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}