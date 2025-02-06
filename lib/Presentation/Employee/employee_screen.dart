import 'package:employee_management_app/Bloc/Employee/employee_bloc.dart';
import 'package:employee_management_app/Bloc/Employee/employee_event.dart';
import 'package:employee_management_app/Bloc/Employee/employee_state.dart';
import 'package:employee_management_app/Core/AppColors/app_colors.dart';
import 'package:employee_management_app/Core/Images/images.dart';
import 'package:employee_management_app/Core/Strings/strings.dart';
import 'package:employee_management_app/Presentation/Employee/add_employee_screen.dart';
import 'package:employee_management_app/Presentation/Employee/update_employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREY_COLOR,
      appBar: AppBar(
        title: Text(EMP_LIST_STR),
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: WHITE_COLOR,
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            return state.employees.length == 0
                ? Center(
                    child: Image.asset(NO_EMP_IMG),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Current Employees',
                          style: TextStyle(color: PRIMARY_COLOR),
                        ),
                      ),
                      Container(
                        height: 500,
                        color: WHITE_COLOR,
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: state.employees.length,
                            itemBuilder: (context, index) {
                              final employee = state.employees[index];
                              return ListTile(
                                title: Text(employee.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      employee.role,
                                      style: TextStyle(color: GREY_COLOR),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'From ${DateFormat('d MMM yyyy').format(employee.startDate)}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateEmployeeScreen(
                                                    index: index,
                                                    employee: employee),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        context
                                            .read<EmployeeBloc>()
                                            .add(DeleteEmployee(index));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
          }
          return Center(child: Text("No Employees Found"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: WHITE_COLOR,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
          );
        },
      ),
    );
  }
}
