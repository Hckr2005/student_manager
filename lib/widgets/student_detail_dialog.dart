import 'dart:io';
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../l10n/app_localizations.dart';

class StudentDetailDialog extends StatelessWidget {
  final Student student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentDetailDialog({
    super.key,
    required this.student,
    required this.onEdit,
    required this.onDelete,
  });

  // Xử lý hiển thị ảnh linh hoạt (Link mạng hoặc File nội bộ máy)
  static Widget buildAvatar(String path, {double radius = 45}) {
    if (path.isEmpty) {
      return CircleAvatar(radius: radius, child: Icon(Icons.person, size: radius));
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(path),
        onBackgroundImageError: (_, __) {},
      );
    } else {
      final file = File(path);
      if (file.existsSync()) {
        return CircleAvatar(radius: radius, backgroundImage: FileImage(file));
      }
      return CircleAvatar(radius: radius, child: Icon(Icons.person, size: radius));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(loc.get('studentDetail'), textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildAvatar(student.avatar, radius: 50),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(loc.get('fullName')),
            subtitle: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ListTile(
            leading: const Icon(Icons.badge),
            title: Text(loc.get('studentCode')),
            subtitle: Text(student.studentCode, style: const TextStyle(fontSize: 15)),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(loc.get('email')),
            subtitle: Text(student.email, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context); // Đóng hộp thoại chi tiết
            onDelete(); // Kích hoạt xóa kèm thông báo xác nhận
          },
          icon: const Icon(Icons.delete, color: Colors.red),
          label: Text(loc.get('delete'), style: const TextStyle(color: Colors.red)),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.get('close')),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại chi tiết
                onEdit(); // Chuyển sang Trang 3 để sửa thông tin
              },
              icon: const Icon(Icons.edit),
              label: Text(loc.get('edit')),
            ),
          ],
        )
      ],
    );
  }
}