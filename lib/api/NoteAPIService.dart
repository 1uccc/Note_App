import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Note.dart';

class NoteAPIService {
  static final NoteAPIService instance = NoteAPIService._init();
  final String baseUrl = 'http://10.0.2.2:3000/api/notes'; // 10.0.2.2/localhost

  NoteAPIService._init();

  // Lấy tất cả ghi chú
  Future<List<Note>> getAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accountId = prefs.getString('accountId');
    print('Account ID khi gọi getAllNotes: $accountId');

    if (accountId == null || accountId.isEmpty) {
      return [];
    }

    final Uri uri = Uri.parse('$baseUrl/$accountId');
    print('URI gọi getAllNotes: $uri');

    final response = await http.get(uri);
    print('Response status từ getAllNotes: ${response.statusCode}');
    print('Response body từ getAllNotes: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Note.fromMap(e)).toList();
    } else {
      throw Exception('Lỗi lấy dữ liệu: ${response.statusCode}');
    }
  }

  // Tạo ghi chú mới
  Future<void> createNote(Note note) async {
    try {
      final url = Uri.parse(baseUrl);
      final jsonData = note.toMap();
      jsonData.remove('id');
      print('Dữ liệu gửi khi tạo note: ${jsonEncode(jsonData)}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );
      print('Response status từ createNote: ${response.statusCode}');
      print('Response body từ createNote: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Lỗi khi tạo ghi chú: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lưu ghi chú: $e');
    }
  }

  // Lấy ghi chú theo id
  Future<Note> getNoteById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Note.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Không tìm thấy ghi chú');
    }
  }

  // Cập nhật ghi chú
  Future<void> updateNote(Note note) async {
    if (note.id == null) throw Exception('Note phải có id để cập nhật');

    final response = await http.put(
      Uri.parse('$baseUrl/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Lỗi cập nhật ghi chú: ${response.body}');
    }
  }

  // Xóa ghi chú
  Future<void> deleteNote(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Lỗi xóa ghi chú: ${response.body}');
    }
  }
}