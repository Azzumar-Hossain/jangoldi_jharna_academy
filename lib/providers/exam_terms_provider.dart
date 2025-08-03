/*import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jangoldi_jharna_academy/models/exam_term_model.dart';
import 'package:jangoldi_jharna_academy/models/result_params_model.dart';
import 'package:jangoldi_jharna_academy/models/term_result_model.dart';

final examTermsProvider = FutureProvider.family<List<ExamTerm>, String>((
  ref,
  userName,
) async {
  final response = await http.get(
    Uri.parse(
      'http://203.190.12.69/ems/jhorna/app/web_api/std_exam_results/std_progress_report_api.php?user_name=$userName',
    ),
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to fetch terms");
  }

  final data = jsonDecode(response.body);
  return (data['data']['available_exam_type'] as List)
      .map((e) => ExamTerm.fromJson(e))
      .toList();
});

final resultProvider = FutureProvider.family<TermResult?, ResultParams>((
  ref,
  params,
) async {
  final userName = params.userName;
  final selectedTermId = params.selectedTermId;

  final uri =
      Uri.parse(
        'http://203.190.12.69/ems/jhorna/app/web_api/std_exam_results/std_progress_report_api.php',
      ).replace(
        queryParameters: {
          'user_name': userName,
          'exam_session': '2025',
          'exam_type[]': selectedTermId,
        },
      );

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch result');
  }

  final data = jsonDecode(response.body);
  final resultTest = data['data']['result_test'];
  if (resultTest == null || resultTest is! List) {
    throw Exception('Invalid result data');
  }

  final resultList = resultTest
      .map<TermResult>((e) => TermResult.fromJson(e))
      .toList();

  return resultList
          .where((term) => term.termId.toString() == selectedTermId)
          .isNotEmpty
      ? resultList.firstWhere(
          (term) => term.termId.toString() == selectedTermId,
        )
      : null;
});*/

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jangoldi_jharna_academy/models/exam_term_model.dart';
import 'package:jangoldi_jharna_academy/models/result_params_model.dart';
import 'package:jangoldi_jharna_academy/models/term_result_model.dart';

final examTermsProvider = FutureProvider.family<List<ExamTerm>, String>((
    ref,
    userName,
    ) async {
  final response = await http.get(
    Uri.parse(
      'http://203.190.12.69/ems/jhorna/app/web_api/std_exam_results/std_progress_report_api.php?user_name=$userName',
    ),
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to fetch terms");
  }

  final data = jsonDecode(response.body);
  final raw = data['data']?['available_exam_type'];

  // When no exam terms exist, API sends a String like "No Exam Type Created"
  if (raw is! List) {
    // Return empty list to UI; UI can show "No exam term created" state
    return <ExamTerm>[];
  }

  return raw
      .where((e) => e is Map<String, dynamic>)
      .map<ExamTerm>((e) => ExamTerm.fromJson(e as Map<String, dynamic>))
      .toList();
});

final resultProvider = FutureProvider.family<TermResult?, ResultParams>((
    ref,
    params,
    ) async {
  final userName = params.userName;
  final selectedTermId = params.selectedTermId;

  final uri =
  Uri.parse(
    'http://203.190.12.69/ems/jhorna/app/web_api/std_exam_results/std_progress_report_api.php',
  ).replace(
    queryParameters: {
      'user_name': userName,
      'exam_session': '2025',
      'exam_type[]': selectedTermId,
    },
  );

  final response = await http.get(uri);
  if (response.statusCode != 200) {
    throw Exception('Failed to fetch result');
  }

  final data = jsonDecode(response.body);
  final resultTest = data['data']?['result_test'];

  // Some responses return "No Result Found" (String) instead of a List
  if (resultTest is! List) {
    return null;
  }

  final resultList = resultTest
      .where((e) => e is Map<String, dynamic>)
      .map<TermResult>((e) => TermResult.fromJson(e as Map<String, dynamic>))
      .toList();

  // Find the selected term (if present)
  try {
    return resultList.firstWhere((t) => t.termId.toString() == selectedTermId);
  } catch (_) {
    return null;
  }
});
