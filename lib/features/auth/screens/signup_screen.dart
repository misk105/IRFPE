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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // جديد

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false; // جديد
  bool _isAgreed = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm); // جديد
  }

  void _validateForm() {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    setState(() {
      _isFormValid = _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          emailRegExp.hasMatch(_emailController.text) &&
          _passwordController.text.length >= 8 &&
          _passwordController.text == _confirmPasswordController.text && // شرط التطابق
          _isAgreed;
    });
  }

  // دالة لإظهار نافذة الشروط
  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Terms and Conditions"),
        content: const SingleChildScrollView(
          child: Text(
            "Welcome to RoboLearn! By using this app, you agree to: \n\n"
            "1. Keep your account details secure.\n"
            "2. Not use the app for any illegal activities.\n"
            "3. Respect the intellectual property of our content.\n\n"
            "We value your privacy and protect your data according to our policy.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Sign Up", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB8E4F9), Color(0xFFCBF0D8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: buildField("First Name", Icons.person, _firstNameController)),
                    const SizedBox(width: 12),
                    Expanded(child: buildField("Last Name", Icons.person, _lastNameController)),
                  ],
                ),
                const SizedBox(height: 16),
                buildField("Email", Icons.email, _emailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),

                // حقل كلمة السر الأول
                buildPasswordField("Password", _passwordController, _isPasswordVisible, () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                }),
                
                const SizedBox(height: 16),

                // حقل تأكيد كلمة السر
                buildPasswordField("Confirm Password", _confirmPasswordController, _isConfirmVisible, () {
                  setState(() => _isConfirmVisible = !_isConfirmVisible);
                }),
                
                const SizedBox(height: 20),

                // خانة الموافقة على الشروط مع رابط قابل للنقر
                Row(
                  children: [
                    Checkbox(
                      value: _isAgreed,
                      onChanged: (value) {
                        setState(() => _isAgreed = value!);
                        _validateForm();
                      },
                      activeColor: Colors.blue,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showTermsDialog, // فتح النافذة عند النقر
                        child: RichText(
                          text: const TextSpan(
                            text: "I agree to the ",
                            style: TextStyle(color: Colors.black54, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Terms and Conditions",
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: _isFormValid 
                        ? const LinearGradient(colors: [Color(0xFF43E97B), Color(0xFF38F9D7)])
                        : LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade400]),
                    ),
                    child: ElevatedButton(
                      onPressed: _isFormValid ? () {
                        print("Success!");
                      } : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text("Create Account", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Already have an account? Login", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت لحقول النصوص العادية
  Widget buildField(String hint, IconData icon, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  // ويدجت لحقول كلمة السر (لتقليل التكرار)
  Widget buildPasswordField(String hint, TextEditingController controller, bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.blueGrey),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}
