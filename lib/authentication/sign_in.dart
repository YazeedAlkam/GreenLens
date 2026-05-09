import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../firebase/auth_service.dart';
import '../shared_files/background.dart';
import '../main.dart';
import 'user_model.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State
  bool _obscureText = true;
  bool _isLoading = false;
  String? _errorMessage;

  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (!mounted) return;
      final user = await UserModel.fetchCurrent();
      if (!mounted) return;
      switch (user?.role) {
        case 'Section Head':
          Navigator.pushReplacementNamed(context, "/section_head_dashboard");
        case 'Engineer':
          Navigator.pushReplacementNamed(context, "/engineer_dashboard");
        case 'Financial Manager':
          Navigator.pushReplacementNamed(
            context,
            "/financial_manager_dashboard",
          );
        case 'CEO':
          Navigator.pushReplacementNamed(context, "/ceo_dashboard");
      }
    } catch (e) {
      setState(
        () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
      );
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
          child: Container(
            padding: const EdgeInsets.fromLTRB(190, 110, 190, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Text(
                  "Enter your email and password",
                  style: TextStyle(
                    fontSize: 26,
                    color: textcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                // ── Email ──────────────────────────────────────────
                TextField(
                  controller: _emailController, // <-- added
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: textcolor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: textcolor, width: 2.0),
                    ),
                    hoverColor: Colors.transparent,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: textcolor),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // ── Password ───────────────────────────────────────
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: textcolor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: textcolor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: textcolor, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: textcolor.withValues(alpha: 0.4),
                      ),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: WidgetStateColor.transparent,
                    ),
                    onPressed: () {
                      // TODO: implement forgot password
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ── Error message ──────────────────────────────────
                if (_errorMessage != null) ...[
                  SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],

                SizedBox(height: 32),

                // ── Login button ───────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: signupButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          ) // <-- loading spinner
                        : Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white, fontSize: 36),
                          ),
                  ),
                ),

                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dont have an account?',
                      style: TextStyle(color: Colors.black, fontSize: 26),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        overlayColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => Navigator.pushNamed(context, "/sign_up"),
                      child: const Text(
                        ' Sign Up',
                        style: TextStyle(
                          color: loginButtonColorInSignUpPage,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
