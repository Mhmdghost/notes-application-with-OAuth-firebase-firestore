import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MYSCR1());
}

class MYSCR1 extends StatefulWidget {
  const MYSCR1({super.key});

  @override
  State<MYSCR1> createState() => _MYSCR1State();
}

class _MYSCR1State extends State<MYSCR1> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  void _showErrorDialog(String message) {
    PanaraInfoDialog.show(
      context,
      title: "Error",
      message: message,
      buttonText: "Okay",
      onTapDismiss: () {
        Navigator.of(context).pop();
      },
      panaraDialogType: PanaraDialogType.warning,
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Color.fromARGB(255, 30, 30, 30),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    height: 200,
                    width: 600,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      children: [
                         SizedBox(width: 25,),
                        Image.asset("images/login.png"),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 65,
                    width: double.infinity,
                    child: const Text(
                      " Login",
                      style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    child: const Text(
                      "   Login to continue using the app",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 40,
                    width: double.infinity,
                    child: const Text(
                      "  Email",
                      style: TextStyle(fontSize: 27, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 400,
                    margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: TextFormField(
                      enabled: true,
                      controller: email,
                      decoration: InputDecoration(
                        
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 40,
                    width: double.infinity,
                    child: const Text(
                      "  Password",
                      style: TextStyle(fontSize: 27, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 400,
                    margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: TextFormField(
                      enabled: true,
                      controller: password,
                      decoration: InputDecoration(
                        
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onPressed: () async {
                        if (email.text.isEmpty) {
                          _showErrorDialog('Please enter your email address.');
                        } else {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                            PanaraInfoDialog.show(
                              context,
                              title: "Success",
                              message: "An email has been sent to your email.",
                              buttonText: "Okay",
                              onTapDismiss: () {
                                Navigator.of(context).pop();
                              },
                              panaraDialogType: PanaraDialogType.success,
                              barrierDismissible: true,
                            );
                          } catch (e) {
                            _showErrorDialog('Failed to send password reset email. Please try again.');
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 50,
                      width: 200,
                      child: MaterialButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                            Navigator.of(context).pushReplacementNamed('/home');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              _showErrorDialog('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              _showErrorDialog('Wrong password provided for that user.');
                            } else {
                              _showErrorDialog('Error: ${e.message}');
                            }
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(height: 4,),
                  Container(
                    width: double.infinity,
                    height: 20,
                    alignment: Alignment.center,
                    child: const Text("Or Login with:", style: TextStyle(color: Colors.white)),
                  ),
                  
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                              if (googleUser == null) {
                                _showErrorDialog('Google sign-in failed.');
                                return;
                              }
                              // Handle Google Sign-In result if needed (e.g., get credential, sign in to Firebase)
                            } catch (e) {
                              _showErrorDialog('Failed to sign in with Google.');
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          shape: const CircleBorder(),
                          elevation: 4,
                          child: Image.asset("images/google.png", fit: BoxFit.fill),
                        ),
                      ],
                    ),
                  ),
                 
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "You Don't Have Account? ",
                          style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/screen1');
                          },
                          child: const Text(
                            " Register ",
                            style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
