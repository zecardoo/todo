class Task {
  final String name;
  final String description;
  final DateTime dueDate;
  bool isCompleted;

  Task({
    required this.name,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });
}