import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Account.dart';

class AccountAPIService {
  static final AccountAPIService _instance = AccountAPIService._internal();
  factory AccountAPIService() => _instance;

  final String baseUrl = 'http://localhost:3000/api/accounts';
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  AccountAPIService._internal();

  // Đăng nhập
  Future<Account?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return Account.fromMap(json.decode(response.body));
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Đăng ký
  Future<Account> register(Account account) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: account.toJson(),
    );

    if (response.statusCode == 201) {
      return Account.fromMap(json.decode(response.body));
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  // Lấy thông tin tài khoản
  Future<Account?> getAccount(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Account.fromMap(json.decode(response.body));
    }
    return null;
  }

  // Cập nhật thông tin tài khoản
  Future<Account> updateAccount(Account account) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${account.id}'),
      headers: headers,
      body: account.toJson(),
    );

    if (response.statusCode == 200) {
      return Account.fromMap(json.decode(response.body));
    } else {
      throw Exception('Update failed: ${response.body}');
    }
  }

  // Kiểm tra username tồn tại
  Future<bool> checkUsernameExists(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/check-username?username=$username'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['exists'] ?? false;
    }
    return false;
  }
}