import 'package:employee_management_app/Data/Models/Employee/employee.dart';
import 'package:hive/hive.dart';

class EmployeeRepository {
  static const String _boxName = 'employees';

  Future<void> addEmployee(Employee employee) async {
    final box = await Hive.openBox<Employee>(_boxName);
    await box.add(employee);
  }

  Future<void> updateEmployee(int index, Employee employee) async {
    final box = await Hive.openBox<Employee>(_boxName);
    await box.putAt(index, employee);
  }

  Future<void> deleteEmployee(int index) async {
    final box = await Hive.openBox<Employee>(_boxName);
    await box.deleteAt(index);
  }

  Future<List<Employee>> getEmployees() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Employee>(_boxName);
    }
    final box = Hive.box<Employee>(_boxName);
    return box.values.toList();
  }
}
