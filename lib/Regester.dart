import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MYSCR2 extends StatefulWidget {
  const MYSCR2({super.key});

  @override
  State<MYSCR2> createState() => _MYSCR2State();
}

class _MYSCR2State extends State<MYSCR2> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 30, 30, 30), // Dark theme background color
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60), // Adjust top spacing as needed
              Image.asset(
                "images/Register.png",
                width: 250, // Increase image size
                height: 250, // Increase image size
              ),
              const SizedBox(height: 20),
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Dark theme text color
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sign up to continue using the app",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey, // Light gray for subtitle
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: usernameController,
                        label: "Username",
                      ),
                      const SizedBox(height: 20), // Increase space between fields
                      _buildTextField(
                        controller: emailController,
                        label: "Email",
                      ),
                      const SizedBox(height: 20), // Increase space between fields
                      _buildTextField(
                        controller: passwordController,
                        label: "Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 30), // Space before button
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: MaterialButton(
                          height: 50,
                          minWidth: 250,
                          color: Colors.blue, // Button color
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              Navigator.of(context).pushReplacementNamed('/home');
                            } on FirebaseAuthException catch (e) {
                              String message = '';
                              if (e.code == 'weak-password') {
                                message = 'The password provided is too weak.';
                              } else if (e.code == 'email-already-in-use') {
                                message = 'The account already exists for that email.';
                              }
                              _showErrorDialog(message);
                            } catch (e) {
                              _showErrorDialog(e.toString());
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Spacer to push the text to the bottom
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "You already have an account? ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Dark theme text color
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Button text color
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Bottom spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
  }) {
    return Container(
      width: double.infinity,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white), // Dark theme text color
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey), // Light gray for label
          filled: true,
          fillColor: Colors.grey[800], // Darker background for text fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
