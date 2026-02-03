import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../repositories/cane_repository.dart';
import '../services/auth_storage_service.dart';
import 'ListView_Choice.dart';
import 'ResetPasswordPage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  final bool sessionExpired;
  const LoginPage({super.key, this.sessionExpired = false});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _quotaCodeController = TextEditingController();
  final _idCardController = TextEditingController();
  String? _quotaErrorText;
  String? _idCardErrorText;
  bool _isObscure = true;
  bool _isRememberMe = false;
  bool _isLoading = false;
  final AuthStorageService _storageService = AuthStorageService();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _loadSavedData();
    if (widget.sessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSessionExpiredSnackBar();
      });
    }
  }

  void _showSessionExpiredSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE13E53),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE13E53).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.history_toggle_off_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'หมดเวลาการเชื่อมต่อ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'กรุณาเข้าสู่ระบบใหม่อีกครั้ง',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.02,
          left: 20,
          right: 20,
        ),
      ),
    );
  }
  @override
  void dispose() {
    _quotaCodeController.dispose();
    _idCardController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final data = await _storageService.getCredentials();
    if (data['isRemember'].toString() == 'true') {
      setState(() {
        _quotaCodeController.text = data['quota'] ?? '';
        _idCardController.text = data['password'] ?? '';
        _isRememberMe = true;
      });
    }
  }

  Future<void> _handleLoginButtonPress() async {
    FocusScope.of(context).unfocus();
    final isQuotaValid = _quotaCodeController.text.isNotEmpty;
    final isIdCardValid = _idCardController.text.isNotEmpty;
    setState(() {
      _quotaErrorText = isQuotaValid ? null : 'กรุณากรอกรหัสโควต้า';
      _idCardErrorText = isIdCardValid ? null : 'กรุณากรอกรหัสผ่าน';
    });
    if (!isQuotaValid || !isIdCardValid) return;
    _performLogin();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_rounded, size: 40, color: Color(0xFFE13E53)),
              const SizedBox(height: 20),
              const Text("แจ้งเตือน", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE13E53)),
                  child: const Text("ตกลง", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performLogin() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final String code = _quotaCodeController.text.trim();
      final String id = _idCardController.text.trim();
      Map<String, String> dataMap = {"uxxname": code, "pxxword": id};
      String plainText = jsonEncode(dataMap);
      final key = encrypt.Key.fromUtf8('MySecret1234ABCD');
      final iv = encrypt.IV.fromUtf8('Salt123456789012');
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      String encryptedResult = encrypted.base64;

      AuthService authService = AuthService();
      var response = await authService.loginWithEncryptedData(encryptedResult);

      bool isSuccess = false;
      if (response != null && response is Map) {
        if (response['success'].toString() == 'true') isSuccess = true;
      }

      if (!mounted) return;

      if (isSuccess) {
        setState(() => _isLoading = false);
        final bool? isAccepted = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const ConsentModalWidget(),
        );

        if (isAccepted == true && mounted) {
          await _storageService.saveCredentials(code, id, _isRememberMe);
          await _storageService.updateLastActive();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ListView_Choice(username: code)),
          );
        }
      } else {
        _showErrorDialog("รหัสโควต้าหรือรหัสผ่านไม่ถูกต้อง");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog("เกิดข้อผิดพลาดในการเชื่อมต่อ");
        setState(() => _isLoading = false);
      }
    }
  }

  static const platform = MethodChannel('com.kisugar.app/launcher');
  Future<void> _launchFacebook() async {
    final Uri url = Uri.parse('https://www.facebook.com/kisugargroup');

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถเปิด Facebook ได้ในขณะนี้')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    height: 320,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFFE13E53), Color(0xFFFF6B6B)]),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/images/logo-KI.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text("KI SUGAR", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    const Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE13E53))),
                    const SizedBox(height: 30),
                    _buildTextField(controller: _quotaCodeController, label: 'รหัสโควต้า', icon: Icons.person_outline, maxLength: 6),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _idCardController,
                      label: 'รหัสผ่าน',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: _isObscure,
                      onToggleVisibility: () => setState(() => _isObscure = !_isObscure),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isRememberMe,
                              onChanged: (v) => setState(() => _isRememberMe = v ?? false),
                              activeColor: const Color(0xFFE13E53),
                            ),
                            const Text("จดจำรหัสผ่าน"),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Resetpasswordpage()),
                              );
                        },
                            child: const Text("ลืมรหัสผ่าน?", style: TextStyle(color: Colors.grey))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLoginButtonPress,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE13E53), shape: const StadiumBorder()),
                        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildSocialButton(icon: Icons.facebook, color: const Color(0xFF1877F2), onTap: _launchFacebook),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    int? maxLength,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: TextInputType.number,
        maxLength: maxLength,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: const Color(0xFFE13E53)),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: onToggleVisibility,
          )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
          errorText: errorText,
          counterText: "",
        ),
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required Color color, required VoidCallback onTap, bool isGoogle = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Center(
          child: isGoogle
              ? const Icon(Icons.email, size: 30, color: Colors.red)
              : Icon(icon, size: 30, color: color),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ConsentModalWidget extends StatelessWidget {
  const ConsentModalWidget({Key? key}) : super(key: key);

  void _showRefusalWarning(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.report_problem_rounded,
                  color: Color(0xFFE13E53),
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'สิทธิ์การเข้าถึงข้อมูล',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'หากท่านไม่กดยอมรับเงื่อนไข ท่านจะไม่สามารถเข้าใช้งานแอปพลิเคชันได้ เนื่องจากข้อมูลจำเป็นต่อการคำนวณรายได้และประวัติการส่งอ้อยของท่าน',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE13E53),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'รับทราบและดำเนินการต่อ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'เงื่อนไขการเปิดเผยข้อมูล',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE13E53)),
            ),
          ),
          const Divider(height: 1),
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: CategorizedConsentList(),
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showRefusalWarning(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('ปฏิเสธ', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFFE13E53),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('ยอมรับและดำเนินการต่อ',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategorizedConsentList extends StatelessWidget {
  const CategorizedConsentList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เพื่อให้ท่านได้รับรายงานรายได้และประวัติการขนส่งอ้อยที่ถูกต้อง ทางเราขออนุญาตเข้าถึงข้อมูลโปรไฟล์เพื่อใช้ในการยืนยันตัวตนและแสดงผลข้อมูลของท่าน :',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        SizedBox(height: 16),
        ConsentGroupCard(
          title: 'ข้อมูลยืนยันตัวตน',
          icon: Icons.badge_outlined,
          color: Colors.blue,
          items: [
            'ชื่อ-นามสกุล และรหัสชาวไร่',
            'ข้อมูลการติดต่อ',
          ],
        ),
        ConsentGroupCard(
          title: 'ข้อมูลแปลงเกษตร',
          icon: Icons.landscape_outlined,
          color: Colors.green,
          items: [
            'รายการแปลงอ้อยทั้งหมด',
            'พิกัดและขนาดพื้นที่ปลูก',
            'ประวัติการบำรุงรักษา',
          ],
        ),
        ConsentGroupCard(
          title: 'การจัดส่งและคิวรถ',
          icon: Icons.local_shipping_outlined,
          color: Colors.orange,
          items: [
            'หมายเลขคิวอ้อย (Queue No.)',
            'ทะเบียนรถและสถานะการจัดส่ง',
            'เวลาเข้า-ออกโรงงาน',
          ],
        ),
        ConsentGroupCard(
          title: 'คุณภาพผลผลิต',
          icon: Icons.science_outlined,
          color: Colors.purple,
          items: [
            'ค่าความหวาน (C.C.S.)',
            'น้ำหนักสุทธิและสิ่งเจือปน',
            'สรุปรายได้ต่อตัน',
          ],
        ),
      ],
    );
  }
}

class ConsentGroupCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  const ConsentGroupCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: color.withOpacity(0.5), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(item, style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}