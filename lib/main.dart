import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Page/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. ล็อกหน้าจอแนวตั้ง
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 2. ปรับ Status Bar ให้สวยงาม (โปร่งใส + ไอคอนเข้ม)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android
    statusBarBrightness: Brightness.light,    // iOS
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppData',

      // 3. ตั้งค่า Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE13E53), // สีแดงธีมหลัก
          background: const Color(0xFFF5F7FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Sarabun',
      ),

      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);

        // ป้องกันตัวหนังสือใหญ่จนแอปพัง (ล็อกไว้ไม่ให้เกิน 1.1 เท่า)
        final scale = mediaQueryData.textScaler.clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.1,
        );

        return MediaQuery(
          data: mediaQueryData.copyWith(textScaler: scale),
          child: GestureDetector(
            // แตะที่ว่างเพื่อปิดคีย์บอร์ด
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: child!,
          ),
        );
      },

      home: const LoginPage(),
    );
  }
}