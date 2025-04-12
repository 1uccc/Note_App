import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../model/Note.dart';

class NoteForm extends StatefulWidget {
  final Note? note;
  final Function(Note note) onSave;

  const NoteForm({Key? key, this.note, required this.onSave}) : super(key: key);

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();

  Color _selectedColor = Colors.blue;
  int _priority = 1;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _priority = widget.note!.priority;
      _tags = List<String>.from(widget.note!.tags);
      _selectedColor = Color(int.tryParse(widget.note!.color ?? '') ?? Colors.blue.value);
    }
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn màu ghi chú'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text('Xong'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isNotEmpty && !_tags.contains(text)) {
      setState(() {
        _tags.add(text);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        priority: _priority,
        createAt: widget.note?.createAt ?? DateTime.now(),
        modifiedAt: DateTime.now(),
        tags: _tags,
        color: _selectedColor.value.toString(),
      );
      widget.onSave(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Cập nhật ghi chú' : 'Thêm ghi chú')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Nội dung'),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập nội dung' : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Độ ưu tiên'),
                items: [1, 2, 3].map((val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text('Mức $val'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _priority = value);
                },
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Màu ghi chú',
                        style: TextStyle(
                          color: ThemeData.estimateBrightnessForColor(_selectedColor) == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: _pickColor, child: Text('Chọn màu')),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagController,
                      decoration: InputDecoration(labelText: 'Thêm nhãn'),
                    ),
                  ),
                  IconButton(
                    onPressed: _addTag,
                    icon: Icon(Icons.add_circle, color: Colors.blue),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: Icon(Icons.cancel),
                    onDeleted: () => _removeTag(tag),
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(isEditing ? 'CẬP NHẬT' : 'THÊM MỚI'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
