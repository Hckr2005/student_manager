import 'package:flutter/material.dart';
import '../models/student.dart';
import '../database/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../widgets/student_detail_dialog.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  // Tải danh sách từ SQLite
  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllStudents();
    setState(() {
      _students = data;
      _isLoading = false;
    });
  }

  // Mở Trang 3 (Thêm mới hoặc Sửa)
  Future<void> _navigateToForm([Student? student]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentFormScreen(student: student),
      ),
    );
    if (result == true) {
      _loadStudents();
    }
  }

  // Xóa sinh viên với hộp thoại xác nhận
  Future<void> _confirmAndDelete(Student student) async {
    final loc = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.get('confirmTitle')),
        content: Text(loc.get('confirmDeleteMsg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.get('no')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.get('yes')),
          ),
        ],
      ),
    );

    if (confirm == true && student.id != null) {
      await DatabaseHelper.instance.deleteStudent(student.id!);
      _loadStudents();
    }
  }

  // Mở Trang 2 (Dialog chi tiết) khi click vào một sinh viên
  void _showDetailDialog(Student student) {
    showDialog(
      context: context,
      builder: (_) => StudentDetailDialog(
        student: student,
        onEdit: () => _navigateToForm(student),
        onDelete: () => _confirmAndDelete(student),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.get('studentList')),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _students.isEmpty
              ? Center(child: Text(loc.get('emptyList'), style: const TextStyle(fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    final sv = _students[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: ListTile(
                        leading: StudentDetailDialog.buildAvatar(sv.avatar, radius: 26),
                        title: Text(sv.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${sv.studentCode} • ${sv.email}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') _navigateToForm(sv);
                            if (value == 'delete') _confirmAndDelete(sv);
                          },
                          itemBuilder: (ctx) => [
                            PopupMenuItem(value: 'edit', child: Text(loc.get('edit'))),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(loc.get('delete'), style: const TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                        onTap: () => _showDetailDialog(sv), // Mở Trang 2
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(), // Mở Trang 3 (Thêm mới)
        child: const Icon(Icons.add),
      ),
    );
  }
}