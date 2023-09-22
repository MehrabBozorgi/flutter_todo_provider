import 'package:hive/hive.dart';
part 'users_model.g.dart';

@HiveType(typeId: 1)
class UsersModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int phone;
  @HiveField(3)
  final int age;

  UsersModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
  });
}
