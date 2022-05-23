import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/shared/cubit/cubit.dart';

import 'package:todo_list/shared/cubit/states.dart';

import '../../shared/components/components.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var task = AppCubit.get(context).newTask;
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: conditionBuilder(task: task),
        );
      },
    );
  }
}
