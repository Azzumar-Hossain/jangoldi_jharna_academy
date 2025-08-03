/*class AttendanceItem {
  final String id;
  final String atdStatus;
  final String breakAtdStatus;
  final String lateTime;
  final String comments;
  final String entryDate;

  AttendanceItem({
    required this.id,
    required this.atdStatus,
    required this.breakAtdStatus,
    required this.lateTime,
    required this.comments,
    required this.entryDate,
  });

  factory AttendanceItem.fromJson(Map<String, dynamic> json) {
    return AttendanceItem(
      id: json['_id'],
      atdStatus: json['_atd_status'],
      breakAtdStatus: json['_break_atd_status'],
      lateTime: json['_late_time'],
      comments: json['_comments'],
      entryDate: json['_entry_date'],
    );
  }
}

class AttendanceDetails {
  final String totalPresent;
  final String totalAbsent;
  final String totalLate;
  final String totalLeave;

  AttendanceDetails({
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLate,
    required this.totalLeave,
  });

  factory AttendanceDetails.fromJson(Map<String, dynamic> json) {
    return AttendanceDetails(
      totalPresent: json['total_present'],
      totalAbsent: json['total_absent'],
      totalLate: json['total_late'],
      totalLeave: json['total_leave'],
    );
  }
}

class AttendanceResponse {
  final List<AttendanceItem> attendanceList;
  final AttendanceDetails summary;

  AttendanceResponse({required this.attendanceList, required this.summary});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AttendanceResponse(
      attendanceList: (data['std_attendance'] as List)
          .map((e) => AttendanceItem.fromJson(e))
          .toList(),
      summary: AttendanceDetails.fromJson(data['std_attendance_details'][0]),
    );
  }
}*/
class AttendanceItem {
  final String id;
  final String atdStatus;
  final String breakAtdStatus;
  final String lateTime;
  final String comments;
  final String entryDate;

  AttendanceItem({
    required this.id,
    required this.atdStatus,
    required this.breakAtdStatus,
    required this.lateTime,
    required this.comments,
    required this.entryDate,
  });

  factory AttendanceItem.fromJson(Map<String, dynamic> json) {
    return AttendanceItem(
      id: json['_id'] ?? '',
      atdStatus: json['_atd_status'] ?? '',
      breakAtdStatus: json['_break_atd_status'] ?? '',
      lateTime: json['_late_time'] ?? '',
      comments: json['_comments'] ?? '',
      entryDate: json['_entry_date'] ?? '',
    );
  }
}

class AttendanceDetails {
  final String totalPresent;
  final String totalAbsent;
  final String totalLate;
  final String totalLeave;

  AttendanceDetails({
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLate,
    required this.totalLeave,
  });

  factory AttendanceDetails.fromJson(Map<String, dynamic> json) {
    return AttendanceDetails(
      totalPresent: json['total_present'] ?? '0',
      totalAbsent: json['total_absent'] ?? '0',
      totalLate: json['total_late'] ?? '0',
      totalLeave: json['total_leave'] ?? '0',
    );
  }
}

class AttendanceResponse {
  final List<AttendanceItem> attendanceList;
  final AttendanceDetails summary;

  AttendanceResponse({required this.attendanceList, required this.summary});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    // Handle std_attendance as list or empty list
    final attendanceRaw = data['std_attendance'];
    final attendanceList = attendanceRaw is List
        ? attendanceRaw.map((e) => AttendanceItem.fromJson(e)).toList()
        : <AttendanceItem>[];

    // Handle summary safely if list is empty or not a list
    final summaryRaw = data['std_attendance_details'];
    final summary = (summaryRaw is List && summaryRaw.isNotEmpty)
        ? AttendanceDetails.fromJson(summaryRaw[0])
        : AttendanceDetails(
      totalPresent: '0',
      totalAbsent: '0',
      totalLate: '0',
      totalLeave: '0',
    );

    return AttendanceResponse(attendanceList: attendanceList, summary: summary);
  }
}
