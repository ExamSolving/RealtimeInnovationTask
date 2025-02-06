import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String role;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime endDate;

  Employee({
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
  });
}
