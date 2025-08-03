class Notice {
  final String id;
  final String subject;
  final String body;
  final String date;

  Notice({
    required this.id,
    required this.subject,
    required this.body,
    required this.date,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['_id'] ?? '',
      subject: json['_notice_subject'] ?? '',
      body: json['_notice_body'] ?? '',
      date: json['notice_date'] ?? '',
    );
  }
}
