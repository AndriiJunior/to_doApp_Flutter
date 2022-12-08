class Task {
  String content;
  DateTime timestemp;
  bool done;
  Task({
    required this.content,
    required this.timestemp,
    required this.done,
  });

  factory Task.fromMap(Map task) {
    return Task(
      content: task['content'],
      timestemp: task['timestemp'],
      done: task['done'],
    );
  }

  Map toMap() {
    return {
      'content': content,
      'timestemp': timestemp,
      'done': done,
    };
  }
}
