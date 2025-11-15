import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ListView_Choice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _quotaCodeController = TextEditingController();
  final _idCardController = TextEditingController();
  String? _quotaErrorText;
  String? _idCardErrorText;

  @override
  void dispose() {
    _quotaCodeController.dispose();
    _idCardController.dispose();
    super.dispose();
  }

  void _login() {
    final isQuotaValid = _quotaCodeController.text.isNotEmpty;
    final isIdCardValid = _idCardController.text.isNotEmpty;

    setState(() {
      _quotaErrorText = isQuotaValid ? null : 'กรุณากรอกรหัสโควต้า';
      _idCardErrorText =
          isIdCardValid ? null : 'กรุณากรอกรหัสผ่าน';
    });

    if (isQuotaValid && isIdCardValid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListView_Choice()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFE13E53),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 30,
              right: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/images/logo-KI.png',
                    width: 150,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "ยินดีต้อนรับ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          "ระบบข้อมูลชาวไร่\nโรงงานน้ำตาลพิมาย",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFE13E53),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: _quotaCodeController,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                            labelText: 'รหัสโควต้า',
                            floatingLabelStyle:
                                const TextStyle(color: Color(0xFFE13E53)),
                            focusColor: const Color(0xFFE13E53),
                            counterText: "",
                            errorText: _quotaErrorText,
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.grey[50],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE13E53)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _idCardController,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่าน',
                            floatingLabelStyle:
                                const TextStyle(color: Color(0xFFE13E53)),
                            focusColor: const Color(0xFFE13E53),
                            errorText: _idCardErrorText,
                            counterText: "",
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.grey[50],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE13E53)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE13E53),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'เข้าสู่ระบบ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.facebook),
                            label: const Text(
                              'เข้าสู่ระบบด้วย Facebook',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              // TODO: Implement Facebook login logic
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, 
                              backgroundColor: const Color(0xFF1877F2), // Facebook Blue
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.email_outlined),
                            label: const Text(
                              'เข้าสู่ระบบด้วย Google',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              // TODO: Implement Google login logic
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black54,
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
