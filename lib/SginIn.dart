import 'package:flutter/material.dart';
import 'package:greenlens/SignUp.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 48.0,
          bottom: 0,
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Enter your email and password",
                style: TextStyle(fontSize: 16, color: textcolor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(320, 0, 320, 0),
                child: TextField(
                  //this for name input
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
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(320, 0, 320, 0),
                child: TextField(
                  obscureText: _obsecureTextSignIn,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: textcolor),
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
              ),
              SizedBox(height: 16),
              //forgot password row
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 170,
                  top: 0,
                  bottom: 0,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(450, 0, 100, 0),
                  child: SizedBox(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // Navigate to login page
                      },
                      child: const Text(
                        'Forgot the password?',
                        style: TextStyle(
                          color: PrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              SizedBox(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SignupButtonColor,
                    padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: SizedBox(
                    height: 25,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SignupButtonColor,
                        padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        '   LOGIN',
                        style: TextStyle(color: Colors.white, fontSize: 21),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dont have an account?',
                    style: TextStyle(color: Colors.black),
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
                      style: TextStyle(color: LoginButtonColorInSignUpPage),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
