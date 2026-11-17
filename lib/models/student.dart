class Student {
  final int? id;
  final String name;
  final String studentCode;
  final String email;
  final String avatar; // Có thể là link URL hoặc đường dẫn file trên thiết bị

  Student({
    this.id,
    required this.name,
    required this.studentCode,
    required this.email,
    required this.avatar,
  });

  // Chuyển đối tượng Student thành dạng Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'studentCode': studentCode,
      'email': email,
      'avatar': avatar,
    };
  }

  // Đọc dữ liệu từ Map của SQLite chuyển ngược lại thành đối tượng Student
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      studentCode: map['studentCode'],
      email: map['email'],
      avatar: map['avatar'],
    );
  }
}