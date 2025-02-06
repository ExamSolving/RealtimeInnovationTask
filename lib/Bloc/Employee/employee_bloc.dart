import 'package:employee_management_app/Repository/Employee/employee_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc(this.repository) : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
  }

  void _onLoadEmployees(
      LoadEmployees event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      final employees = await repository.getEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError("Failed to load employees"));
    }
  }

  void _onAddEmployee(AddEmployee event, Emitter<EmployeeState> emit) async {
    await repository.addEmployee(event.employee);
    add(LoadEmployees());
  }

  void _onUpdateEmployee(
      UpdateEmployee event, Emitter<EmployeeState> emit) async {
    await repository.updateEmployee(event.index, event.employee);
    add(LoadEmployees());
  }

  void _onDeleteEmployee(
      DeleteEmployee event, Emitter<EmployeeState> emit) async {
    await repository.deleteEmployee(event.index);
    add(LoadEmployees());
  }
}
