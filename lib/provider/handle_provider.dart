import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../model/users_model.dart';

class HandleProvider extends ChangeNotifier {
  static const String boxName = 'hiveBox';
  final openBox = Hive.openBox<UsersModel>(boxName);

  Future updateBox({
    required String key,
    required String name,
    required int phone,
    required int age,
  }) async {
    final value = UsersModel(
      id: key,
      name: name,
      phone: phone,
      age: age,
    );
    Hive.box<UsersModel>(HandleProvider.boxName).put(key, value);
    print('update Done');
  }

  Future create({
    required String name,
    required int phone,
    required int age,
  }) async {
    final id = const Uuid().v1().toString();

    final value = UsersModel(
      id: id,
      name: name,
      phone: phone,
      age: age,
    );
    Hive.box<UsersModel>(HandleProvider.boxName).put(id, value);
    print('create Done');
  }
}
