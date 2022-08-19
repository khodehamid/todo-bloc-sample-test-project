import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/todo_api.dart';
import '../bloc/todo_bloc.dart';

class CreateOrEditTodoPage extends StatefulWidget {
  const CreateOrEditTodoPage({Key? key, this.todoModel}) : super(key: key);
  final TodoModel? todoModel;
  @override
  State<CreateOrEditTodoPage> createState() => _CreateOrEditTodoPageState();
}

class _CreateOrEditTodoPageState extends State<CreateOrEditTodoPage> {
  late final TextEditingController _titleTextEditingController,
      _descriptionTextEditingController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _titleTextEditingController = TextEditingController(
        text: (widget.todoModel ?? TodoModel.empty).title);
    _descriptionTextEditingController = TextEditingController(
        text: (widget.todoModel ?? TodoModel.empty).description);
    super.initState();
  }

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _descriptionTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Todo Page'),
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error!.error ?? ''),
                ),
              );
          }
        },
        listenWhen: (prev, current) => prev != current,
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (String? text) {
                    return (text ?? '').length < 4
                        ? 'Title Must Be Greater Than 4 Charactors!'
                        : null;
                  },
                  controller: _titleTextEditingController,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: _descriptionTextEditingController,
                  minLines: 4,
                  maxLines: 6,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: widget.todoModel == null
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            context.read<TodoBloc>().add(
                                  CreateTodoPressed(
                                    title: _titleTextEditingController.text,
                                    description:
                                        _descriptionTextEditingController.text,
                                    createdAt: DateTime.now(),
                                    isComplete: false,
                                  ),
                                );
                          }
                        }
                      : () {
                          if (_formKey.currentState!.validate()) {
                            TodoModel editedTodoModel = widget.todoModel!
                                .copyWith(
                                    title: _titleTextEditingController.text,
                                    description:
                                        _descriptionTextEditingController.text);
                            context.read<TodoBloc>().add(
                                  EditTodoPressed(
                                    editedTodoModel: editedTodoModel,
                                  ),
                                );
                          }
                        },
                  child: widget.todoModel == null
                      ? const Text('Create ')
                      : const Text('Edit'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
