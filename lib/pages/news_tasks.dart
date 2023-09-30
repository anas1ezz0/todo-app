
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocl/cubit.dart';
import '../blocl/status.dart';
import '../componants/componants.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStatus>(
      listener:(context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: tasksCondition(tasks: tasks)
        );
      },
    );
  }
}
