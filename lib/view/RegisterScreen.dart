import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool isLoading = false;

  Future<void> registerAccount() async {
    setState(() => isLoading = true);

    final url = Uri.parse('http://localhost:3000/api/accounts');
    final now = DateTime.now().toIso8601String();

    final body = jsonEncode({
      'userId': DateTime.now().millisecondsSinceEpoch,
      'username': username,
      'password': password,
      'status': 'active',
      'lastLogin': now,
      'createdAt': now,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tạo tài khoản thành công!')),
        );
        Navigator.pop(context);
      } else {

        print('Phản hồi từ server: ${response.body}');
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${error['message']}')),
        );
      }
    } catch (e) {
      print('Lỗi chi tiết: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký tài khoản')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
                onChanged: (value) => username = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    registerAccount();
                  }
                },
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}