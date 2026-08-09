import 'package:hive/hive.dart';

part 'gift_idea.g.dart';

@HiveType(typeId: 1)
class GiftIdea {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool given;

  @HiveField(2)
  int? giftedYear;

  @HiveField(3)
  String? occasion;

  GiftIdea({
    required this.name,
    this.given = false,
    this.giftedYear,
    this.occasion,
  });
}