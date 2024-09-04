import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/domain/model/repository/todo_repo.dart';
import '../domain/model/todo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  final TodoRepo todoRepo;
  TodoCubit(this.todoRepo) : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final todoList = await todoRepo.getTodos();
      emit(todoList);
    } catch (e) {
      emit([]);
      print('Error loading todos: $e');
    }
  }

  Future<void> addTodo(Todo newTodo) async {
    try {
      await todoRepo.addTodo(newTodo);
      await loadTodos();
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await todoRepo.updateTodo(todo);
      await loadTodos();
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    try {
      await todoRepo.deleteTodo(todo);
      await loadTodos();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  Future<void> toggleCompletion(Todo todo) async {
    try {
      final newTodo = todo.toggleCompletion();
      await updateTodo(newTodo);
    } catch (e) {
      print('Error toggling todo completion: $e');
    }
  }
}
