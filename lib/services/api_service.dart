import 'dart:convert';
import 'package:frontend/constants.dart';
import 'package:http/http.dart' as http;

const apiUrl = 'http://$baseUrl';

Future<Map<String, dynamic>> loginOrRegister(String username, String password) async {
  final res = await http.post(
    Uri.parse('$apiUrl/auth/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Ошибка авторизации');
}

Future<List<dynamic>> getNotes(int userId) async {
  final res = await http.get(Uri.parse('$apiUrl/notes/?user_id=$userId'));
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Ошибка при получении заметок');
}

Future<void> createNote(int userId, String title, String content) async {
  await http.post(
    Uri.parse('$apiUrl/notes/?user_id=$userId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'title': title, 'content': content}),
  );
}

Future<void> deleteNote(int noteId, int userId) async {
  final res = await http.delete(
    Uri.parse('$apiUrl/notes/$noteId/$userId'),
    headers: {'Content-Type': 'application/json'},
  );
  if (res.statusCode != 200) {
    throw Exception('Ошибка при удалении заметки');
  }
}
