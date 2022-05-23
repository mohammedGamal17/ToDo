import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/shared/cubit/cubit.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/states.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var task = AppCubit.get(context).archiveTask;
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: conditionBuilder(task: task),
        );
      },
    );
  }
}
