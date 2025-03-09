import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlanManagerScreen(),
    );
  }
}

class Plan {
  String name;
  String description;
  DateTime date;
  bool isCompleted;

  Plan({
    required this.name,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });
}

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({Key? key}) : super(key: key);

  @override
  State<PlanManagerScreen> createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> _plans = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _showCreatePlanDialog() {
    _nameController.clear();
    _descriptionController.clear();
    _selectedDate = null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Plan'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Text(_selectedDate != null
                    ? _selectedDate.toString().split(' ').first
                    : 'Select Date'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && _selectedDate != null) {
                setState(() {
                  _plans.add(
                    Plan(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      date: _selectedDate!,
                    ),
                  );
                });
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _updatePlan(int index) {
    final _updateNameController = TextEditingController(text: _plans[index].name);
    final _updateDescriptionController = TextEditingController(
        text: _plans[index].description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Plan'),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _updateNameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _updateDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _plans[index].name = _updateNameController.text;
                _plans[index].description = _updateDescriptionController.text;
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _toggleCompletion(int index) {
    setState(() {
      _plans[index].isCompleted = !_plans[index].isCompleted;
    });
  }

  void _deletePlan(int index) {
    setState(() {
      _plans.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Plans'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: SfCalendar(
              view: CalendarView.month,
              dataSource: MeetingDataSource(_plans.map((plan) => Meeting(
                eventName: plan.name,
                from: plan.date,
                to: plan.date.add(const Duration(hours: 1)),
                background: const Color(0xFF0F8644),
                isAllDay: false,
              )).toList()),
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: _plans.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onDoubleTap: () {
                    _deletePlan(index);
                  },
                  onLongPress: () {
                    _updatePlan(index);
                  },
                  child: Dismissible(
                    key: Key(_plans[index].name),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16.0),
                      child: const Icon(Icons.check, color: Colors.black),
                    ),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        _toggleCompletion(index);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _plans[index].isCompleted ? Colors.green : Colors.blue,
                      ),
                      child: ListTile(
                        title: Text(
                          _plans[index].name,
                          style: TextStyle(
                            decoration: _plans[index].isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(_plans[index].description),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _showCreatePlanDialog,
            child: const Text('Create Plan'),
          ),
        ],
      ),
    );
  }
}

class Meeting {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  Meeting({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
  });
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;

  @override
  String getSubject(int index) => appointments![index].eventName;

  @override
  Color getColor(int index) => appointments![index].background;

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;
}
