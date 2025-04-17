import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../model/Note.dart';
import '../view/EditNoteScreen.dart';
import '../api/NoteAPIService.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Note _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  Future<void> _editNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(note: _note),
      ),
    );

    if (result == true) {
      final updatedNote = await NoteAPIService.instance.getNoteById(_note.id!);
      if (updatedNote != null) {
        setState(() {
          _note = updatedNote;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color noteColor = Color(
        int.tryParse(_note.color ?? '') ?? Colors.white.value,);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết ghi chú'),
        backgroundColor: noteColor,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Tiêu đề', _note.title),
                    Divider(),
                    _buildDetailRow('Nội dung', _note.content),
                    Divider(),
                    _buildDetailRow('Độ ưu tiên', _note.priority.toString()),
                    Divider(),
                    _buildDetailRow(
                      'Ngày tạo',
                      DateFormat('dd/MM/yyyy').format(_note.createAt),
                    ),
                    Divider(),
                    _buildDetailRow(
                      'Ngày sửa',
                      DateFormat('dd/MM/yyyy').format(_note.modifiedAt),
                    ),
                    Divider(),
                    _buildDetailRow('Tags', _note.tags.join(', ')),
                    Divider(),
                    _buildDetailRow('Màu sắc', _note.color ?? 'Không có'),
                    Divider(),
                    _buildDetailRow('ID người tạo', _note.idAccount.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
