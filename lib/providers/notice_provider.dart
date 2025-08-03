import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/notice.dart';

final noticeProvider = FutureProvider.family<List<Notice>, String>((
    ref,
    username,
    ) async {
  final url = Uri.parse(
    'http://203.190.12.69/ems/jhorna/app/web_api/std_general_notice/std_general_notice_api.php?user_name=$username',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    if (jsonData['success'] == true) {
      final List notices = jsonData['all_notices'] ?? [];
      return notices.map((e) => Notice.fromJson(e)).toList();
    } else {
      throw Exception(jsonData['message']);
    }
  } else {
    throw Exception("Failed to fetch notices");
  }
});
