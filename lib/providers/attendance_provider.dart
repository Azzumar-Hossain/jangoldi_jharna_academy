import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/attendance_model.dart';

final attendanceProvider = FutureProvider.family<AttendanceResponse, String>((
    ref,
    userName,
    ) async {
  final url = Uri.parse(
    'http://203.190.12.69/ems/jhorna/app/web_api/attendance/mobile/std_attendance_summary_api.php?user_name=$userName',
  );

  final res = await http.get(url);
  final jsonRes = jsonDecode(res.body);

  if (jsonRes['success'] != true) {
    throw Exception('Failed to load attendance');
  }

  return AttendanceResponse.fromJson(jsonRes);
});
