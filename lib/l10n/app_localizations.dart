import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Student Manager',
      'studentList': 'Student List',
      'emptyList': 'No students found. Tap + to add.',
      'studentDetail': 'Student Details',
      'addStudent': 'Add New Student',
      'editStudent': 'Edit Student',
      'fullName': 'Full Name',
      'studentCode': 'Student ID',
      'email': 'Email',
      'avatarUrl': 'Avatar URL (or pick from device)',
      'pickImage': 'Pick from Gallery',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'close': 'Close',
      'confirmTitle': 'Confirmation',
      'confirmEditMsg': 'Do you want to update this student\'s information?',
      'confirmDeleteMsg': 'Do you want to delete this student?',
      'yes': 'Yes',
      'no': 'No',
      'requiredField': 'This field cannot be empty',
    },
    'vi': {
      'appTitle': 'Quản lý Sinh viên',
      'studentList': 'Danh sách Sinh viên',
      'emptyList': 'Chưa có sinh viên nào. Bấm + để thêm.',
      'studentDetail': 'Thông tin chi tiết Sinh viên',
      'addStudent': 'Thêm Sinh viên mới',
      'editStudent': 'Sửa thông tin Sinh viên',
      'fullName': 'Họ tên Sinh viên',
      'studentCode': 'Mã số Sinh viên',
      'email': 'Email',
      'avatarUrl': 'Link ảnh Avatar (hoặc chọn từ máy)',
      'pickImage': 'Chọn ảnh từ thiết bị',
      'save': 'Lưu thông tin',
      'edit': 'Sửa',
      'delete': 'Xóa',
      'close': 'Đóng',
      'confirmTitle': 'Xác nhận',
      'confirmEditMsg': 'Bạn có muốn sửa thông tin SV không?',
      'confirmDeleteMsg': 'Bạn có muốn xóa thông tin SV không?',
      'yes': 'Có',
      'no': 'Không',
      'requiredField': 'Vui lòng nhập thông tin này',
    },
  };

  String get(String key) {
    String langCode = locale.languageCode;
    if (!_localizedValues.containsKey(langCode)) {
      langCode = 'en';
    }
    return _localizedValues[langCode]![key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}