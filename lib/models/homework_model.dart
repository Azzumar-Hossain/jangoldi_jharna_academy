class Homework {
  final String id;
  final String commonTopics;
  final String topics;
  final String entryDate;

  Homework({
    required this.id,
    required this.commonTopics,
    required this.topics,
    required this.entryDate,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['_id'],
      commonTopics: json['_homework_common_topics'],
      topics: json['_homework_topics'],
      entryDate: json['_entry_date'],
    );
  }
}
