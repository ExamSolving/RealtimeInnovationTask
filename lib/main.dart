import 'package:employee_management_app/Bloc/Employee/employee_bloc.dart';
import 'package:employee_management_app/Bloc/Employee/employee_event.dart';
import 'package:employee_management_app/Data/Models/Employee/employee.dart';
import 'package:employee_management_app/Presentation/Employee/employee_screen.dart';
import 'package:employee_management_app/Repository/Employee/employee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EmployeeBloc(EmployeeRepository())..add(LoadEmployees()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: EmployeeListScreen(),
      ),
    );
  }
}
