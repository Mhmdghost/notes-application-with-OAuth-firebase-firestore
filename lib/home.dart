import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:test/EDIT.dart';
import 'package:test/note/view.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cat')
          .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (mounted) {
        setState(() {
          data.addAll(querySnapshot.docs);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("Error fetching data: $e");
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing operations or listeners here if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 30, 30, 30), // Dark theme background color
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.of(context).pushNamed('/Addcat');
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "HOME",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 20,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/screen2');
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : data.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/empty.png', height: 200), // Adjust path and size as needed
                      SizedBox(height: 20),
                      Text(
                        "No Categories Available",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => viewpage(catid: data[i].id),
                          ),
                        );
                      },
                      onLongPress: () {
                        PanaraConfirmDialog.show(
                          context,
                          title: "WARNING",
                          message: "WHAT DO YOU WANT TO DO?",
                          confirmButtonText: "EDIT",
                          cancelButtonText: "DELETE",
                          onTapCancel: () async {
                            await FirebaseFirestore.instance
                                .collection('cat')
                                .doc(data[i].id)
                                .delete();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Home()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          onTapConfirm: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditCat(
                                  oldname: data[i]['name'], // Pass the category name
                                  docid: data[i].id, // Pass the document ID
                                ),
                              ),
                            );
                          },
                          panaraDialogType: PanaraDialogType.warning,
                          barrierDismissible: true, // Allow dismissing the dialog by tapping outside
                        );
                      },
                      child: Card(
                        color: Color.fromARGB(255, 47, 47, 47), // Dark card color
                        margin: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/note.png',
                                height: 100,
                                // Color for image to match dark theme
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${data[i]['name']}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
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
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
    );
  }
}
