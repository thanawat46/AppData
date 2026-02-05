import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'pages/Login.dart';
import 'pages/ListView_Choice.dart';
import 'services/auth_storage_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthStorageService _storageService = AuthStorageService();
  Widget? _nextScreen;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _determineNextScreen();
  }

  Future<void> _determineNextScreen() async {
    final data = await _storageService.getCredentials();
    final lastActive = await _storageService.getLastActive();

    print("DEBUG: isRemember = ${data['isRemember']}");
    print("DEBUG: userData exists = ${data['userData'] != null}");

    if (mounted) {
      setState(() {
        bool isSessionValid = false;

        if (lastActive != null) {
          final now = DateTime.now();
          final difference = now.difference(lastActive).inHours;
          if (difference < 48) {
            isSessionValid = true;
            _storageService.updateLastActive();
          } else {
            _isExpired = true;
          }
        }

        if (data['isRemember'] == 'true' &&
            data['quota'] != null &&
            isSessionValid) {
          _nextScreen = ListView_Choice(username: data['quota']!, dataUser: data['userData']);
        } else {
          _nextScreen = LoginPage(sessionExpired: _isExpired);

          if (lastActive != null && !isSessionValid) {
            _storageService.saveCredentials('', '', false);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppData',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE13E53),
          surface: const Color(0xFFF5F7FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Sarabun',
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
              minScaleFactor: 1.0,
              maxScaleFactor: 1.1,
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child!,
          ),
        );
      },
      home: _nextScreen == null
          ? Scaffold(backgroundColor: Colors.white, body: _buildSplashUI())
          : AnimatedSplashScreen(
        splashIconSize: 2000,
        splash: _buildSplashUI(),
        nextScreen: _nextScreen!,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.white,
        duration: 3000,
      ),
    );
  }

  Widget _buildSplashUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Image.asset('assets/images/logo_into.png', width: 350),
        ),
        const SizedBox(height: 30),
        const Text(
          'ยินดีต้อนรับเข้าสู่',
          style: TextStyle(fontSize: 16, color: Colors.grey, letterSpacing: 1.2),
        ),
        const SizedBox(height: 10),
        const Text(
          'KI SUGAR',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE13E53),
            fontFamily: 'Sarabun',
          ),
        ),
        const SizedBox(height: 40),
        const SizedBox(
          width: 50,
          height: 50,
          child: SpinKitThreeBounce(color: Colors.redAccent, size: 30.0),
        )
      ],
    );
  }
}