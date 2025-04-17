import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/NoteAPIService.dart';
import '../model/Note.dart';
import '../view/NoteForm.dart';

class EditNoteScreen extends StatelessWidget {
  final Note note;

  const EditNoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoteForm(
      note: note,
      onSave: (Note updatedNote) async {
        final prefs = await SharedPreferences.getInstance();
        final String? accountId = prefs.getString('accountId');

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

        final Note noteToUpdate = updatedNote.copyWith(idAccount: accountId);

        try {
          await NoteAPIService.instance.updateNote(noteToUpdate);
          Navigator.pop(context, true);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật ghi chú thành công'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi cập nhật ghi chú : $e'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context, false);
        }
      },
    );
  }
}