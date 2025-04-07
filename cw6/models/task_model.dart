class Task {
  String id;
  String name;
  bool completed;
  String day;
  String timeSlot;

  Task({
    required this.id,
    required this.name,
    required this.completed,
    required this.day,
    required this.timeSlot,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'completed': completed,
      'day': day,
      'timeSlot': timeSlot,
    };
  }

  static Task fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      name: map['name'],
      completed: map['completed'],
      day: map['day'],
      timeSlot: map['timeSlot'],
    );
  }
}
