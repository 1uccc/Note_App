import 'package:flutter/material.dart';
import '../api/NoteAPIService.dart';
import '../model/Note.dart';
import '../view/NoteForm.dart';

class AddnoteScreen extends StatelessWidget{
  const AddnoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return NoteForm(
      onSave: (Note note) async {
        try {
          await NoteAPIService.instance.createNote(note);
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ghi chú đã thêm thành '),
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