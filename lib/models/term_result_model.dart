/*class TermResult {
  final int termId;
  final String termName;
  final List<SubjectResult> subjects;

  TermResult({
    required this.termId,
    required this.termName,
    required this.subjects,
  });

  factory TermResult.fromJson(Map<String, dynamic> json) {
    return TermResult(
      termId: int.parse(json['term_id'].toString()),
      termName: json['term_name'] ?? '',
      subjects: (json['results'] as List)
          .map((e) => SubjectResult.fromJson(e))
          .toList(),
    );
  }
}

class SubjectResult {
  final String subjectName;
  final String totalMarks;
  final String gpa;
  final String grade;

  SubjectResult({
    required this.subjectName,
    required this.totalMarks,
    required this.gpa,
    required this.grade,
  });

  factory SubjectResult.fromJson(Map<String, dynamic> json) {
    return SubjectResult(
      subjectName: json['_subject_full_name'] ?? '',
      totalMarks: json['_obt_total_marks'] ?? '0',
      gpa: json['_obt_gpa'] ?? '0.0',
      grade: json['_obt_grade'] ?? '',
    );
  }
}*/

class TermResult {
  final int termId;
  final String termName;
  final List<SubjectResult> subjects;

  TermResult({
    required this.termId,
    required this.termName,
    required this.subjects,
  });

  factory TermResult.fromJson(Map<String, dynamic> json) {
    final resultsRaw = json['results'];
    final subjects = resultsRaw is List
        ? resultsRaw
        .where((e) => e is Map<String, dynamic>)
        .map<SubjectResult>(
          (e) => SubjectResult.fromJson(e as Map<String, dynamic>),
    )
        .toList()
        : <SubjectResult>[];

    return TermResult(
      termId: int.tryParse(json['term_id']?.toString() ?? '') ?? 0,
      termName: json['term_name']?.toString() ?? '',
      subjects: subjects,
    );
  }
}

class SubjectResult {
  final String subjectName;
  final String totalMarks;
  final String gpa;
  final String grade;

  SubjectResult({
    required this.subjectName,
    required this.totalMarks,
    required this.gpa,
    required this.grade,
  });

  factory SubjectResult.fromJson(Map<String, dynamic> json) {
    return SubjectResult(
      subjectName: json['_subject_full_name']?.toString() ?? '',
      totalMarks: json['_obt_total_marks']?.toString() ?? '0',
      gpa: json['_obt_gpa']?.toString() ?? '0.0',
      grade: json['_obt_grade']?.toString() ?? '',
    );
  }
}
