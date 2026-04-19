import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/SectionHeadDash.dart';
import 'package:greenlens/authentication/SginIn.dart';

import 'firebase/firebase_options.dart';

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
const Color DashsButtonColor = Color(0xFF393C5A);
const Color InProgressColor = Color(0xFF8A90CE);
const Color AwaitingApprovalColor = Color(0xFFEB9D4A);
const Color LoginButtonColorInSignUpPage = Color(0xFFD87234);
const Color DraftColor = Color(0xFFBFC0CD);
const Color DeniedColor = Color(0xFFE53935);
const Color ReadyColor = Color(0xFF1A7A4A);
Color StatusColor = Color(0xFFFFFFFF);
final List<String> Roles = ['Section Head', 'Engineer', 'Financial Manager'];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.nunito().fontFamily),
      home: SignInPage(), // start page
    );
  }
}
