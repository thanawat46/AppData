import 'package:flutter/material.dart';

class Resetpasswordpage extends StatefulWidget {
  const Resetpasswordpage({super.key});

  @override
  State<Resetpasswordpage> createState() => _ResetpasswordpageState();
}

class _ResetpasswordpageState extends State<Resetpasswordpage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Theme Colors
  final Color primaryRed = const Color(0xFFE13E53);
  final Color secondaryRed = const Color(0xFFFF6B6B);
  final Color softBg = const Color(0xFFF5F7FA);

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          "เปลี่ยนรหัสผ่าน",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryRed, secondaryRed],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "สร้างรหัสผ่านใหม่",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "กรุณากรอกรหัสผ่านปัจจุบันและรหัสผ่านใหม่\nเพื่อความปลอดภัยของบัญชี",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 30),

                    _buildModernPasswordField(
                      controller: _oldPasswordController,
                      label: "รหัสผ่านเดิม",
                      hint: "กรอกรหัสผ่านปัจจุบัน",
                      isVisible: _isOldPasswordVisible,
                      onToggle: () => setState(() => _isOldPasswordVisible = !_isOldPasswordVisible),
                      validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกรหัสผ่านเดิม' : null,
                    ),

                    const SizedBox(height: 20),

                    _buildModernPasswordField(
                      controller: _newPasswordController,
                      label: "รหัสผ่านใหม่",
                      hint: "ตั้งรหัสผ่านใหม่อย่างน้อย 6 ตัว",
                      isVisible: _isNewPasswordVisible,
                      onToggle: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'กรุณากรอกรหัสผ่านใหม่';
                        if (value.length < 6) return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildModernPasswordField(
                      controller: _confirmPasswordController,
                      label: "ยืนยันรหัสผ่านใหม่",
                      hint: "กรอกรหัสผ่านใหม่อีกครั้ง",
                      isVisible: _isConfirmPasswordVisible,
                      onToggle: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'กรุณายืนยันรหัสผ่านใหม่';
                        if (value != _newPasswordController.text) return 'รหัสผ่านไม่ตรงกัน';
                        return null;
                      },
                    ),

                    const SizedBox(height: 40),

                    // --- 3. ปุ่มบันทึก (Gradient Button) ---
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryRed, secondaryRed],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: primaryRed.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // TODO: Add logic here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('เปลี่ยนรหัสผ่านเรียบร้อยแล้ว'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text(
                          'บันทึกรหัสผ่าน',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
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

  // Widget สร้างช่องกรอกรหัสผ่านแบบ Modern
  Widget _buildModernPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            validator: validator,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(Icons.lock_outline_rounded, color: primaryRed.withOpacity(0.7)),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: Colors.grey[400],
                ),
                onPressed: onToggle,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}