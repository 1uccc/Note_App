import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/NoteAPIService.dart';
import '../model/Note.dart';
import '../view/NoteForm.dart';

class AddnoteScreen extends StatelessWidget {
  const AddnoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoteForm(
      onSave: (Note note) async {
        final prefs = await SharedPreferences.getInstance();
        final String? accountId = prefs.getString('accountId');
        print('Account ID khi tạo note: $accountId');
        if (accountId == null || accountId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lỗi: Không tìm thấy ID tài khoản. Vui lòng đăng nhập lại.'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context, false);
          return;
        }

        final Note noteToSave = note.copyWith(idAccount: accountId);
        print('Note to save: ${noteToSave.toMap()}');

        try {
          await NoteAPIService.instance.createNote(noteToSave);
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ghi chú đã thêm thành công'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi lưu ghi chú: $e'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context, false);
        }
      },
    );
  }
}