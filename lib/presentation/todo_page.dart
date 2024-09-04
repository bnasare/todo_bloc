import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/domain/model/todo.dart';
import 'package:todo_bloc/presentation/todo_cubit.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  void _showTodoDialog(BuildContext context, {Todo? todo}) {
    final todoCubit = context.read<TodoCubit>();
    final todoTextController = TextEditingController(text: todo?.text ?? '');
    final isEditing = todo != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Todo' : 'Add Todo'),
        content: TextField(
          autofocus: true,
          controller: todoTextController,
          decoration: const InputDecoration(hintText: 'Enter Todo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (todoTextController.text.isNotEmpty) {
                if (isEditing) {
                  todoCubit.updateTodo(Todo(
                    id: todo.id,
                    text: todoTextController.text,
                    completed: todo.completed,
                  ));
                } else {
                  todoCubit.addTodo(Todo(
                    text: todoTextController.text,
                    id: DateTime.now().millisecondsSinceEpoch,
                  ));
                }
                Navigator.pop(context);
              }
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          if (todos.isEmpty) {
            return const Center(child: Text('No todos available'));
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.text,
                    style: todo.completed
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough)
                        : null),
                leading: Checkbox(
                  value: todo.completed,
                  onChanged: (value) {
                    todoCubit.toggleCompletion(todo);
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showTodoDialog(context, todo: todo),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.delete),
                      onPressed: () => todoCubit.deleteTodo(todo),
                    ),
                  ],
                ),
                onTap: () => _showTodoDialog(context, todo: todo),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoDialog(context),
        tooltip: 'Add Todo',
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
