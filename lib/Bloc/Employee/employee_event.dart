import 'package:employee_management_app/Data/Models/Employee/employee.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;
  AddEmployee(this.employee);
}

class UpdateEmployee extends EmployeeEvent {
  final int index;
  final Employee employee;
  UpdateEmployee(this.index, this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final int index;
  DeleteEmployee(this.index);
}
