class Todo {
  final int id;
  final String text;
  final bool completed;

  Todo({
    required this.id,
    required this.text,
    this.completed = false,
  });

  Todo toggleCompletion() {
    return Todo(
      id: id,
      text: text,
      completed: !completed,
    );
  }
}
