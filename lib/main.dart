import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // <--- IMPORT THƯ VIỆN FFI
import 'package:flutter/foundation.dart';
import 'l10n/app_localizations.dart';
import 'screens/student_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // KIỂM TRA NẾU CHẠY TRÊN DESKTOP THÌ KHỞI TẠO FFI CHO SQFLITE
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const StudentManagerApp());
}

class StudentManagerApp extends StatelessWidget {
  const StudentManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).get('appTitle'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      supportedLocales: const [
        Locale('en', ''),
        Locale('vi', ''),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const StudentListScreen(),
    );
  }
}