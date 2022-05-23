class Task {
  // ignore: non_constant_identifier_names
  int ID = 0;

  String title;

  String time;

  String date;

  String status = 'new';

  Task({
    required this.title,
    required this.time,
    required this.date,
  });
}
