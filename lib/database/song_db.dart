import 'package:hive_flutter/hive_flutter.dart';
part 'song_db.g.dart';

@HiveType(typeId: 0)
class Songs extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> songIds;

  Songs({required this.name, required this.songIds});

  add(int id) async {
    songIds.add(id);
    save();
  }

  deleteData(int id) {
    songIds.remove(id);
    save();
  }

  bool isValueIn(int id) {
    return songIds.contains(id);
  }
}
