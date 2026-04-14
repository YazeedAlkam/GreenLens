import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/SginIn.dart';
import 'background.dart';
/*
everytime you want to add changes to git hub we use this : 
git add .
git commit -m "describe your change"
git push
*/

const Color textcolor = Color(0xFFA8A6A7);
const Color PrimaryColor = Color(0xFF1A237E);
const Color secondaryColor = Color(0xFFA8A6A7);
const Color backgroundColor = Color(0xFFFFFCED);
const Color SignupButtonColor = Color(0xFF222222);
const Color LoginButtonColorInSignUpPage = Color(0xFFD87234);
bool _obsecureText = true;
final List<String> Roles = ['Section Head', 'Engineer', 'Financial Manager'];

void main() => runApp(const SignInPage());

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            BackgroundCurves(),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Create your account',
                    style: TextStyle(fontSize: 16, color: textcolor),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
                    child: TextField(
                      //this for name input
                      decoration: InputDecoration(
                        labelText: 'Full name',
                        labelStyle: TextStyle(color: textcolor),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(color: textcolor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
                    child: TextField(
                      //this for email input
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: textcolor),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(color: textcolor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
                    child: TextField(
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
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
                    child: TextField(
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
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(95, 0, 90, 0),
                    child: Align(
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
                  ),

                  SizedBox(height: 10),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SignupButtonColor,
                        padding: const EdgeInsets.only(
                          left: 132,
                          right: 140,
                          top: 15,
                          bottom: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        '   SIGN UP',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          // Navigate to login page
                        },
                        child: const Text(
                          ' Login',
                          style: TextStyle(color: LoginButtonColorInSignUpPage),
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
