import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/shared/cubit/states.dart';

import '../../modules/archive_page/arcive_page.dart';
import '../../modules/done_page/done_page.dart';
import '../../modules/tasks_page/tasks_page.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInit());

  static AppCubit get(context) => BlocProvider.of(context);
  var current = 0;
  List<Map> newTask = [];
  List<Map> doneTask = [];
  List<Map> archiveTask = [];
  List<Widget> screens = const [
    TasksPage(),
    DonePage(),
    ArchivePage(),
  ];
  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  void navChanged(int index) {
    current = index;
    emit(AppNavBarChange());
  }

  bool isBottomSheet0pend = false;
  IconData floatingIcon = Icons.edit;

  void bottomSheetChange({
    required bool isShowing,
    required IconData floatIcon,
  }) {
    isBottomSheet0pend = isShowing;
    floatingIcon = floatIcon;
    emit(AppBottomSheetChange());
  }

  late Database myDb;

  void initialDb() {
    openDatabase('Todo.db', version: 1, onCreate: _onCreate, onOpen: (myDb) {
      getFromDateBase(myDb);
    }).then((value) {
      myDb = value;
      emit(AppCreateDataBase());
    });
    if (kDebugMode) {
      print('Database and Tables are created');
    }
  }

  _onCreate(Database myDb, version) async {
    return await myDb.execute(
      'CREATE TABLE Tasks( ID INTEGER PRIMARY KEY, title TEXT,time TEXT, date TEXT, status TEXT)',
    );
  }

  insertIntoDatabase({
    required title,
    required time,
    required date,
  }) async {
    return await myDb.transaction((txn) => txn
            .rawInsert(
          'INSERT INTO Tasks(title, time, date, status) VALUES("$title", "$time", "$date", "new")',
        )
            .then((value) {
          if (kDebugMode) {
            print('$value inserted');
          }
          emit(AppInsertDataBase());
          getFromDateBase(myDb);
        }));
  }

  updateOnDateBase({
    required String status,
    required int id,
  }) async {
    myDb.rawUpdate('UPDATE Tasks SET status = ? WHERE ID = ?',
        [status, '$id']).then((value) {
      emit(AppUpdateDataBase());
      getFromDateBase(myDb);
    });
    if (kDebugMode) {
      print('updated');
    }
  }

  deleteFromDateBase({
    required int id,
  }) async {
    return myDb
        .rawDelete('DELETE FROM Tasks WHERE ID = ?', ['$id']).then((value) {
      emit(AppDeleteDataBase());
      getFromDateBase(myDb);
    });
  }

  void getFromDateBase(myDb) {
    newTask = [];
    doneTask = [];
    archiveTask = [];
    emit(AppGetDataBase());
    // Get the records
    myDb.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTask.add(element);
        } else if (element['status'] == 'done') {
          doneTask.add(element);
        } else {
          archiveTask.add(element);
        }
      });
      if (kDebugMode) {
        print(newTask);
      }
      emit(AppGetDataBase());
    });
  }
}
