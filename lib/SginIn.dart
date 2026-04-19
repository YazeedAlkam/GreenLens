import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/SignUp.dart';
import 'background.dart';
import 'main.dart';

bool _obsecureTextSignIn = true;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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

                TextField(
                  //this for name input
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: textcolor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: textcolor),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                TextField(
                  obscureText: _obsecureTextSignIn,
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obsecureTextSignIn
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: textcolor.withOpacity(0.4),
                      ),
                      onPressed: () {
                        setState(() {
                          _obsecureTextSignIn = !_obsecureTextSignIn;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: PrimaryColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SignupButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
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
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: const Text(
                        ' Sign Up',
                        style: TextStyle(
                          color: LoginButtonColorInSignUpPage,
                          fontSize: 26,
                          fontWeight: FontWeight.normal,
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
