import 'package:employee_management_app/Bloc/Employee/employee_bloc.dart';
import 'package:employee_management_app/Bloc/Employee/employee_event.dart';
import 'package:employee_management_app/Core/AppColors/app_colors.dart';
import 'package:employee_management_app/Data/Models/Employee/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedRole;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate;

  final List<String> _roles = [
    "Product Designer",
    "Flutter Developer",
    "QA Tester",
    "Product Owner"
  ];

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

  // Open a bottom sheet to select a role
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
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                    Divider(), // Divider between list items
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

  void _addEmployee() {
    if (_formKey.currentState!.validate() &&
        _selectedRole != null &&
        _startDate != null &&
        _endDate != null) {
      final employee = Employee(
        name: _nameController.text,
        role: _selectedRole!,
        startDate: _startDate!,
        endDate: _endDate!,
      );
      context.read<EmployeeBloc>().add(AddEmployee(employee));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Employee Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) =>
                    value!.isEmpty ? "Enter employee name" : null,
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Employee Name',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: PRIMARY_COLOR,
                  ), // Leading Icon
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: _openRoleSelectionBottomSheet, // Open bottom sheet on tap
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
                    ), // Leading Icon
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
                  onPressed: _addEmployee,
                  child: Text("Save"),
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

  _CustomDatePicker({required this.initialDate, required this.onDateSelected});

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
    selectedButton = "Today"; // Set default to "Today"
  }

  void _setDate(DateTime date, String button) {
    setState(() {
      selectedDate = date;
      selectedButton = button; // Update selected button
    });
    widget.onDateSelected(selectedDate); // Update parent state immediately
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
            // Use Wrap widget for responsive button layout
            Wrap(
              spacing: 8.0, // Horizontal spacing between buttons
              runSpacing: 8.0, // Vertical spacing between buttons
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
              daysOfWeekVisible:
                  false, // Hide the weekdays' labels (Mon, Tue, etc.)
              weekNumbersVisible: false, // Disable week numbers
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
                formatButtonVisible:
                    false, // Hides the button to change format (e.g., week vs month view)
                titleCentered: true, // Ensures the title is centered
                leftChevronIcon: Icon(Icons.arrow_left), // Customize left arrow
                rightChevronIcon:
                    Icon(Icons.arrow_right), // Customize right arrow
              ),
              // Optionally hide other UI elements here
            ),
            SizedBox(height: 16),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Test'),
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

  _PresetDateButton(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        foregroundColor: isSelected ? WHITE_COLOR : PRIMARY_COLOR,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: isSelected
            ? PRIMARY_COLOR
            : SECONDARY_COLOR, // Change color based on selection
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        minimumSize: Size(120, 50), // Minimum button size
      ),
      child: Text(label, style: TextStyle(fontSize: 12)),
    );
  }
}
