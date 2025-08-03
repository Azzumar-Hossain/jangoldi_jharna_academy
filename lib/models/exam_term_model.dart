class ExamTerm {
  final String id;
  final String name;

  ExamTerm({required this.id, required this.name});

  factory ExamTerm.fromJson(Map<String, dynamic> json) {
    return ExamTerm(id: json['_id'].toString(), name: json['_term_name'] ?? '');
  }
}
