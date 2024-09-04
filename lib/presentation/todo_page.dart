import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/domain/model/todo.dart';
import 'package:todo_bloc/presentation/todo_cubit.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final todoTextController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
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
              todoCubit.addTodo(Todo(
                  text: todoTextController.text,
                  id: DateTime.now().millisecondsSinceEpoch));
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.watch<TodoCubit>();

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
              if (todo.text.isEmpty) return const SizedBox.shrink();
              return ListTile(
                title: Text(todo.text),
                leading: Checkbox(
                  value: todo.completed,
                  onChanged: (value) {
                    todoCubit.toggleCompletion(todo);
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(CupertinoIcons.delete),
                  onPressed: () => todoCubit.deleteTodo(todo),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoBox(context),
        tooltip: 'Add Todo',
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
