import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/student.dart';
import '../database/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../widgets/student_detail_dialog.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student; // Nếu null là Thêm mới, có dữ liệu là Sửa

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _emailController;
  late TextEditingController _avatarController;

  bool get isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _codeController = TextEditingController(text: widget.student?.studentCode ?? '');
    _emailController = TextEditingController(text: widget.student?.email ?? '');
    _avatarController = TextEditingController(text: widget.student?.avatar ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  // Chọn ảnh trực tiếp từ bộ nhớ thiết bị
  Future<void> _pickImageFromDevice() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarController.text = pickedFile.path;
      });
    }
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;
    final loc = AppLocalizations.of(context);

    final studentData = Student(
      id: widget.student?.id,
      name: _nameController.text.trim(),
      studentCode: _codeController.text.trim(),
      email: _emailController.text.trim(),
      avatar: _avatarController.text.trim(),
    );

    if (isEditing) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(loc.get('confirmTitle')),
          content: Text(loc.get('confirmEditMsg')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(loc.get('no'))),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(loc.get('yes'))),
          ],
        ),
      );

      if (confirm != true) return;
      await DatabaseHelper.instance.updateStudent(studentData);
    } else {
      // Thêm mới vào SQLite
      await DatabaseHelper.instance.insertStudent(studentData);
    }

    // BẮT BUỘC PHẢI CÓ DÒNG NÀY ĐỂ QUAY VỀ TRANG 1 VÀ TẢI LẠI DANH SÁCH
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? loc.get('editStudent') : loc.get('addStudent')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              StudentDetailDialog.buildAvatar(_avatarController.text, radius: 55),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickImageFromDevice,
                icon: const Icon(Icons.photo_library),
                label: Text(loc.get('pickImage')),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _avatarController,
                decoration: InputDecoration(
                  labelText: loc.get('avatarUrl'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.link),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: loc.get('fullName'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? loc.get('requiredField') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: loc.get('studentCode'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.badge),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? loc.get('requiredField') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: loc.get('email'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? loc.get('requiredField') : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _saveStudent,
                  icon: const Icon(Icons.save),
                  label: Text(loc.get('save'), style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}