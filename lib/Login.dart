import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ListView_Choice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _quotaCodeController = TextEditingController();
  final _idCardController = TextEditingController();
  String? _quotaErrorText;
  String? _idCardErrorText;
  bool _isObscure = true; // สำหรับซ่อน/แสดงรหัสผ่าน

  // Animation Controller
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward(); // เริ่มเล่น Animation
  }

  @override
  void dispose() {
    _quotaCodeController.dispose();
    _idCardController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _login() {
    final isQuotaValid = _quotaCodeController.text.isNotEmpty;
    final isIdCardValid = _idCardController.text.isNotEmpty;

    setState(() {
      _quotaErrorText = isQuotaValid ? null : 'กรุณากรอกรหัสโควต้า';
      _idCardErrorText = isIdCardValid ? null : 'กรุณากรอกรหัสผ่าน';
    });

    if (isQuotaValid && isIdCardValid) {
      // Simulate loading or transition
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ListView_Choice()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. Header (Curve Background + Logo) ---
            Stack(
              alignment: Alignment.center,
              children: [
                ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    height: 320,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE13E53), Color(0xFFFF6B6B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset('assets/images/logo-KI.png', width: 120, height: 120, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text("KI SUGAR", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        const Text("Smart Farmer System", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- 2. Login Form ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    const Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE13E53)),
                    ),
                    const SizedBox(height: 30),

                    // รหัสโควต้า
                    _buildTextField(
                      controller: _quotaCodeController,
                      label: 'รหัสโควต้า',
                      icon: Icons.person_outline,
                      errorText: _quotaErrorText,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 20),

                    // รหัสผ่าน (ซ่อนได้)
                    _buildTextField(
                      controller: _idCardController,
                      label: 'รหัสผ่าน',
                      icon: Icons.lock_outline,
                      errorText: _idCardErrorText,
                      isPassword: true,
                      obscureText: _isObscure,
                      onToggleVisibility: () => setState(() => _isObscure = !_isObscure),
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {}, // TODO: Forgot Password
                        child: const Text("ลืมรหัสผ่าน?", style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ปุ่มเข้าสู่ระบบ
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE13E53),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                          shadowColor: const Color(0xFFE13E53).withOpacity(0.4),
                        ),
                        child: const Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Social Login Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("หรือเข้าสู่ระบบด้วย", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Social Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                            icon: Icons.facebook,
                            color: const Color(0xFF1877F2),
                            onTap: () {}
                        ),
                        const SizedBox(width: 20),
                        _buildSocialButton(
                            icon: Icons.g_mobiledata, // หรือใช้ Image.asset สำหรับ Logo Google
                            color: Colors.red,
                            isGoogle: true,
                            onTap: () {}
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget: Text Field Custom ---
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
          counterText: "", // ซ่อนตัวนับจำนวน
        ),
      ),
    );
  }

  // --- Widget: Social Button (Circle) ---
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
              ? const Icon(Icons.email, size: 30, color: Colors.red) // เปลี่ยนเป็น Image.asset ได้ถ้ามีรูป Logo Google
              : Icon(icon, size: 30, color: color),
        ),
      ),
    );
  }
}

// --- Custom Clipper for Curve Header ---
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