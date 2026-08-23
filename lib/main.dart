import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/authentication/sign_in.dart';
import 'package:greenlens/authentication/sign_up.dart';
import 'package:greenlens/section_head_pages/assign_engineers/assign_engineers_flow.dart';
import 'package:greenlens/section_head_pages/create_new_project/create_new_project_flow.dart';
import 'package:greenlens/section_head_pages/section_head_dashboard.dart';
import 'package:greenlens/shared_files/profile_page.dart';
import 'ceo_pages/ceo_dashboard.dart';
import 'engineer_pages/engineer_dashboard.dart';
import 'firebase/firebase_options.dart';

// ── App-wide color palette ────────────────────────────────────────────────────
// All colors are defined here so changing a color propagates to every screen.

/// Muted grey used for placeholder and secondary text throughout the app.
const Color textcolor = Color(0xFFA8A6A7);

/// Deep indigo — the primary brand color used for headings, buttons, and accents.
const Color primaryColor = Color(0xFF1A237E);

/// Alias for [textcolor]; used as a secondary/muted UI tint.
const Color secondaryColor = Color(0xFFA8A6A7);

/// Warm off-white used as the background color on most screens.
const Color backgroundColor = Color(0xFFFFFCED);

/// Dark button color used on the sign-in/sign-up primary action button.
const Color signupButtonColor = Color(0xFF222222);

/// Dark blue-grey used for the main dashboard navigation buttons.
const Color dashButtonColor = Color(0xFF393C5A);

/// Soft purple badge color for projects with "In Progress" status.
const Color inProgressColor = Color(0xFF8A90CE);

/// Amber badge color for projects awaiting CEO or Section Head approval.
const Color awaitingApprovalColor = Color(0xFFEB9D4A);

/// Orange used for the "Login" link on the sign-up page.
const Color loginButtonColorInSignUpPage = Color(0xFFD87234);

/// Light grey badge color for Draft projects.
const Color draftColor = Color(0xFFBFC0CD);

/// Red badge color for Denied projects.
const Color deniedColor = Color(0xFFE53935);

/// Green badge color for Ready (approved) projects.
const Color readyColor = Color(0xFF1A7A4A);

/// Light grey fill applied to read-only / disabled form fields.
const Color disableColor = Color(0xFFe0e0e0);

/// Muted grey used for horizontal dividers throughout the app.
const Color dividerColor = Color(0xFFA8A6A7);

/// Light green tint highlighting engineer rows being added to a project.
const Color addengColor = Color(0xFFe8f5e9);

/// Light red tint highlighting engineer rows being removed from a project.
const Color removeEngColor = Color(0xFFffe6e6);

/// Medium grey used for table border and cell divider lines.
const Color tablelinescolor = Color(0xFF808080);

/// Mutable global that holds the most recently computed project status badge color.
Color statusColor = Color(0xFFFFFFFF);

/// Dark purple used as the background for "Add Contact" action buttons.
const Color addclientbuttoncolor = Color(0xFF2D264B);

/// Selectable roles shown in the sign-up screen dropdown.
/// CEO is added dynamically when no CEO account exists yet.
final List<String> roles = ['Section Head', 'Engineer'];
// if you want a new role add to the list:
// final List<String> roles = ['Section Head', 'Engineer', 'Role'];

/// Effective tariff (JOD per kWh) used everywhere the app converts energy
/// consumption into money: review tables, charts, and savings calculations
/// all multiply kWh by this. Starts at the national default (0.12) but is
/// overwritten with the project-specific value calculated from that
/// project's bills as soon as BillsBody recalculates.
const double energyTariffJodPerKwh = 0.12;

/// App entry point. Initializes Firebase before running the widget tree.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

/// Root widget. Defines the named route table and global theme.
///
/// Route → Dashboard mapping:
///   /sign_up                 → SignUp
///   /section_head_dashboard  → SectionHeadPage
///   /engineer_dashboard      → EngineerPage
///   /ceo_dashboard           → CEOPage
///   /create_new_project      → CreateProjectFlow
///   /assign_engineers        → AssignEngineersFlow
///
/// Home (starting screen) is SignInPage, which redirects to the correct
/// dashboard based on the user's role after a successful login.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/sign_up': (context) => SignUp(),
        '/section_head_dashboard': (context) => SectionHeadPage(),
        '/engineer_dashboard': (context) => EngineerPage(),
        '/ceo_dashboard': (context) => CEOPage(),
        '/create_new_project': (context) => CreateProjectFlow(),
        '/assign_engineers': (context) => AssignEngineersFlow(),
      },
      theme: ThemeData(fontFamily: GoogleFonts.nunito().fontFamily),
      home: SignInPage(), // start page
    );
  }
}
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