import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment Plans',
      theme: ThemeData(primarySwatch: Colors.blue),
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
  const PlanManagerScreen({super.key});

  @override
  State<PlanManagerScreen> createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  final List<Plan> _plans = [];
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
        title: const Text('Create New Plan'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Plan Name'),
                validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days:365)),
                  );
                  if (pickedDate != null) {
                    setState(() => _selectedDate = pickedDate);
                  }
                },
                child: Text(_selectedDate != null
                  ? "Selected Date: ${_selectedDate!.toLocal()}".split(' ')[0]
                  : 'Select Date'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && _selectedDate != null) {
                setState(() {
                  _plans.add(Plan(
                    name: _nameController.text,
                    description: _descriptionController.text,
                    date: _selectedDate!,
                  ));
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  // Implement other methods (_updatePlan, _toggleCompletion, etc.) similarly...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Plans')),
      body: Column(children:[
        Expanded(
          flex:5,
          child:SfCalendar(
            view:CalendarView.month,
            allowDragAndDrop:true,
            dataSource:AppointmentDataSource(_plans),
            // handle dragEnd etc...
          )
        ),
        Expanded(
          flex:5,
          child:// your ListView.builder here...
          Container(), // placeholder
        ),
        ElevatedButton(onPressed:_showCreatePlanDialog,child:const Text('Create Plan')),
      ]),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Plan> plans){
    appointments=plans.map((plan)=>Appointment(
      eventName:plan.name,
      from:plan.date,
      to:plan.date.add(const Duration(hours:1)),
      backgroundColor:(plan.isCompleted)?Colors.green : Colors.blue
    )).toList();
  }

  @override DateTime getStartTime(int index)=>appointments![index].from;
  
  @override DateTime getEndTime(int index)=>appointments![index].to;
  
  @override String getSubject(int index)=>appointments![index].eventName;
  
  @override Color getColor(int index)=>appointments![index].backgroundColor;
  
  @override bool isAllDay(int index)=>false;
}

class Appointment{
 String eventName;
 DateTime from,to;
 Color backgroundColor;

 Appointment({required this.eventName,required this.from,required this.to,required this.backgroundColor});
}
