import 'package:employee_management_app/Bloc/Employee/employee_bloc.dart';
import 'package:employee_management_app/Bloc/Employee/employee_event.dart';
import 'package:employee_management_app/Core/AppColors/app_colors.dart';
import 'package:employee_management_app/Core/Strings/strings.dart';
import 'package:employee_management_app/Data/Models/Employee/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AddUpdateEmployeeScreen extends StatefulWidget {
  final int? index;
  final Employee? employee;

  const AddUpdateEmployeeScreen({super.key, this.index, this.employee});

  @override
  _AddUpdateEmployeeScreenState createState() =>
      _AddUpdateEmployeeScreenState();
}

class _AddUpdateEmployeeScreenState extends State<AddUpdateEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedRole;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _roles = [
    "Product Designer",
    "Flutter Developer",
    "QA Tester",
    "Product Owner"
  ];

  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _selectedRole = widget.employee!.role;
      _startDate = widget.employee!.startDate;
      _endDate = widget.employee!.endDate;
    } else {
      _startDate = DateTime.now();
    }
  }

  void _openDatePicker(BuildContext context, bool isStartDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _CustomDatePicker(
          initialDate: isStartDate ? _startDate : _endDate,
          onDateSelected: (date) {
            setState(() {
              if (isStartDate) {
                _startDate = date;
              } else {
                _endDate = date;
              }
            });
          },
        );
      },
    );
  }

  void _openRoleSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: _roles.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Center(child: Text(_roles[index])),
                      onTap: () {
                        setState(() {
                          _selectedRole = _roles[index];
                        });
                        Navigator.pop(context);
                      },
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  void _addOrUpdateEmployee() {
    if (_formKey.currentState!.validate() &&
        _selectedRole != null &&
        _startDate != null &&
        _endDate != null) {
      FocusScope.of(context).unfocus();

      final employee = Employee(
        name: _nameController.text,
        role: _selectedRole!,
        startDate: _startDate!,
        endDate: _endDate!,
      );

      if (widget.employee != null) {
        context
            .read<EmployeeBloc>()
            .add(UpdateEmployee(widget.index ?? 0, employee));
      } else {
        context.read<EmployeeBloc>().add(AddEmployee(employee));
      }

      Future.delayed(Duration(milliseconds: 300), () {
        if (context.mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                context
                    .read<EmployeeBloc>()
                    .add(DeleteEmployee(widget.index ?? 0));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Employee data has been deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete_outline)),
          SizedBox(width: 10),
        ],
        title: Text(
            widget.employee != null ? "Edit Employee Details" : "Add Employee"),
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: WHITE_COLOR,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) => value!.isEmpty ? ENTER_EMP_NAME : null,
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: EMP_NAME,
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: PRIMARY_COLOR,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: _openRoleSelectionBottomSheet,
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(text: _selectedRole),
                  decoration: InputDecoration(
                    hintText: 'Select Role',
                    prefixIcon: Icon(
                      Icons.work_outline,
                      color: PRIMARY_COLOR,
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: PRIMARY_COLOR,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openDatePicker(context, true),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Start Date",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: PRIMARY_COLOR,
                          ),
                        ),
                        controller: TextEditingController(
                          text: _startDate != null
                              ? DateFormat('d MMM yyyy').format(_startDate!) ==
                                      DateFormat('d MMM yyyy')
                                          .format(DateTime.now())
                                  ? 'Today'
                                  : DateFormat('d MMM yyyy').format(_startDate!)
                              : "No date",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward,
                  color: PRIMARY_COLOR,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openDatePicker(context, false),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "End Date",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: PRIMARY_COLOR,
                          ),
                        ),
                        controller: TextEditingController(
                          text: _endDate != null
                              ? DateFormat('d MMM yyyy').format(_endDate!)
                              : "No date",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Spacer(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      foregroundColor: WHITE_COLOR,
                      elevation: 0.0,
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed:
                      _addOrUpdateEmployee, // Use the same method for both adding and updating
                  child: Text(widget.employee != null
                      ? "Update"
                      : "Save"), // Change text
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  const _CustomDatePicker(
      {required this.initialDate, required this.onDateSelected});

  @override
  __CustomDatePickerState createState() => __CustomDatePickerState();
}

class __CustomDatePickerState extends State<_CustomDatePicker> {
  late DateTime selectedDate;
  String? selectedButton;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
    selectedButton = "Today";
  }

  void _setDate(DateTime date, String button) {
    setState(() {
      selectedDate = date;
      selectedButton = button;
    });
    widget.onDateSelected(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: WHITE_COLOR,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: [
                _PresetDateButton(
                    label: "Today",
                    isSelected: selectedButton == "Today",
                    onTap: () => _setDate(DateTime.now(), "Today")),
                _PresetDateButton(
                    label: "Next Monday",
                    isSelected: selectedButton == "Next Monday",
                    onTap: () {
                      _setDate(
                          DateTime.now().add(
                              Duration(days: (8 - DateTime.now().weekday) % 7)),
                          "Next Monday");
                    }),
                _PresetDateButton(
                    label: "Next Tuesday",
                    isSelected: selectedButton == "Next Tuesday",
                    onTap: () {
                      _setDate(
                          DateTime.now().add(
                              Duration(days: (9 - DateTime.now().weekday) % 7)),
                          "Next Tuesday");
                    }),
                _PresetDateButton(
                    label: "After 1 week",
                    isSelected: selectedButton == "After 1 week",
                    onTap: () {
                      _setDate(DateTime.now().add(Duration(days: 7)),
                          "After 1 week");
                    }),
              ],
            ),
            SizedBox(height: 16),
            TableCalendar(
              daysOfWeekVisible: true,
              weekNumbersVisible: false,
              focusedDay: selectedDate,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              selectedDayPredicate: (day) => isSameDay(day, selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                _setDate(selectedDay, "Calendar");
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: SECONDARY_COLOR,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.arrow_left),
                rightChevronIcon: Icon(Icons.arrow_right),
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      foregroundColor: WHITE_COLOR,
                      elevation: 0.0,
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: () {
                    widget.onDateSelected(selectedDate);

                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _PresetDateButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetDateButton(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        foregroundColor: isSelected ? WHITE_COLOR : PRIMARY_COLOR,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: isSelected ? PRIMARY_COLOR : SECONDARY_COLOR,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        minimumSize: Size(120, 50),
      ),
      child: Text(label, style: TextStyle(fontSize: 12)),
    );
  }
}
