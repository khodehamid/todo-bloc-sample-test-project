import 'package:base_repository/base_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_project_test/todo_view/view/create_or_edit_todo_page.dart';
import 'package:flutter_bloc_project_test/utils/utils.dart';
import 'package:todo_api/todo_api.dart';
import '../bloc/todo_bloc.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              return DropdownButton<FilterTodosBase>(
                dropdownColor: Colors.white,
                underline: const SizedBox.shrink(),
                value: state.filterTodosBase,
                items: List.generate(
                  AppConfig.filteredTodosBase.length,
                  (index) => DropdownMenuItem<FilterTodosBase>(
                    value: AppConfig.filteredTodosBase.values.elementAt(index),
                    child: Text(
                      AppConfig.filteredTodosBase.keys.elementAt(index),
                    ),
                  ),
                ),
                onChanged: (FilterTodosBase? filterTodoBase) {
                  context.read<TodoBloc>().add(
                        SortTodoPressed(
                          filterBase: filterTodoBase!,
                        ),
                      );
                },
              );
            },
          ),
        ],
        title: const Text('Todos'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          context
              .select((TodoBloc bloc) => (bloc.state.listOfTodos ?? []).length);
          if (state.isLoading == true) {
            return const LoadingWidget();
          } else if (state.error != null) {
            return NoDataText(
              text: state.error!.error ?? '',
            );
          } else {
            final List<TodoModel> listOfTodos = state.listOfTodos ?? [];
            return listOfTodos.isEmpty
                ? const NoDataText()
                : ListOfTodosListViewWidget(
                    listOfTodos: listOfTodos,
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, Animation<double> animation1,
                  Animation<double> animation2) {
                return ScaleTransition(
                  scale: animation1,
                  child: RotationTransition(
                    turns: animation1,
                    child: const CreateOrEditTodoPage(),
                  ),
                );
              },
              opaque: false,
            ),
          );
        },
      ),
    );
  }
}

class ListOfTodosListViewWidget extends StatelessWidget {
  const ListOfTodosListViewWidget({
    Key? key,
    required this.listOfTodos,
  }) : super(key: key);

  final List<TodoModel> listOfTodos;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final TodoModel todoModel = listOfTodos.elementAt(index);
        return Dismissible(
          key: ValueKey(todoModel.id),
          background: const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          confirmDismiss: (DismissDirection direction) async {
            if (direction == DismissDirection.endToStart) {
              final TodoBloc todoBloc = context.read<TodoBloc>();
              todoBloc.add(
                DeleteTodoPressed(todoId: todoModel.id),
              );
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text('Todo Was Deleted!'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        context.read<TodoBloc>().add(
                              CreateTodoPressed(
                                createdAt: todoModel.createdAt,
                                description: todoModel.description,
                                isComplete: todoModel.isComplete,
                                title: todoModel.title,
                              ),
                            );
                      },
                    ),
                  ),
                );
              return true;
            }
            return false;
          },
          child: ListTile(
            subtitle: Text(todoModel.description ?? ''),
            trailing: Checkbox(
              value: todoModel.isComplete,
              onChanged: (bool? value) {
                final TodoModel _tempTodoModle =
                    todoModel.copyWith(isComplete: value ?? false);
                context.read<TodoBloc>().add(EditTodoPressed(
                      editedTodoModel: _tempTodoModle,
                    ));
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateOrEditTodoPage(
                    todoModel: todoModel,
                  ),
                ),
              );
            },
            title: Text(todoModel.title),
          ),
        );
      },
      itemCount: listOfTodos.length,
    );
  }
}
