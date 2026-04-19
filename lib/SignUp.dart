import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/Just.dart';
import 'package:greenlens/SginIn.dart';
import 'package:greenlens/background.dart';
import 'package:greenlens/main.dart';

bool _obsecureText = true;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.nunito().fontFamily),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            BackgroundCurves(),
            Container(
              padding: const EdgeInsets.fromLTRB(190, 90, 190, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Create your account',
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
                      labelText: 'Full name',
                      labelStyle: TextStyle(color: textcolor),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(color: textcolor, width: 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    //this for email input
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: textcolor),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(color: textcolor),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: _obsecureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: textcolor),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(color: textcolor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obsecureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: textcolor.withOpacity(0.4),
                        ),
                        onPressed: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: _obsecureText,
                    decoration: InputDecoration(
                      labelText: 'Confirm your password',
                      labelStyle: TextStyle(color: textcolor),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(color: textcolor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obsecureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: textcolor.withOpacity(0.4),
                        ),
                        onPressed: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      width: 190,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Pick a Role',
                          labelStyle: GoogleFonts.nunito(
                            color: PrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),

                          // 👇 Default border
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: textcolor.withOpacity(0.4),
                            ),
                          ),

                          // 👇 When NOT focused
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: textcolor.withOpacity(0.4),
                            ),
                          ),

                          // 👇 When focused (clicked)
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: PrimaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        items: Roles.map(
                              (roles) => DropdownMenuItem<String>(
                            value: roles,
                            child: Text(roles),
                          ),
                        ).toList(),
                        onChanged: (value) {
                          // Handle role selection
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: SizedBox(
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
                          'SIGN UP',
                          style: TextStyle(color: Colors.white, fontSize: 36),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()),);
                        },
                        child: const Text(
                          ' Login',
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
          ],
        ),
      ),
    );
  }
}