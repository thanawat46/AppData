import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ListView_Choice.dart';
import 'ResetPasswordPage.dart';

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
  bool _isObscure = true;

  // Animation Controller
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _quotaCodeController.dispose();
    _idCardController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLoginButtonPress() async {
    FocusScope.of(context).unfocus();

    final isQuotaValid = _quotaCodeController.text.isNotEmpty;
    final isIdCardValid = _idCardController.text.isNotEmpty;

    setState(() {
      _quotaErrorText = isQuotaValid ? null : 'กรุณากรอกรหัสโควต้า';
      _idCardErrorText = isIdCardValid ? null : 'กรุณากรอกรหัสผ่าน';
    });

    if (!isQuotaValid || !isIdCardValid) {
      return;
    }

    final bool? isAccepted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => const ConsentModalWidget(),
    );

    if (isAccepted == true) {
      _performLogin();
    }
  }

  void _performLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListView_Choice()),
    );
  }

  static const platform = MethodChannel('com.kisugar.app/launcher');

  Future<void> _launchFacebook() async {
    try {
      await platform.invokeMethod('openUrl', {
        'url': 'https://www.facebook.com/kisugargroup'
      });
    } on PlatformException catch (e) {
      debugPrint("Error: '${e.message}'.");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header ---
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
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset('assets/images/logo-KI.png', width: 120, height: 120, fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(width: 120, height: 120, color: Colors.white, child: const Icon(Icons.image_not_supported)), // Fallback กรณีไม่มีรูป
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text("KI SUGAR", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        const Text("ยินดีต้อนรับ", style: TextStyle(color: Colors.white70, fontSize: 16)),
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
                    const Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE13E53)),
                    ),
                    const SizedBox(height: 30),

                    _buildTextField(
                      controller: _quotaCodeController,
                      label: 'รหัสโควต้า',
                      icon: Icons.person_outline,
                      errorText: _quotaErrorText,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 20),

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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Resetpasswordpage()),
                          );
                        },
                        child: const Text("ลืมรหัสผ่าน?", style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // --- Login Button ---
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _handleLoginButtonPress,
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
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("ติดตามข่าวสาร", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                            icon: Icons.facebook,
                            color: const Color(0xFF1877F2),
                            onTap: () async {
                              _launchFacebook();
                            }
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

  @override
  Widget build(BuildContext context) {
    // กำหนดความสูง Modal ที่ 85% ของหน้าจอ
    final double height = MediaQuery.of(context).size.height * 0.85;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'เงื่อนไขการเปิดเผยข้อมูล',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE13E53)),
            ),
          ),
          const Divider(height: 1),

          // Scrollable Content
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: CategorizedConsentList(),
            ),
          ),

          const Divider(height: 1),

          // Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
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
                        elevation: 0,
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
  const CategorizedConsentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'เพื่อให้ท่านได้รับรายงานรายได้และประวัติการขนส่งอ้อยที่ถูกต้อง \nทางเราขออนุญาตเข้าถึงข้อมูลโปรไฟล์เพื่อใช้ในการยืนยันตัวตนและแสดงผลข้อมูลของท่าน :',
          style: TextStyle(fontSize: 15, color: Colors.black54),
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Items List Section
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
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                        ),
                      ),
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