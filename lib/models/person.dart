import 'dart:math';

import 'package:hive/hive.dart';
import 'gift_idea.dart';

part 'person.g.dart';

String _generateId() =>
    '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 31)}';

@HiveType(typeId: 0)
class Person {

  @HiveField(8)
  String id;

  @HiveField(0)
  String name;

  @HiveField(1)
  int day;

  @HiveField(2)
  int month;

  @HiveField(3)
  int? year;

  @HiveField(4)
  String relationship;

  @HiveField(5)
  String interests;

  @HiveField(6)
  String notes;

  @HiveField(7)
  List<GiftIdea> giftIdeas;

  Person({
    String? id,
    required this.name,
    required this.day,
    required this.month,
    this.year,
    this.relationship = "",
    this.interests = "",
    this.notes = "",
    List<GiftIdea>? giftIdeas,
  })  : id = id ?? _generateId(),
        giftIdeas = giftIdeas ?? <GiftIdea>[];
}