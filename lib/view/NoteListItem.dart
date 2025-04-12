import 'package:flutter/material.dart';
import '../model/Note.dart';
import '../view/NoteDetailScreen.dart';
import 'package:intl/intl.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final VoidCallback onDeleted;
  final VoidCallback onEdit;

  const NoteListItem({
    Key? key,
    required this.note,
    required this.onDeleted,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToNoteDetailScreen(context),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        color: _getPriorityColor(note.priority),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              //Noi dung
              SizedBox(height: 8),
              Text(
                note.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Thoi gian tao / cap nhat
              SizedBox(height: 8),
              Text(
                'Cập nhật: ${_formatDate(note.modifiedAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              // Hien thi nhan tags
              if (note.tags != null && note.tags!.isNotEmpty) ...[
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: note.tags!
                      .map((tag) => Chip(
                    label: Text(tag),
                    labelStyle: TextStyle(fontSize: 12),
                    padding: EdgeInsets.zero,
                  ))
                      .toList(),
                ),
              ],
              SizedBox(height: 1),
              _buildTrailingActions(context),
            ],
          ),
        ),
      ),
    );
  }

  // Ham ding dang thoi gian
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  // Ham lay mau theo muc uu tien
  Color _getPriorityColor(int? priority) {
    switch (priority) {
      case 1:
        return Colors.red[200]!; // Cao
      case 2:
        return Colors.yellow[200]!; // Trung bình
      case 3:
        return Colors.green[200]!; // Thấp
      default:
        return Colors.white; // Mặc định
    }
  }
  // Hien thi icon edit va xoa
  Widget _buildTrailingActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.edit, color: Colors.green),
          onPressed: onEdit,
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteConfirmationDialog(context),
        ),
      ],
    );
  }
  // Canh bao xac nhan xoa
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa ghi chú này?'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Xóa'),
            onPressed: () {
              onDeleted();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
  // Ham chuyen tiep sang NoteDetailScreen
  void _navigateToNoteDetailScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(note: note),
      ),
    );
  }
}