// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_idea.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GiftIdeaAdapter extends TypeAdapter<GiftIdea> {
  @override
  final int typeId = 1;

  @override
  GiftIdea read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GiftIdea(
      name: fields[0] as String,
      given: fields[1] as bool,
      giftedYear: fields[2] as int?,
      occasion: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GiftIdea obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.given)
      ..writeByte(2)
      ..write(obj.giftedYear)
      ..writeByte(3)
      ..write(obj.occasion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiftIdeaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
