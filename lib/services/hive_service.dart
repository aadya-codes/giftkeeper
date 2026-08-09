import 'package:hive/hive.dart';
import '../models/person.dart';

class HiveService {
  static Box<Person> get _box => Hive.box<Person>("people");

  static List<Person> loadPeople() {
    return _box.values.toList();
  }

  static Future<void> savePeople(List<Person> people) async {
    await _box.clear();
    await _box.addAll(people);
  }
}