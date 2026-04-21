import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/authentication/sign_in.dart';
import 'package:greenlens/shared_files/background.dart';
import 'package:greenlens/main.dart';

import '../firebase/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Controllers
  final _nameController            = TextEditingController();
  final _emailController           = TextEditingController();
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  bool _obscureText    = true;
  bool _isLoading      = false;
  String? _errorMessage;
  String? _selectedRole;

  final _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // ── Validation ─────────────────────────────────────────────
    if (_nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter your full name.');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }
    if (_selectedRole == null) {
      setState(() => _errorMessage = 'Please select a role.');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
        _selectedRole!,
      );
      // TODO: save _nameController.text & _selectedRole to Firestore here
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignInPage()),
      );
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.nunito().fontFamily),
      debugShowCheckedModeBanner: false,
      home: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(190, 110, 190, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sign Up',
                      style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
                  SizedBox(height: 32),
                  Text('Create your account',
                      style: TextStyle(fontSize: 26, color: textcolor, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),

                  // ── Full Name ──────────────────────────────────
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full name',
                      labelStyle: TextStyle(color: textcolor, fontSize: 26, fontWeight: FontWeight.bold),
                      border: UnderlineInputBorder(borderSide: BorderSide(color: textcolor)),
                    ),
                  ),
                  SizedBox(height: 20),

                  // ── Email ──────────────────────────────────────
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: textcolor, fontSize: 26, fontWeight: FontWeight.bold),
                      border: UnderlineInputBorder(borderSide: BorderSide(color: textcolor)),
                    ),
                  ),
                  SizedBox(height: 20),

                  // ── Password ───────────────────────────────────
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: textcolor, fontSize: 26, fontWeight: FontWeight.bold),
                      border: UnderlineInputBorder(borderSide: BorderSide(color: textcolor)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                            color: textcolor.withValues(alpha: 0.4)),
                        onPressed: () => setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // ── Confirm Password ───────────────────────────
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Confirm your password',
                      labelStyle: TextStyle(color: textcolor, fontSize: 26, fontWeight: FontWeight.bold),
                      border: UnderlineInputBorder(borderSide: BorderSide(color: textcolor)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                            color: textcolor.withValues(alpha: 0.4)),
                        onPressed: () => setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  // ── Role Dropdown ──────────────────────────────
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      width: 260,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedRole,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 21, vertical: 23),
                          labelText: 'Pick a Role',
                          labelStyle: GoogleFonts.nunito(
                              color: primaryColor, fontSize: 26, fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: textcolor.withValues(alpha: 0.4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                        ),
                        items: roles.map((role) =>
                            DropdownMenuItem<String>(value: role, child: Text(role))).toList(),
                        onChanged: (value) => setState(() => _selectedRole = value),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  // ── Error message ──────────────────────────────
                  if (_errorMessage != null) ...[
                    Text(_errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 20),
                        textAlign: TextAlign.center),
                    SizedBox(height: 12),
                  ],

                  // ── Sign Up Button ─────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 72,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp, // <-- calls _signUp
                      style: ElevatedButton.styleFrom(
                        backgroundColor: signupButtonColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('SIGN UP', style: TextStyle(color: Colors.white, fontSize: 36)),
                    ),
                  ),
                  SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                          style: TextStyle(color: Colors.black, fontSize: 26)),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => Navigator.push(
                            context, MaterialPageRoute(builder: (_) => SignInPage())),
                        child: const Text(' Login',
                            style: TextStyle(color: loginButtonColorInSignUpPage, fontSize: 26)),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}