import 'package:curtainslide/firebase_auth_implementation/firebase_auth_services.dart';
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
        backgroundColor: Colors.black,
        title: Text("Login"),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Column(
            children: [
              const Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 36,
                ),
              ),
              const Text(
                "CurtainSlide",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: const Text(
                  "Enter CurtainSlide Credentials",
                  style: TextStyle(
                    fontSize: 24,
                  ),
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "CurtainSlide Email",
                        ),
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
                          border: const OutlineInputBorder(),
                          labelText: "CurtainSlide Password",
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
                        obscureText: _obscureText,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
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

    if (user != null){
      print("${email} has successfully logged in.");
    } else {
      print("An internal error occured.");
    }
  }
}