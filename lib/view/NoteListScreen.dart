import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/NoteAPIService.dart';
import '../model/Note.dart';
import '../view/NoteListItem.dart';
import '../view/EditNoteScreen.dart';
import '../view/AddNoteScreen.dart';
import '../view/LoginScreen.dart';

class NoteListScreen extends StatefulWidget {
  final Function? onLogout;

  NoteListScreen({this.onLogout});

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  int? _selectedPriority = -1;
  bool _isGridView = false;
  String _searchText = '';
  bool _sortByPriority = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    List<Note> notes = await NoteAPIService.instance.getAllNotes();
    setState(() {
      _notes = notes;
      _filterAndSortNotes(); // Lọc và sắp xếp sau khi lấy ghi chú
    });
  }

  void _filterAndSortNotes() {
    _filteredNotes = List.from(_notes); // Copy danh sách gốc

    if (_selectedPriority != -1 && _selectedPriority != null) {
      _filteredNotes = _filteredNotes
          .where((note) => note.priority == _selectedPriority)
          .toList();
    }

    if (_searchText.isNotEmpty) {
      _filteredNotes = _filteredNotes
          .where((note) =>
      note.title.toLowerCase().contains(_searchText.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }

    if (_sortByPriority) {
      _filteredNotes.sort((a, b) => a.priority.compareTo(b.priority));
    } else {
      _filteredNotes.sort((a, b) => b.createAt.compareTo(a.createAt));
    }
  }

  void _toggleView() { // Đổi giữa danh sách - lưới
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _toggleSort() { // Đổi giữa ngày - ưu tiên
    setState(() {
      _sortByPriority = !_sortByPriority;
      _filterAndSortNotes();
    });
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Xác nhận đăng xuất'),
        content: Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Đóng hộp thoại
              await _handleLogout(); // Thực hiện logout và điều hướng
            },
            child: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách ghi chú'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(
                  notes: _notes,
                  onSearchTextChanged: (value) {
                    setState(() {
                      _searchText = value;
                      _filterAndSortNotes();
                    });
                  },
                ),
              );
            },
          ),
          PopupMenuButton<int>(
            onSelected: (value) {
              setState(() {
                _selectedPriority = value;
                _filterAndSortNotes();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: -1, child: Text('Tất cả')),
              const PopupMenuItem(value: 1, child: Text('Ưu tiên cao')),
              const PopupMenuItem(value: 2, child: Text('Ưu tiên trung bình')),
              const PopupMenuItem(value: 3, child: Text('Ưu tiên thấp')),
            ],
            icon: const Icon(Icons.filter_alt),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadNotes),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: _toggleView,
          ),
          IconButton(
            icon: Icon(_sortByPriority ? Icons.sort_by_alpha : Icons.calendar_today),
            onPressed: _toggleSort,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: _filteredNotes.isEmpty
          ? const Center(child: Text('Không có ghi chú nào'))
          : _isGridView
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) {
          final note = _filteredNotes[index];
          return NoteListItem(
            note: note,
            onDeleted: () async {
              await NoteAPIService.instance.deleteNote(note.id!);
              _loadNotes();
            },
            onEdit: () async {
              final updatedNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: note),
                ),
              );
              if (updatedNote == true) {
                _loadNotes();
              }
            },
          );
        },
      )
          : ListView.builder(
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) {
          final note = _filteredNotes[index];
          return NoteListItem(
            note: note,
            onDeleted: () async {
              await NoteAPIService.instance.deleteNote(note.id!);
              _loadNotes();
            },
            onEdit: () async {
              final updatedNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: note),
                ),
              );
              if (updatedNote == true) {
                _loadNotes();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddnoteScreen()),
          );
          if (created == true) {
            _loadNotes();
          }
        },
      ),
    );
  }
}

// Tìm kiếm
class NoteSearchDelegate extends SearchDelegate {
  final List<Note> notes;
  final ValueChanged<String> onSearchTextChanged;

  NoteSearchDelegate({required this.notes, required this.onSearchTextChanged});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearchTextChanged(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredNotes = notes
        .where((note) =>
    note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final note = filteredNotes[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.content),
          onTap: () {
            query = note.title;
            onSearchTextChanged(query);
            close(context, null);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestedNotes = notes
        .where((note) =>
    note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestedNotes.length,
      itemBuilder: (context, index) {
        final note = suggestedNotes[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.content),
          onTap: () {
            query = note.title;
            onSearchTextChanged(query);
            showResults(context);
          },
        );
      },
    );
  }
}
