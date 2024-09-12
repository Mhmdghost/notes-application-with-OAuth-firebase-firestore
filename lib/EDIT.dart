import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/home.dart';

class EditCat extends StatefulWidget {
  final String oldname;
  final String docid;

  const EditCat({super.key, required this.oldname, required this.docid});

  @override
  State<EditCat> createState() => _EditCatState();
}

class _EditCatState extends State<EditCat> {
  final TextEditingController textform = TextEditingController();
  final CollectionReference cat = FirebaseFirestore.instance.collection('cat');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> editCategory() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await cat.doc(widget.docid).update({
          "name": textform.text,
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
  void initState() {
    super.initState();
    textform.text = widget.oldname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.blueGrey,
        elevation: 4.0, 
       
        title: const Text(
          'Edit Category',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromARGB(255, 30, 30, 30),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset('images/edit.png'
              ,width: 400,height: 400,),
              SizedBox(height: 30,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Edit your category:',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  controller: textform,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 50),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MaterialButton(
                  onPressed: editCategory,
                  child: const Text("SAVE"),
                  color:  Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
