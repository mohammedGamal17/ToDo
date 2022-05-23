import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/shared/cubit/cubit.dart';
import '../../shared/components/components.dart';

import '../../shared/cubit/states.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  var textEditingController = TextEditingController();
  var timeTextEditingController = TextEditingController();
  var dateTextEditingController = TextEditingController();
  bool isEaditing = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..initialDb(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is AppInsertDataBase) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
              backgroundColor: const Color.fromRGBO(233, 239, 192, 1.0),
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: const Color.fromRGBO(78, 148, 79, 1.0),
                title: Text(cubit.titles[cubit.current]),
              ),
              body: cubit.screens[cubit.current],
              floatingActionButton: FloatingActionButton(
                  backgroundColor: const Color.fromRGBO(78, 148, 79, 1.0),
                  onPressed: () {
                    if (cubit.isBottomSheet0pend) {
                      if (_formKey.currentState!.validate()) {
                        cubit.insertIntoDatabase(
                          title: textEditingController.text,
                          time: timeTextEditingController.text,
                          date: dateTextEditingController.text,
                        );
                      }
                    } else {
                      scaffoldKey.currentState
                          ?.showBottomSheet((context) {
                            return Container(
                              color: const Color.fromRGBO(180, 225, 151, 1.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      textFormField(
                                        controller: textEditingController,
                                        labelText: 'Task Title',
                                        prefix: Icons.edit,
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Write your Task';
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 16.0),
                                      textFormField(
                                        controller: timeTextEditingController,
                                        labelText: 'Task Time',
                                        prefix: Icons.watch_later_outlined,
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeTextEditingController.text =
                                                value!.format(context);
                                          });
                                        },
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Write your Time';
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 16.0),
                                      textFormField(
                                        controller: dateTextEditingController,
                                        labelText: 'Task Date',
                                        prefix: Icons.date_range_outlined,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2200-12-30'))
                                              .then((value) {
                                            dateTextEditingController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'Write your Date';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                          .closed
                          .then((value) {
                            cubit.bottomSheetChange(
                                isShowing: false, floatIcon: Icons.edit);
                          });
                      cubit.isBottomSheet0pend = !cubit.isBottomSheet0pend;
                    }
                    cubit.bottomSheetChange(
                        isShowing: true, floatIcon: Icons.add);
                  },
                  child: Icon(cubit.floatingIcon)),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: const Color.fromRGBO(78, 148, 79, 1.0),
                selectedItemColor: Colors.white,
                currentIndex: cubit.current,
                onTap: (index) {
                  cubit.navChanged(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check), label: 'Done Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'Archive Tasks')
                ],
              ));
        },
      ),
    );
  }
}
