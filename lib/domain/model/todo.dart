class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Todo toggleCompletion() {
    return Todo(
      id: id,
      title: title,
      completed: !completed,
    );
  }
}
