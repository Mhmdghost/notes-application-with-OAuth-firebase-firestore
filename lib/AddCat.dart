import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/home.dart';

class Addcat extends StatefulWidget {
  const Addcat({super.key});

  @override
  State<Addcat> createState() => _AddcatState();
}

class _AddcatState extends State<Addcat> {
  final TextEditingController textform = TextEditingController();
  final CollectionReference cat = FirebaseFirestore.instance.collection('cat');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> addCatigore() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await cat.add({
          "name": textform.text,
          "id": FirebaseAuth.instance.currentUser!.uid,
        });
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()), 
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        print("Something went wrong: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'ADD CATEGORY',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 20,
      ),
      body: Container(
        color: Color.fromARGB(255, 30, 30, 30), // Dark background color
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(),
              Image.asset('images/empty.png',height: 250,),
              
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 60, 60, 60), // Lighter color for text field
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Add your category:',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white54), // Lighter hint text color
                  ),
                  controller: textform,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 50),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MaterialButton(
                  onPressed: addCatigore,
                  child: Text(
                    "ADD",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blueGrey,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
