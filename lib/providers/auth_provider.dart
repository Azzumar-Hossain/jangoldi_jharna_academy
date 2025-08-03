import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/student_profile.dart';

final authProvider =
StateNotifierProvider<AuthController, AsyncValue<StudentProfile?>>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<AsyncValue<StudentProfile?>> {
  AuthController() : super(const AsyncValue.data(null));

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    final url = Uri.parse(
      'http://203.190.12.69/ems/jhorna/app/web_api/login/login_api.php?user_name=$username&password=$password',
    );

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true) {
          final profileJson = jsonData['data']['profile'][0];
          final profile = StudentProfile.fromJson(profileJson);
          state = AsyncValue.data(profile);
        } else {
          state = AsyncValue.error(jsonData['message'], StackTrace.current);
        }
      } else {
        state = AsyncValue.error("Server error", StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error("Network error: $e", StackTrace.current);
    }
  }
}
