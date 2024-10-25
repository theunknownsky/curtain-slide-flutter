import 'package:curtainslide/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:curtainslide/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  String wrongCreds = "";

  TextStyle onlyInter = const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
  );
  TextStyle ctnsldCredStyle = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    color: Colors.white,
  );
  TextStyle welcomeStyle = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 36,
    color: Colors.white,
  );
  TextStyle ctnsldStyle = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 48,
    color: Colors.white,
    fontWeight: FontWeight.w900,
  );

  final FirebaseAuthServices _auth = FirebaseAuthServices();

  TextEditingController _ctnsldEmailController = TextEditingController();
  TextEditingController _ctnsldPasswordController = TextEditingController();

  @override
  void dispose() {
    _ctnsldEmailController.dispose();
    _ctnsldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF191919),
        title: Text(
          "Login",
          style: onlyInter,
        ),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          color: Color(0xFF383838),

          padding: const EdgeInsets.only(top: 100.0),
          child: Column(
            children: [
              Text(
                "Welcome to",
                style: welcomeStyle,
              ),
              Text(
                "CurtainSlide",
                style: ctnsldStyle,
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Text(
                  "Enter CurtainSlide Credentials",
                  style: ctnsldCredStyle,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(40, 8, 40, 0),
                      child: TextFormField(
                        controller: _ctnsldEmailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD9D9D9))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD9D9D9))),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          filled: true,
                          fillColor: Color(0xFF191919),
                          labelText: "CurtainSlide Email",
                          errorStyle: onlyInter,
                          hintStyle: onlyInter,
                          labelStyle: onlyInter,
                          floatingLabelStyle: onlyInter,
                        ),
                        style: onlyInter,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a CurtainSlide Email';
                          } else if (!value.endsWith("ctnsld.co")) {
                            return 'Please enter a valid CurtainSlide Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(40, 8, 40, 0),
                      child: TextFormField(
                        controller: _ctnsldPasswordController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD9D9D9))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD9D9D9))),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          filled: true,
                          fillColor: Color(0xFF191919),
                          labelText: "CurtainSlide Password",
                          errorStyle: onlyInter,
                          hintStyle: onlyInter,
                          labelStyle: onlyInter,
                          floatingLabelStyle: onlyInter,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        style: onlyInter,
                        obscureText: _obscureText,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: FilledButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            print("Everything is valid. Now go auth.");
                            _ctnsldSignIn();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.green.shade600,
                          ),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 140),
                          ),
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  wrongCreds,
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ctnsldSignIn() async {
    String email = _ctnsldEmailController.text;
    String password = _ctnsldPasswordController.text;

    User? user = await _auth.signInCtnSldCredentials(email, password);

    if (user != null) {
      print("${email} has successfully logged in.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        wrongCreds = "Wrong credentials.";
      });
    }
  }
}
