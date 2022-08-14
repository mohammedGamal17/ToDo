import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'layouts/home_screen/home_page.dart';
import 'shared/bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      );
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      color: const Color.fromRGBO(78, 148, 79, 1.0),
    );
  }
}
