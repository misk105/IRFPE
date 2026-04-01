import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController(); // جديد لعدد الأطفال
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  bool _isAgreed = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _childrenController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    setState(() {
      _isFormValid = _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          emailRegExp.hasMatch(_emailController.text) &&
          _childrenController.text.isNotEmpty && // شرط إدخال عدد الأطفال
          _passwordController.text.length >= 8 &&
          _passwordController.text == _confirmPasswordController.text &&
          _isAgreed;
    });
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("🤖 RoboLearn Terms"),
        content: const Text("Welcome! We ensure a safe learning environment for your children..."),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Got it!"))],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _childrenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black87)),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB8E4F9), Color(0xFFCBF0D8)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // توسيط العناصر أفقياً
              children: [
                const SizedBox(height: 10),
                // أيقونة الروبوت والترحيب بشكل مرح
                const Icon(Icons.smart_toy_rounded, size: 80, color: Colors.blueAccent),
                const Text("Join RoboLearn! ", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                const Text("Learning as playing! ", style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
                const SizedBox(height: 30),

                // حقول الاسم
                Row(
                  children: [
                    Expanded(child: buildField("First Name", Icons.person_outline, _firstNameController)),
                    const SizedBox(width: 12),
                    Expanded(child: buildField("Last Name", Icons.person_outline, _lastNameController)),
                  ],
                ),
                const SizedBox(height: 16),

                // حقل الإيميل
                buildField("Parent's Email", Icons.mail_outline, _emailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),

                // حقل عدد الأطفال (جديد)
                buildField("Number of Children", Icons.child_care_rounded, _childrenController, keyboardType: TextInputType.number),
                const SizedBox(height: 16),

                // حقول كلمة السر
                buildPasswordField("Password", _passwordController, _isPasswordVisible, () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                }),
                const SizedBox(height: 16),
                buildPasswordField("Confirm Password", _confirmPasswordController, _isConfirmVisible, () {
                  setState(() => _isConfirmVisible = !_isConfirmVisible);
                }),
                
                const SizedBox(height: 20),

                // الموافقة على الشروط
                Row(
                  children: [
                    Checkbox(
                      value: _isAgreed,
                      onChanged: (value) { setState(() => _isAgreed = value!); _validateForm(); },
                      activeColor: Colors.blue,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showTermsDialog,
                        child: RichText(
                          text: const TextSpan(
                            text: "I agree to the ",
                            style: TextStyle(color: Colors.black54, fontSize: 14),
                            children: [TextSpan(text: "Terms and Conditions", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // زر التسجيل
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: _isFormValid 
                        ? const LinearGradient(colors: [Color(0xFF43E97B), Color(0xFF38F9D7)])
                        : LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade400]),
                      boxShadow: _isFormValid ? [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))] : [],
                    ),
                    child: ElevatedButton(
                      onPressed: _isFormValid ? () => print("Success!") : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16), backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                      ),
                      child: const Text("Start Adventure! 🚀", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Back to Login", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String hint, IconData icon, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget buildPasswordField(String hint, TextEditingController controller, bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueGrey),
        suffixIcon: IconButton(icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off), onPressed: toggleVisibility),
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}
