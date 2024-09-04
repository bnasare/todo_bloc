import 'package:isar/isar.dart';

import '../../domain/model/todo.dart';

part 'isar_todo.g.dart';

@collection
class TodoIsar {
  Id id = Isar.autoIncrement;
  late String text;
  late bool completed;

  Todo toDomain() {
    return Todo(
      id: id,
      text: text,
      completed: completed,
    );
  }

  static TodoIsar fromDomain(Todo todo) {
    return TodoIsar()
      ..id = todo.id
      ..text = todo.text
      ..completed = todo.completed;
  }
}
