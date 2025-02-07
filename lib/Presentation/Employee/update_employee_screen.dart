import 'package:employee_management_app/Bloc/Employee/employee_bloc.dart';
import 'package:employee_management_app/Bloc/Employee/employee_event.dart';
import 'package:employee_management_app/Data/Models/Employee/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateEmployeeScreen extends StatefulWidget {
  final int index;
  final Employee employee;

  const UpdateEmployeeScreen(
      {super.key, required this.index, required this.employee});

  @override
  _UpdateEmployeeScreenState createState() => _UpdateEmployeeScreenState();
}

class _UpdateEmployeeScreenState extends State<UpdateEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _roleController = TextEditingController(text: widget.employee.role);
    _startDate = widget.employee.startDate;
    _endDate = widget.employee.endDate;
  }

  void _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate! : _endDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  void _updateEmployee() {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null) {
      final updatedEmployee = Employee(
        name: _nameController.text,
        role: _roleController.text,
        startDate: _startDate!,
        endDate: _endDate!,
      );
      context
          .read<EmployeeBloc>()
          .add(UpdateEmployee(widget.index, updatedEmployee));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Employee")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Employee Name"),
                validator: (value) =>
                    value!.isEmpty ? "Enter employee name" : null,
              ),
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(labelText: "Employee Role"),
                validator: (value) =>
                    value!.isEmpty ? "Enter employee role" : null,
              ),
              ListTile(
                title:
                    Text("Start Date: ${_startDate!.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text("End Date: ${_endDate!.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEmployee,
                child: Text("Update Employee"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
