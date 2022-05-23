import 'package:flutter/material.dart';
import '../cubit/cubit.dart';
import 'package:conditional_builder/conditional_builder.dart';

Widget textFormField({
  required TextEditingController controller,
  required Function validate,
  required String labelText,
  required IconData prefix,
  double borderRadius = 10.0,
  bool autoFocus = false,
  bool isPassword = false,
  IconData? suffix,
  Function? onTap,
}) {
  return TextFormField(
    controller: controller,
    autofocus: autoFocus,
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(prefix),
      border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius)),
    ),
    validator: (value) {
      return validate(value);
    },
    onTap: () {
      // ignore: void_checks
      return onTap!();
    },
  );
}

Widget tasks(Map model, context) {
  return Dismissible(
    key: Key(model['ID'].toString()),
    child: Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: const Color.fromRGBO(180, 225, 151, 1.0),
                  child: Text(model['time'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        model['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(78, 148, 79, 1.0),
                            fontSize: 18.0,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        model['date'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(180, 225, 151, 1.0),
                            fontSize: 16.0,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateOnDateBase(
                      status: 'done',
                      id: model['ID'],
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Task Done'),
                      backgroundColor: Color.fromRGBO(180, 225, 151, 1.0),
                    ));
                  },
                  icon: const Icon(Icons.done),
                  color: Colors.lightGreen,
                  splashColor: const Color.fromRGBO(180, 225, 151, 1.0),
                  highlightColor: const Color.fromRGBO(78, 148, 79, 1.0),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateOnDateBase(
                      status: 'archive',
                      id: model['ID'],
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Task Archived'),
                      backgroundColor: Color.fromRGBO(180, 225, 151, 1.0),
                    ));
                  },
                  icon: const Icon(Icons.archive_outlined),
                  color: Colors.black45,
                  splashColor: const Color.fromRGBO(180, 225, 151, 1.0),
                  highlightColor: const Color.fromRGBO(78, 148, 79, 1.0),
                ),
              ],
            ),
          ),
          //Green line
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: double.infinity,
              height: 2.0,
              color: const Color.fromRGBO(180, 225, 151, 0.5),
            ),
          ),
        ],
      ),
    ),
    background: Container(
      color: Colors.red,
      child: const Icon(Icons.delete),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteFromDateBase(
        id: model['ID'],
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task deleted'),
        backgroundColor: Color.fromRGBO(180, 225, 151, 1.0),
      ));
    },
  );
}

Widget conditionBuilder({
  required List<Map> task,
}) {
  return ConditionalBuilder(
    condition: task.isNotEmpty,
    builder: (context) => ListView.separated(
      itemBuilder: (context, index) => tasks(task[index], context),
      separatorBuilder: (context, index) => const SizedBox(
        height: 5.0,
      ),
      itemCount: task.length,
    ),
    fallback: (context) => Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu, color: Colors.black26, size: 75.0),
          Text(
            'This page is empty!'.toUpperCase(),
            style: const TextStyle(color: Colors.black26, fontSize: 20.0),
          ),
        ],
      ),
    ),
  );
}

Widget condition({
  required List<Map> user,
}) {
  return user.isNotEmpty
      ? ListView.separated(
          itemBuilder: (context, index) => tasks(user[index], context),
          separatorBuilder: (context, index) => const SizedBox(
            height: 5.0,
          ),
          itemCount: user.length,
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu, color: Colors.black26, size: 75.0),
            Text(
              'This page is empty!'.toUpperCase(),
              style: const TextStyle(color: Colors.black26, fontSize: 20.0),
            ),
          ],
        );
}
