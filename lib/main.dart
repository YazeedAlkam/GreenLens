import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/authentication/sign_in.dart';
import 'package:greenlens/authentication/sign_up.dart';
import 'package:greenlens/section_head_pages/assign_engineers/assign_engineers_flow.dart';
import 'package:greenlens/section_head_pages/create_new_project/create_new_project_flow.dart';
import 'package:greenlens/section_head_pages/section_head_dashboard.dart';
import 'ceo_pages/ceo_dashboard.dart';
import 'engineer_pages/engineer_dashboard.dart';
import 'firebase/firebase_options.dart';

/*
everytime you want to add changes to git hub we use this : 
git add .
git commit -m "describe your change"
git push

go to github and then pull req
check if conflict happened 
if no conf merge it 
then do this : 
git checkout main
git pull origin main
git checkout yazeed
git merge main
git push origin yazeed

*/

const Color textcolor = Color(0xFFA8A6A7);
const Color primaryColor = Color(0xFF1A237E);
const Color secondaryColor = Color(0xFFA8A6A7);
const Color backgroundColor = Color(0xFFFFFCED);
const Color signupButtonColor = Color(0xFF222222);
const Color dashButtonColor = Color(0xFF393C5A);
const Color inProgressColor = Color(0xFF8A90CE);
const Color awaitingApprovalColor = Color(0xFFEB9D4A);
const Color loginButtonColorInSignUpPage = Color(0xFFD87234);
const Color draftColor = Color(0xFFBFC0CD);
const Color deniedColor = Color(0xFFE53935);
const Color readyColor = Color(0xFF1A7A4A);
const Color disableColor = Color(0xFFe0e0e0);
const Color dividerColor = Color(0xFFA8A6A7);
const Color addengColor = Color(0xFFe8f5e9);
const Color removeEngColor = Color(0xFFffe6e6);
const Color tablelinescolor = Color(0xFF808080);
Color statusColor = Color(0xFFFFFFFF);
const Color addclientbuttoncolor = Color(0xFF2D264B);
final List<String> roles = ['Section Head', 'Engineer', 'Financial Manager'];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // Add your other routes here, for example:
        // '/home': (context) => HomePage(),
        // '/dashboard': (context) => DashboardPage(),
        '/sign_up': (context) => SignUp(),
        '/section_head_dashboard': (context) => SectionHeadPage(),
        '/engineer_dashboard': (context) => EngineerPage(),
        '/ceo_dashboard': (context) => CEOPage(),
        '/create_new_project': (context) => CreateProjectFlow(),
        '/assign_engineers': (context) => AssignEngineersFlow()
      },
      theme: ThemeData(fontFamily: GoogleFonts.nunito().fontFamily),
      home: SignInPage(), // start page
    );
  }
}
