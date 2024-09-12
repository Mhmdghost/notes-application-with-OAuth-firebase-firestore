import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class editnote extends StatefulWidget {
  const editnote({
    super.key,
    required this.notedocid,
    required this.catdocid,
    required this.value,
  });

  final String notedocid;
  final String catdocid;
  final String value;

  @override
  State<editnote> createState() => _editnoteState();
}

class _editnoteState extends State<editnote> {
  final TextEditingController note = TextEditingController();
  final CollectionReference cat = FirebaseFirestore.instance.collection('cat');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> updateNote() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        print("Updating note with ID: ${widget.notedocid}");
        print("New note value: ${note.text}");

        await cat
            .doc(widget.catdocid)
            .collection("note")
            .doc(widget.notedocid)
            .update({
          'name': note.text,
        });

        Navigator.of(context).pop(true); // Signal that data needs to be refreshed
      } catch (e) {
        print("Something went wrong: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    note.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 4.0,
       
        title: const Text('Edit Note',style: TextStyle(color: Colors.white),),
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
              Image.asset('images/edit.png',width: 400,height: 400,),
              
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
                  controller: note,
                  style: const TextStyle(color: Colors.white),
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
                  onPressed: updateNote,
                  child: Text("UPDATE",style: TextStyle(color: Colors.white),),
                  color: Colors.blueGrey,
                  textColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
