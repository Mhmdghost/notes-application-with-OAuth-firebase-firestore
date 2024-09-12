import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:test/note/add.dart';
import 'package:test/note/edit.dart';

class viewpage extends StatefulWidget {
  const viewpage({super.key, required this.catid});
  final String catid;

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => addnote(docid: widget.catid),
            ),
          ).then((_) {
            // Refresh data when returning from addnote
            setState(() {});
          });
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
      appBar: AppBar(
        
        backgroundColor: Colors.blueGrey,
        title: Text("YOUR NOTES",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 20,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/screen2');
            },
            icon: Icon(Icons.exit_to_app,color: Colors.white,),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cat')
            .doc(widget.catid)
            .collection("note")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?.docs ?? [];

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromARGB(255, 30, 30, 30) ,
            child: GridView.builder(
              itemBuilder: (context, i) {
                return InkWell(
                  onLongPress: () {
                    PanaraConfirmDialog.show(
                      context,
                      
                      title: "WARNING",
                      color: Colors.cyan,
                      message: "WHAT DO YOU WANT TO DO?",
                      confirmButtonText: "EDIT",
                      cancelButtonText: "DELETE",
                      
                      onTapCancel: () async {
                        // Handle delete
                        try {
                          await FirebaseFirestore.instance
                            .collection('cat')
                            .doc(widget.catid)
                            .collection("note")
                            .doc(data[i].id)
                            .delete();
                        } catch (e) {
                          print("Delete failed: $e");
                        }
                      },
                      onTapConfirm: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => editnote(
                              notedocid: data[i].id,
                              catdocid: widget.catid,
                              value: data[i]['name'],
                            ),
                          ),
                        ).then((_) {
                          // Refresh data when returning from editnote
                          setState(() {});
                        });
                      },
                      panaraDialogType: PanaraDialogType.custom,
                      
                      barrierDismissible: true,
                    );
                  },
                  child: Card(
                    color: Color.fromARGB(255, 47, 47, 47),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "${data[i]['name']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
            ),
          );
        },
      ),
    );
  }
}
