import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class addnote extends StatefulWidget {
  const addnote({super.key, required this.docid});
  final String docid;

  @override
  State<addnote> createState() => _AddcatState();
}

class _AddcatState extends State<addnote> {
  final TextEditingController note = TextEditingController();
  final CollectionReference cat = FirebaseFirestore.instance.collection('cat');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> addCatigore() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await cat.doc(widget.docid).collection("note").add({
          'name': note.text, // Add new note to Firestore
          
        });
        Navigator.of(context).pop(true); // Signal that data needs to be refreshed
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
        elevation: CircularProgressIndicator.strokeAlignCenter,
        
        title: const Text(
          'Add Your note ',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromARGB(255, 30, 30, 30),  
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              Image.asset('images/addnote.png'),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20), // Margin to expand left and right
                decoration: BoxDecoration(
                color: Color.fromARGB(255, 47, 47, 47),           borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: TextFormField(
                   
                  decoration: InputDecoration(
                    hintText: 'Add your Note:',
                    hintStyle: TextStyle(color: Colors.white),
                   
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Increased padding
                    border: InputBorder.none, // Remove default border
                  ),
                  
                  controller: note,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      
                      return 'Please enter your note:';
                      
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MaterialButton(
                  onPressed: addCatigore,
                  child: Text("ADD",style: TextStyle(color: Colors.white),),
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
