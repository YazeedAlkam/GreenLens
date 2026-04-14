import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/SginIn.dart';
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
final List<String> Roles = ['Section Head', 'Engineer', 'Financial Manager'];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      home: SignInPage(), // start page
    );
  }
}