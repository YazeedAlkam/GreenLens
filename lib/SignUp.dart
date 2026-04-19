import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/Just.dart';
import 'package:greenlens/SginIn.dart';
import 'package:greenlens/background.dart'; // <-- make sure AuthBackground is exported from here
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
      home: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(190, 110, 190, 0),
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
                    decoration: InputDecoration(
                      labelText: 'Full name',
                      labelStyle: TextStyle(
                        color: textcolor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(color: textcolor, width: 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: textcolor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(color: textcolor, width: 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: _obsecureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: textcolor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(color: textcolor, width: 1),
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
                      labelStyle: TextStyle(
                        color: textcolor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(color: textcolor, width: 1),
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
                  SizedBox(height: 32),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      width: 260,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          isDense: false,
                          contentPadding: EdgeInsets.symmetric(
                            // Add this
                            horizontal: 21,
                            vertical: 23,
                          ),
                          labelText: 'Pick a Role',
                          labelStyle: GoogleFonts.nunito(
                            color: PrimaryColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: textcolor.withOpacity(0.4),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: textcolor.withOpacity(0.4),
                            ),
                          ),
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
                        onChanged: (value) {},
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
                        'SIGN UP',
                        style: TextStyle(color: Colors.white, fontSize: 36),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          );
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
                  SizedBox(height: 40), // bottom breathing room
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
