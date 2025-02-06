import 'package:employee_management_app/Bloc/Employee/employee_bloc.dart';
import 'package:employee_management_app/Bloc/Employee/employee_event.dart';
import 'package:employee_management_app/Bloc/Employee/employee_state.dart';
import 'package:employee_management_app/Core/AppColors/app_colors.dart';
import 'package:employee_management_app/Core/Images/images.dart';
import 'package:employee_management_app/Core/Strings/strings.dart';
import 'package:employee_management_app/Presentation/Employee/add_update_employee_screen.dart';
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
            return state.employees.isEmpty
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
                        color: WHITE_COLOR,
                        height: 300,
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: state.employees.length,
                            itemBuilder: (context, index) {
                              final employee = state.employees[index];
                              return Column(
                                children: [
                                  Dismissible(
                                    key: Key(employee.name),
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 20),
                                      child: Icon(Icons.delete,
                                          color: WHITE_COLOR),
                                    ),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      context
                                          .read<EmployeeBloc>()
                                          .add(DeleteEmployee(index));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Employee data has been deleted'),
                                          duration: Duration(
                                              seconds:
                                                  2), // Adjust duration as needed
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddUpdateEmployeeScreen(
                                              employee: employee,
                                            ),
                                          ),
                                        );
                                      },
                                      title: Text(employee.name),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            employee.role,
                                            style: TextStyle(color: GREY_COLOR),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'From ${DateFormat('d MMM yyyy').format(employee.startDate)}',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 0.0,
                                    color: LIGHT_GREY_COLOR,
                                  ),
                                ],
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
            MaterialPageRoute(builder: (context) => AddUpdateEmployeeScreen()),
          );
        },
      ),
    );
  }
}
